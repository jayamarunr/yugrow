// ─── MessageScreen ───────────────────────────────────────────
// Yugrow Conversation — text-only chat with context, read receipts,
// typing indicator, and conversation starter suggestions.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/auth/auth_service.dart';
import '../profile/widgets/profile_card.dart';

class MessageScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final String? initialSuggestion;
  final String? eventType; // e.g. 'startup_meetup', 'workshop', 'expo', 'networking'

  const MessageScreen({
    super.key,
    required this.conversationId,
    this.initialSuggestion,
    this.eventType,
  });

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  final _api = ApiClient();
  final _msgController = TextEditingController();
  final _scrollController = ScrollController();
  List<dynamic> _messages = [];
  bool _loading = true;
  bool _sending = false;
  bool _typing = false;
  Map<String, dynamic>? _context;
  String? _personId;
  String? _otherName;

  List<String> get _contextSuggestions {
    final eventName = _context?['eventName'] as String? ?? '';
    final type = widget.eventType ?? '';
    final lower = eventName.toLowerCase();

    if (type == 'workshop' || lower.contains('workshop')) {
      return [
        'What did you think of today\'s session?',
        'Which topic interested you most?',
        'Have you attended this before?',
        'Any key takeaways you\'d like to share?',
      ];
    }
    if (type == 'expo' || lower.contains('expo') || lower.contains('fair') || lower.contains('trade')) {
      return [
        'Which booth stood out to you?',
        'Are you exhibiting or visiting?',
        'Any interesting products you\'ve seen?',
        'What brought you to this expo?',
      ];
    }
    if (type == 'startup_meetup' || lower.contains('startup') || lower.contains('pitch') || lower.contains('investor')) {
      return [
        'What problem are you solving?',
        'How long have you been building?',
        'Are you looking for investors?',
        'What stage are you at?',
      ];
    }
    // Default networking suggestions
    return [
      'Hi! Great meeting you 👋',
      'What brought you to this event?',
      'Would love to stay connected.',
      'Tell me more about your work.',
    ];
  }



  @override
  void initState() {
    super.initState();
    _personId = ref.read(authProvider).person?['id'] as String? ?? 'person-001';
    if (widget.initialSuggestion != null) {
      _msgController.text = widget.initialSuggestion!;
    }
    _load();
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (_personId == null) return;
    try {
      final msgs = await _api.getMessages(widget.conversationId, _personId!);
      Map<String, dynamic>? ctx;
      try {
        ctx = await _api.getConversationContext(widget.conversationId);
        final participants = ctx?['participants'] as List<dynamic>? ?? [];
        for (final p in participants) {
          final pMap = p as Map<String, dynamic>;
          if (pMap['id'] != _personId) {
            _otherName = pMap['name'] as String?;
          }
        }
      } catch (_) {}
      if (mounted) {
        setState(() {
          _messages = msgs;
          _context = ctx;
          _loading = false;
        });
        _scrollToBottom();
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    if (_msgController.text.trim().isEmpty || _personId == null) return;
    final text = _msgController.text;
    _msgController.clear();
    setState(() => _sending = true);
    try {
      await _api.sendMessage(widget.conversationId, _personId!, text);
      _load();
    } catch (_) {}
    if (mounted) setState(() => _sending = false);
  }

  void _insertSuggestion(String suggestion) {
    _msgController.text = suggestion;
    _msgController.selection = TextSelection.fromPosition(
      TextPosition(offset: suggestion.length),
    );
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dt = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m';
      if (diff.inHours < 24) return '${diff.inHours}h';
      return '${dt.month}/${dt.day}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMessages = _messages.isNotEmpty;
    final otherName = _otherName ?? 'Chat';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(otherName, style: const TextStyle(fontSize: 16)),
            if (_typing)
              Text('typing...',
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey[600])),
          ],
        ),
      ),
      body: Column(
        children: [
          // Context banner
          if (_context != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: const Color(0xFF0F766E).withValues(alpha: 0.06),
              child: Row(
                children: [
                  const Icon(LucideIcons.map_pin,
                      size: 14, color: Color(0xFF0F766E)),
                  const SizedBox(width: 6),
                  Text(
                    'Met at ${_context!['eventName'] ?? 'an event'}',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF0F766E)),
                  ),
                  const Spacer(),
                  Text(
                    _context!['venueName'] != null
                        ? _context!['venueName'] as String
                        : '',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),

          // Messages
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : !hasMessages
                    ? _buildEmptyState(theme)
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        itemCount: _messages.length,
                        itemBuilder: (_, i) {
                          final m =
                              _messages[i] as Map<String, dynamic>;
                          final isMe =
                              m['senderPersonId'] == _personId;
                          final content = m['content'] as String? ?? '';
                          final time =
                              _formatTime(m['createdAt'] as String?);
                          final isLast =
                              i == _messages.length - 1 && isMe;

                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(bottom: 2),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? const Color(0xFF0F766E)
                                        : Colors.grey[200],
                                    borderRadius:
                                        BorderRadius.circular(18)
                                            .copyWith(
                                      bottomRight: isMe
                                          ? const Radius.circular(4)
                                          : null,
                                      bottomLeft: !isMe
                                          ? const Radius.circular(4)
                                          : null,
                                    ),
                                  ),
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75),
                                  child: Text(
                                    content,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isMe
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                // Timestamp + read receipt
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: isMe ? 0 : 4,
                                    right: isMe ? 4 : 0,
                                    bottom: 6,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(time,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey[500])),
                                      if (isLast) ...[
                                        const SizedBox(width: 4),
                                        Icon(LucideIcons.check_check,
                                            size: 12,
                                            color: Colors.grey[400]),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),

          // Typing indicator
          if (_typing)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 8,
                    height: 8,
                    child: CircularProgressIndicator(
                        strokeWidth: 1.5, color: Colors.grey[400]),
                  ),
                  const SizedBox(width: 6),
                  Text('$otherName is typing...',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey[500])),
                ],
              ),
            ),

          // Message suggestions (shown when no messages yet)
          if (!hasMessages && !_loading)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: _contextSuggestions.map((s) => ActionChip(
                  label: Text(s, style: const TextStyle(fontSize: 12)),
                  onPressed: () => _insertSuggestion(s),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  side: BorderSide(color: Colors.grey[300]!),
                  backgroundColor: Colors.grey[50],
                )).toList(),
              ),
            ),

          // Input bar
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 8, 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                  top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: hasMessages
                          ? 'Type a message...'
                          : 'Say hello...',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton.filled(
                  onPressed: _sending ? null : _send,
                  icon: _sending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.send, size: 18),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.message_square,
                size: 48, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('Say hello!',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(
              'Start the conversation with ${_otherName ?? "them"}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
