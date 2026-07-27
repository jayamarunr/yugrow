import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/environment.dart';

class ApiClient {
  late final Dio _dio;
  final _storage = const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';

  // Cached auth context for API calls that need it
  String? personId;
  String? workspaceId;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: '${Environment.apiBaseUrl}/api/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: _tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        if (Environment.flavor == 'development') {
          debugPrint('[API] ${options.method} ${options.path}');
        }
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Token expired — redirect to login
          // Handled by auth provider
        }
        // Enhanced error logging for debugging
        if (Environment.flavor == 'development') {
          final method = error.requestOptions.method;
          final path = error.requestOptions.path;
          final baseUrl = error.requestOptions.baseUrl;
          final statusCode = error.response?.statusCode;
          final statusMsg = error.response?.statusMessage;
          final body = error.response?.data;
          debugPrint('''
[API Error] ───────────────────────
  $method $baseUrl$path
  Status: ${statusCode ?? 'No response'} ${statusMsg ?? ''}
  Type: ${error.type}
  Message: ${error.message}
  ${body != null ? 'Body: $body' : ''}
─────────────────────────────────''');
        }
        handler.next(error);
      },
    ));
  }

  // ── Venue ────────────────────────────────────────────────────

  Future<List<dynamic>> searchVenues(String query) async {
    final res = await _dio.get('/checkin/venues/search', queryParameters: {'q': query});
    return res.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> createVenue(Map<String, dynamic> data) async {
    final res = await _dio.post('/checkin/venues', data: data);
    return res.data as Map<String, dynamic>;
  }

  // ── Event ────────────────────────────────────────────────────

  Future<List<dynamic>> getActiveEvents() async {
    final res = await _dio.get('/checkin/events');
    return res.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> getEvent(String id) async {
    final res = await _dio.get('/checkin/events/$id');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>?> getPublicEvent(String id) async {
    try {
      final res = await _dio.get('/checkin/events/$id/public');
      return res.data as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  // ── Founder Mode: Event Management ────────────────────────────

  Future<Map<String, dynamic>> createEvent(Map<String, dynamic> data) async {
    final res = await _dio.post('/checkin/events', data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateEvent(String id, Map<String, dynamic> data) async {
    final res = await _dio.patch('/checkin/events/$id', data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> expireEvent(String id) async {
    final res = await _dio.post('/checkin/events/$id/expire');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> duplicateEvent(String id, {String? name}) async {
    final res = await _dio.post('/checkin/events/$id/duplicate', data: name != null ? {'name': name} : {});
    return res.data as Map<String, dynamic>;
  }

  // ── Founder Mode: Test Tools ──────────────────────────────────

  Future<Map<String, dynamic>> seedTestAttendees(String eventId, {int count = 20}) async {
    final res = await _dio.post('/checkin/test/seed', data: {
      'eventId': eventId,
      'count': count,
    });
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> clearPresence({String? eventId}) async {
    final data = eventId != null ? {'eventId': eventId} : <String, dynamic>{};
    final res = await _dio.post('/checkin/test/clear-presence', data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> resetDemoData() async {
    final res = await _dio.post('/checkin/test/reset');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getTestStatus() async {
    final res = await _dio.get('/checkin/test/status');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> generateTestConversations(String eventId) async {
    final res = await _dio.post('/checkin/test/generate-conversations', data: {'eventId': eventId});
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> forceCheckIn(Map<String, dynamic> data) async {
    final res = await _dio.post('/checkin/test/force-checkin', data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> founderLogin() async {
    final res = await _dio.post('/checkin/test/login');
    return res.data as Map<String, dynamic>;
  }

  // ── Presence ─────────────────────────────────────────────────

  Future<Map<String, dynamic>> checkIn(Map<String, dynamic> data) async {
    final res = await _dio.post('/checkin/presence', data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>?> getActivePresence(String personId) async {
    try {
      final res = await _dio.get('/checkin/presence/active', queryParameters: {'personId': personId});
      return res.data as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  // ── Live Discovery ───────────────────────────────────────────

  Future<List<dynamic>> getLiveAttendees(String eventId, {String? viewerPersonId}) async {
    final params = <String, dynamic>{};
    if (viewerPersonId != null) params['viewerPersonId'] = viewerPersonId;
    final res = await _dio.get('/checkin/live/$eventId', queryParameters: params);
    return res.data as List<dynamic>;
  }

  // ── Connections ──────────────────────────────────────────────

  Future<Map<String, dynamic>> sendConnectionRequest(Map<String, dynamic> data) async {
    final res = await _dio.post('/checkin/connections', data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> acceptRequest(String requestId, String personId) async {
    final res = await _dio.post('/checkin/connections/$requestId/accept', data: {'personId': personId});
    return res.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getIncomingRequests(String personId) async {
    final res = await _dio.get('/checkin/connections/incoming/$personId');
    return res.data as List<dynamic>;
  }

  // ── Conversations ────────────────────────────────────────────

  Future<List<dynamic>> getConversations(String personId) async {
    final res = await _dio.get('/conversations', queryParameters: {'personId': personId});
    return res.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> getConversation(String id, String personId) async {
    final res = await _dio.get('/conversations/$id', queryParameters: {'personId': personId});
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getConversationContext(String id) async {
    final res = await _dio.get('/conversations/$id/context');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> sendMessage(String conversationId, String senderPersonId, String content) async {
    final res = await _dio.post('/conversations/$conversationId/messages', data: {
      'senderPersonId': senderPersonId,
      'content': content,
    });
    return res.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getMessages(String conversationId, String personId) async {
    final res = await _dio.get('/conversations/$conversationId/messages', queryParameters: {'personId': personId});
    return res.data as List<dynamic>;
  }

  // ── Professional Identity ────────────────────────────────────

  Future<Map<String, dynamic>> getProfessionalIdentity(String workspaceId) async {
    final res = await _dio.get('/identity/professional/$workspaceId');
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateProfessionalIdentity(String workspaceId, Map<String, dynamic> data) async {
    final res = await _dio.patch('/identity/professional/$workspaceId', data: data);
    return res.data as Map<String, dynamic>;
  }

  // ── Auth ─────────────────────────────────────────────────────

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _dio.post('/identity/auth/login', data: {
      'email': email,
      'password': password,
    });
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> register(String email, String password, String name) async {
    final res = await _dio.post('/identity/auth/register', data: {
      'email': email,
      'password': password,
      'name': name,
    });
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>?> getCurrentPerson() async {
    try {
      final res = await _dio.get('/identity/people/me');
      return res.data as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  Future<void> setAuthToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> clearAuth() async {
    await _storage.delete(key: _tokenKey);
  }
}
