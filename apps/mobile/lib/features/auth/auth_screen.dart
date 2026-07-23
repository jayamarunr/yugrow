import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneController = TextEditingController();
  bool _otpMode = false;
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _submitPhone() {
    if (_phoneController.text.length >= 10) {
      setState(() => _otpMode = true);
      // TODO: Integrate with SMS provider to send actual OTP
      // For demo, any 4-digit code works
    }
  }

  void _submitOtp() {
    if (_otpController.text.length >= 4) {
      context.go('/');
    }
  }

  void _resendOtp() {
    // TODO: Call SMS provider to resend OTP
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP resent (demo: any 4-digit code works)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(child: Text('Y', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(height: 24),
              Text('Yugrow', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('Build meaningful business relationships', style: theme.textTheme.bodyMedium),
              const Spacer(flex: 1),
              // Phone input
              if (!_otpMode) ...[
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Mobile number',
                    hintText: '+91 98765 43210',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _submitPhone, child: const Text('Send OTP')),
              ],
              // OTP input
              if (_otpMode) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: Colors.amber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Demo: any 4-digit code works',
                          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter OTP',
                    hintText: '1234',
                    prefixIcon: Icon(Icons.lock_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _submitOtp, child: const Text('Verify & Continue')),
                const SizedBox(height: 8),
                TextButton(onPressed: _resendOtp, child: const Text('Resend OTP')),
                TextButton(
                  onPressed: () => setState(() => _otpMode = false),
                  child: const Text('Change number'),
                ),
              ],
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
