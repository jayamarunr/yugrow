import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 48,
            backgroundColor: theme.primaryColor.withValues(alpha: 0.2),
            child: Text('J', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: theme.primaryColor)),
          ),
          const SizedBox(height: 16),
          Text('Jay', style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text('Founder', style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          _infoTile(theme, Icons.work_outline, 'Yugrow Technologies'),
          _infoTile(theme, Icons.location_on_outlined, 'Chennai, India'),
          _infoTile(theme, Icons.code_outlined, 'SaaS, AI, CRM'),
          const SizedBox(height: 24),
          Text('Skills', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: ['SaaS Development', 'AI', 'CRM', 'Product Strategy', 'Business Development'].map((s) => Chip(label: Text(s))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(ThemeData theme, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.disabledColor),
          const SizedBox(width: 12),
          Text(text, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
