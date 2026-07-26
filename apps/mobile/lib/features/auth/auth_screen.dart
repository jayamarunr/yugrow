// ─── AuthScreen (Deprecated) ──────────────────────────────────
// ⚠️  Replaced by LoginScreen and SignupScreen.
//     This screen is kept for backward compatibility.
//     New code should use /auth/login and /auth/signup routes.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Redirect to login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/auth/login');
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
