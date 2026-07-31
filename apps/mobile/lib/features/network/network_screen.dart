// ─── Yugrow Network Screen ──────────────────────────────────────
// "What did I build?"
// Organizes relationships by state: Needs follow-up, Active conversations,
// and By Event (events as relationship memory).
// No flat list. No chronology. Relationship nurturing.

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yugrow_mobile/core/api/api_client.dart';
import 'package:yugrow_mobile/core/auth/auth_service.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';

class NetworkScreen extends ConsumerStatefulWidget {
  const NetworkScreen({super.key});

  @override
  ConsumerState<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends ConsumerState<NetworkScreen> {
  final _api = ApiClient();
  bool _loading = true;
  List<Map<String, dynamic>> _conversations = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final pid = ref.read(authProvider).person?['id'] as String?;
    if (pid == null) return;
    setState(() => _loading = true);
    try {
      final convos = await _api.getConversations(pid);
      // AH-020: Exclude system conversations — they're shown via _buildYugrowTile
      final filtered = convos.where((c) {
        final ctx = (c as Map<String, dynamic>)['contextType'] as String?;
        return ctx != 'system';
      }).toList();
      if (mounted) {
        setState(() {
          _conversations = filtered.cast<Map<String, dynamic>>();
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Network'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // ── Yugrow System Conversation ────────────────────
            _sectionHeader('Yugrow', Icons.favorite),
            const SizedBox(height: AppSpacing.sm),
            _buildYugrowTile(theme),
            const SizedBox(height: AppSpacing.xl),

            // ── Needs Follow-up ────────────────────────────────
            _sectionHeader('Needs Follow-up', Icons.watch_later_outlined),
            const SizedBox(height: AppSpacing.sm),
            _buildEmptySlot('Connections requiring attention will appear here.',
                Icons.flag_outlined, theme),
            const SizedBox(height: AppSpacing.xl),

            // ── Recent Conversations ──────────────────────────
            _sectionHeader('Active Conversations', Icons.chat_outlined),
            const SizedBox(height: AppSpacing.sm),
            if (_loading)
              const Center(child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: CircularProgressIndicator(strokeWidth: 2),
              ))
            else if (_conversations.isEmpty)
              _buildEmptySlot('Start a conversation by connecting with someone at an event.',
                  Icons.chat_bubble_outline, theme)
            else
              ..._conversations.map((c) => _buildConversationTile(c, theme)),
            const SizedBox(height: AppSpacing.xl),

            // ── By Event ───────────────────────────────────────
            _sectionHeader('By Event', Icons.event_outlined),
            const SizedBox(height: AppSpacing.sm),
            _buildEmptySlot(
              'Events you attend will appear here. '
              'Each event becomes a folder containing the people you met, '
              'conversations, and connections that are still active.',
              Icons.folder_outlined, theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySlot(String message, IconData icon, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: AppRadius.mdCircular,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: theme.disabledColor),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: theme.disabledColor),
          ),
        ],
      ),
    );
  }

  Widget _buildYugrowTile(ThemeData theme) {
    return Card(
      color: theme.primaryColor.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.mdCircular,
        side: BorderSide(color: theme.primaryColor.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        leading: CircleAvatar(
          backgroundColor: theme.primaryColor.withValues(alpha: 0.15),
          child: Icon(Icons.favorite, color: theme.primaryColor, size: 20),
        ),
        title: Text('Yugrow',
            style: TextStyle(fontWeight: FontWeight.w600, color: theme.primaryColor)),
        subtitle: Text('Your direct line to the team',
            style: TextStyle(fontSize: 12, color: theme.disabledColor)),
        trailing: const Icon(Icons.chevron_right, size: 18),
        onTap: () => _openYugrowChat(),
      ),
    );
  }

  Future<void> _openYugrowChat() async {
    final pid = ref.read(authProvider).person?['id'] as String?;
    if (pid == null) return;
    try {
      final result = await _api.initSystemConversation(pid);
      final sysConvId = result['conversationId'] as String?;
      if (sysConvId != null) {
        if (mounted) context.push('/conversations/$sysConvId');
      }
    } catch (_) {}
  }

  Widget _buildConversationTile(Map<String, dynamic> conversation, ThemeData theme) {
    final id = conversation['id'] as String? ?? '';
    final otherPerson = conversation['otherPersonName'] as String? ?? 'Chat';
    final lastMsg = (conversation['messages'] as List<dynamic>?)?.firstOrNull as Map<String, dynamic>?;
    final lastContent = lastMsg?['content'] as String? ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
          child: Text(
            otherPerson.isNotEmpty ? otherPerson[0].toUpperCase() : '?',
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
        ),
        title: Text(otherPerson, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: lastContent.isNotEmpty
            ? Text(lastContent, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(color: theme.disabledColor, fontSize: 13))
            : null,
        trailing: const Icon(Icons.chevron_right, size: 18),
        onTap: () => context.push('/conversations/$id'),
      ),
    );
  }
}
