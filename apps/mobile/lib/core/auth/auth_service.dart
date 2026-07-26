// ─── AuthService ──────────────────────────────────────────────
// Central auth state management for Yugrow Alpha.
// Persists JWT to secure storage, exposes auth state.
//
// Flow:
//   Signup → Save JWT → Onboarding → Home
//   Login  → Save JWT → Home

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../../features/venue/services/venue_analytics.dart';

/// Auth state exposed to the UI.
class AuthState {
  final bool isAuthenticated;
  final bool isNewUser;        // true after signup, false after onboarding
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? person;
  final Map<String, dynamic>? workspace;
  final String? token;

  const AuthState({
    this.isAuthenticated = false,
    this.isNewUser = false,
    this.isLoading = false,
    this.error,
    this.person,
    this.workspace,
    this.token,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isNewUser,
    bool? isLoading,
    String? error,
    Map<String, dynamic>? person,
    Map<String, dynamic>? workspace,
    String? token,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isNewUser: isNewUser ?? this.isNewUser,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      person: person ?? this.person,
      workspace: workspace ?? this.workspace,
      token: token ?? this.token,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiClient _api;

  AuthNotifier(this._api) : super(const AuthState());

  /// Check if a stored token exists (e.g. on app launch).
  Future<void> checkSession() async {
    // Token is auto-attached by ApiClient interceptor.
    // Try calling /identity/people/me to verify it's still valid.
    state = state.copyWith(isLoading: true);
    try {
      final person = await _api.getCurrentPerson();
      if (person != null) {
        final ws = await _api.getProfessionalIdentity('personal');
        _api.personId = person['id'] as String?;
        _api.workspaceId = ws['id'] as String?;
        state = state.copyWith(
          isAuthenticated: true,
          isNewUser: false,
          isLoading: false,
          person: person,
          workspace: ws,
        );
        return;
      }
    } catch (_) {
      // Token missing or expired — stay unauthenticated
    }
    state = state.copyWith(isAuthenticated: false, isLoading: false);
  }

  /// Register a new account.
  Future<void> signup(String email, String password, String name) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _api.register(email, password, name);
      final token = result['token'] as String;
      await _api.setAuthToken(token);
      final person = result['person'] as Map<String, dynamic>?;
      final workspace = result['workspace'] as Map<String, dynamic>?;
      _api.personId = person?['id'] as String?;
      _api.workspaceId = workspace?['id'] as String?;
      state = state.copyWith(
        isAuthenticated: true,
        isNewUser: true,
        isLoading: false,
        token: token,
        person: person,
        workspace: workspace,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _parseAuthError(e),
      );
    }
  }

  /// Log in with existing credentials.
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _api.login(email, password);
      final token = result['token'] as String;
      await _api.setAuthToken(token);
      final person = result['person'] as Map<String, dynamic>?;
      final workspace = result['workspace'] as Map<String, dynamic>?;
      _api.personId = person?['id'] as String?;
      _api.workspaceId = workspace?['id'] as String?;
      state = state.copyWith(
        isAuthenticated: true,
        isNewUser: false,
        isLoading: false,
        token: token,
        person: person,
        workspace: workspace,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _parseAuthError(e),
      );
    }
  }

  /// Parse auth errors into user-friendly messages.
  String _parseAuthError(dynamic error) {
    try {
      // DioException with a response from the server
      if (error is DioException && error.response?.data != null) {
        final data = error.response!.data;
        if (data is Map<String, dynamic>) {
          // Structured error from backend
          if (data['error'] is Map<String, dynamic>) {
            final err = data['error'] as Map<String, dynamic>;
            final code = err['code'] as String?;
            final message = err['message'] as String?;
            if (code == 'EMAIL_ALREADY_EXISTS') {
              return message ?? 'An account already exists with this email.';
            }
            return message ?? 'Something went wrong. Please try again.';
          }
        }
        // HTTP status-based messages
        final statusCode = error.response?.statusCode;
        if (statusCode == 409) {
          return 'An account already exists with this email. Please sign in instead.';
        }
        if (statusCode == 401) {
          return 'Invalid email or password.';
        }
      }
      // Network error (no response from server)
      if (error is DioException && error.type == DioExceptionType.connectionError) {
        return 'Unable to connect. Check your internet connection and try again.';
      }
    } catch (_) {
      // Parsing failed — fall through to generic message
    }
    return 'Something went wrong. Please try again.';
  }

  /// Complete onboarding (update professional identity).
  Future<void> completeOnboarding({
    required String headline,
    required String company,
    required String designation,
    required String city,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final wsId = state.workspace?['id'] as String? ?? 'personal';
      await _api.updateProfessionalIdentity(wsId, {
        'headline': headline,
        'company': company,
        'designation': designation,
        'city': city,
      });
      VenueAnalytics.setPersonProperties(headline, company);
      state = state.copyWith(
        isNewUser: false,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Log out.
  Future<void> logout() async {
    await _api.clearAuth();
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void setPerson(Map<String, dynamic> person) {
    state = state.copyWith(person: person);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ApiClient());
});
