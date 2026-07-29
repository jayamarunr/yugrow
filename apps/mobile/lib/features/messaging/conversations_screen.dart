import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/api/api_client.dart';
import '../../core/auth/auth_service.dart';

class ConversationsScreen extends ConsumerStatefulWidget {
  const ConversationsScreen({super.key});
  @override
  ConsumerState<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends ConsumerState<ConversationsScreen> {
  final _api = ApiClient();
  List<dynamic> _conversations = [];
  Map<String, dynamic>? _systemConversation;
  bool _loading = true;

  String? get _personId => ref.read(authProvider).person?['id'] as String?;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final pid = _personId;
    if (pid == null) return;
    try {
      // Load regular conversations
      final convos = await _api.getConversations(pid);

      // Load Yugrow system conversation
      Map<String, dynamic>? systemConv;
      try {
        final result = await _api.initSystemConversation(pid);
        final sysConvId = result['conversationId'] as String?;
        if (sysConvId != null) {
          systemConv = await _api.getConversation(sysConvId, pid);
        }
      } catch (_) {
        // System conversation may not be available — ignore
      }

      if (mounted) {
        // AH-019: Exclude system conversations from regular list
        final filtered = convos.where((c) {
          final ctx = (c as Map<String, dynamic>)['contextType'] as String?;
          if (systemConv != null) {
            final sysId = systemConv['id'] as String?;
            final convId = c['id'] as String?;
            if (sysId != null && convId == sysId) return false;
          }
          return ctx != 'system';
        }).toList();
        setState(() {
          _conversations = filtered;
          _systemConversation = systemConv;
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
    final hasSystemConv = _systemConversation != null;
    final hasRegularConvs = _conversations.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : !hasSystemConv && !hasRegularConvs
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_outlined, size: 64, color: theme.disabledColor),
                      const SizedBox(height: 16),
                      Text('No conversations yet', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('Connect with someone to start chatting', style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // ── Yugrow System Chat ───────────────────
                    if (hasSystemConv)
                      Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: theme.primaryColor.withValues(alpha: 0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: theme.primaryColor.withValues(alpha: 0.2)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: theme.primaryColor.withValues(alpha: 0.15),
                            child: Icon(Icons.favorite, color: theme.primaryColor, size: 20),
                          ),
                          title: Text(
                            'Yugrow',
                            style: TextStyle(fontWeight: FontWeight.w600, color: theme.primaryColor),
                          ),
                          subtitle: Text(
                            'Your direct line to the team',
                            style: TextStyle(fontSize: 12, color: theme.disabledColor),
                          ),
                          trailing: const Icon(Icons.chevron_right, size: 18),
                          onTap: () => context.go('/conversations/${_systemConversation!['id']}'),
                        ),
                      ),

                    // ── Regular Conversations ────────────────
                    if (hasRegularConvs) ...[
                      if (hasSystemConv)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text('Connections', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.disabledColor)),
                        ),
                      ..._conversations.map((c) {
                        final conv = c as Map<String, dynamic>;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const CircleAvatar(child: Icon(Icons.person)),
                            title: Text('Conversation #${conv['id'].toString().substring(0, 8)}'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.go('/conversations/${conv['id']}'),
                          ),
                        );
                      }),
                    ],
                  ],
                ),
    );
  }
}
