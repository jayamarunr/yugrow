// ─── Yugrow Me (Profile + Settings) ──────────────────────────────
// "Who am I?"
// Professional identity, workspace switcher, settings, and Founder Console.
// No event history — events are relationship memory (belongs in Network).
// No relationship history — belongs in Network.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../debug/founder_console_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Me'),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Identity Card ────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: theme.primaryColor.withValues(alpha: 0.2),
                  child: Text('J',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.primaryColor)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jay', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text('Founder · Yugrow',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.disabledColor)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Looking For ──────────────────────────────────────
          _sectionHeader('Looking For', theme),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: const Row(
              children: [
                Icon(Icons.visibility_outlined, size: 18, color: Color(0xFF16A34A)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Co-founders, investors, and strategic partners for Yugrow.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF166534)),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit_outlined, size: 16, color: Color(0xFF16A34A)),
                  onPressed: null,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Workspace ────────────────────────────────────────
          _sectionHeader('Workspace', theme),
          _menuTile(theme, Icons.swap_horiz_outlined, 'Personal',
              'Switch to a different workspace'),
          const Divider(height: 1),
          _menuTile(theme, Icons.business_outlined, 'Create Workspace',
              'Start a new workspace for your company or community'),
          const SizedBox(height: 24),

          // ── Settings ─────────────────────────────────────────
          _sectionHeader('Settings', theme),
          _menuTile(theme, Icons.notifications_outlined, 'Notifications', ''),
          const Divider(height: 1),
          _menuTile(theme, Icons.lock_outlined, 'Privacy', ''),
          const Divider(height: 1),
          _menuTile(theme, Icons.palette_outlined, 'Appearance',
              Theme.of(context).brightness == Brightness.dark ? 'Dark' : 'Light'),
          const SizedBox(height: 24),

          // ── About ────────────────────────────────────────────
          _sectionHeader('About', theme),
          _menuTile(theme, Icons.info_outline, 'Version', '0.1.1-alpha'),
          const Divider(height: 1),
          _menuTile(theme, Icons.help_outline, 'Help', ''),
          const SizedBox(height: 8),

          // ── Founder Console (hidden) ─────────────────────────
          Center(
            child: TextButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FounderConsole()),
                );
              },
              icon: Icon(Icons.terminal_outlined, size: 16, color: theme.disabledColor),
              label: Text('Founder Console',
                style: TextStyle(fontSize: 12, color: theme.disabledColor)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: theme.primaryColor,
        ),
      ),
    );
  }

  Widget _menuTile(ThemeData theme, IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, size: 22, color: theme.disabledColor),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      subtitle: subtitle.isNotEmpty
          ? Text(subtitle, style: TextStyle(fontSize: 12, color: theme.disabledColor))
          : null,
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: () {},
    );
  }
}
