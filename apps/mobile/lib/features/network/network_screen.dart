// ─── Yugrow Network Screen ──────────────────────────────────────
// "What did I build?"
// Organizes relationships by state: Needs follow-up, Active conversations,
// and By Event (events as relationship memory).
// No flat list. No chronology. Relationship nurturing.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yugrow_mobile/core/api/api_client.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  final _api = ApiClient();
  bool _loading = true;
  List<Map<String, dynamic>> _conversations = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final convos = await _api.getConversations('person-self');
      if (mounted) {
        setState(() {
          _conversations = convos.cast<Map<String, dynamic>>();
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
          padding: const EdgeInsets.all(16),
          children: [
            // ── Needs Follow-up ────────────────────────────────
            _sectionHeader('Needs Follow-up', Icons.watch_later_outlined),
            const SizedBox(height: 8),
            _buildEmptySlot('Connections requiring attention will appear here.',
                Icons.flag_outlined, theme),
            const SizedBox(height: 24),

            // ── Active Conversations ───────────────────────────
            _sectionHeader('Active Conversations', Icons.chat_outlined),
            const SizedBox(height: 8),
            if (_loading)
              const Center(child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(strokeWidth: 2),
              ))
            else if (_conversations.isEmpty)
              _buildEmptySlot('Start a conversation by connecting with someone at an event.',
                  Icons.chat_bubble_outline, theme)
            else
              ..._conversations.map((c) => _buildConversationTile(c, theme)),
            const SizedBox(height: 24),

            // ── By Event ───────────────────────────────────────
            _sectionHeader('By Event', Icons.event_outlined),
            const SizedBox(height: 8),
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
        Icon(icon, size: 18, color: const Color(0xFF0F766E)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F766E),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySlot(String message, IconData icon, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: theme.disabledColor),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: theme.disabledColor),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(Map<String, dynamic> conversation, ThemeData theme) {
    final id = conversation['id'] as String? ?? '';
    final otherPerson = conversation['otherPersonName'] as String? ?? 'Conversation';
    final lastMessage = conversation['lastMessage'] as String? ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF0F766E).withValues(alpha: 0.15),
          child: Text(
            otherPerson.isNotEmpty ? otherPerson[0].toUpperCase() : '?',
            style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w600),
          ),
        ),
        title: Text(otherPerson, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: lastMessage.isNotEmpty
            ? Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(color: theme.disabledColor, fontSize: 13))
            : null,
        trailing: const Icon(Icons.chevron_right, size: 18),
        onTap: () => context.push('/conversations/$id'),
      ),
    );
  }
}
