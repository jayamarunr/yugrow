// ─── Yugrow Me (Profile + Settings) ──────────────────────────────
// "Who am I?"
// Professional identity, workspace switcher, settings, and Founder Console.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/api/api_client.dart';
import '../../core/auth/auth_service.dart';
import '../debug/founder_console_screen.dart';
import 'widgets/profile_card.dart';
import 'screens/edit_profile_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _api = ApiClient();
  Map<String, dynamic>? _identity;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadIdentity();
  }

  Future<void> _loadIdentity() async {
    try {
      final identity = await _api.getProfessionalIdentity('personal');
      if (mounted) {
        setState(() {
          _identity = identity;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openEditor() async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          api: _api,
          existingIdentity: _identity,
        ),
      ),
    );
    if (changed == true) _loadIdentity();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Me'),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.only(top: 12, bottom: 32),
              children: [
                // Professional Profile Card
                ProfileCard(
                  name: _identity?['name'] as String? ??
                      ref.read(authProvider).person?['name'] as String? ??
                      'You',
                  headline: _identity?['title'] as String?,
                  company: _identity?['company'] as String?,
                  photoUrl: _identity?['avatarUrl'] as String?,
                  about: _identity?['bio'] as String?,
                  location: _identity?['city'] as String?,
                  website: _identity?['website'] as String?,
                  skills: List<String>.from(_identity?['skills'] as List? ?? []),
                  industries:
                      List<String>.from(_identity?['industries'] as List? ?? []),
                  onTap: _openEditor,
                  onEdit: _openEditor,
                ),
                const SizedBox(height: 24),

                // ── Workspace ──
                _sectionHeader('Workspace', theme),
                _menuTile(theme, Icons.swap_horiz_outlined, 'Personal',
                    'Switch to a different workspace', () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Workspace switching — coming soon')));
                }),
                const Divider(height: 1),
                _menuTile(theme, Icons.business_outlined, 'Create Workspace',
                    'Start a new workspace for your company or community', () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Create Workspace — coming soon')));
                }),
                const SizedBox(height: 24),

                // ── Settings ──
                _sectionHeader('Settings', theme),
                _menuTile(theme, Icons.notifications_outlined, 'Notifications', '', () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notifications — coming soon')));
                }),
                const Divider(height: 1),
                _menuTile(theme, Icons.lock_outlined, 'Privacy', '', () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Privacy settings — coming soon')));
                }),
                const Divider(height: 1),
                _menuTile(theme, Icons.palette_outlined, 'Appearance',
                    Theme.of(context).brightness == Brightness.dark ? 'Dark' : 'Light', () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appearance settings — coming soon')));
                }),
                const SizedBox(height: 24),

                // ── About ──
                _sectionHeader('About', theme),
                _menuTile(theme, Icons.info_outline, 'Version', '0.1.1-alpha', null),
                const Divider(height: 1),
                _menuTile(theme, Icons.help_outline, 'Help', '', () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Help — coming soon')));
                }),
                const SizedBox(height: 8),

                // ── Logout ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await ref.read(authProvider.notifier).logout();
                        if (mounted) context.go('/auth/login');
                      },
                      icon: const Icon(Icons.logout, size: 18),
                      label: const Text('Sign Out'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red[700],
                        side: BorderSide(color: Colors.red[200]!),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size.fromHeight(44),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // ── Founder Console ──
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const FounderConsole()),
                      );
                    },
                    icon: Icon(Icons.terminal_outlined,
                        size: 16, color: theme.disabledColor),
                    label: Text('Founder Console',
                        style:
                            TextStyle(fontSize: 12, color: theme.disabledColor)),
                  ),
                ),
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

  Widget _menuTile(
      ThemeData theme, IconData icon, String title, String subtitle, VoidCallback? onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, size: 22, color: theme.disabledColor),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      subtitle: subtitle.isNotEmpty
          ? Text(subtitle,
              style: TextStyle(fontSize: 12, color: theme.disabledColor))
          : null,
      trailing: onTap != null ? const Icon(Icons.chevron_right, size: 18) : null,
      onTap: onTap,
    );
  }
}
