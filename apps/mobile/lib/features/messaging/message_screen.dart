import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';

class MessageScreen extends StatefulWidget {
  final String conversationId;
  const MessageScreen({super.key, required this.conversationId});
  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _api = ApiClient();
  final _msgController = TextEditingController();
  List<dynamic> _messages = [];
  bool _loading = true;
  Map<String, dynamic>? _context;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final msgs = await _api.getMessages(widget.conversationId, 'person-001');
      Map<String, dynamic>? ctx;
      try { ctx = await _api.getConversationContext(widget.conversationId); } catch (_) {}
      if (mounted) setState(() { _messages = msgs; _context = ctx; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _send() async {
    if (_msgController.text.trim().isEmpty) return;
    final text = _msgController.text;
    _msgController.clear();
    try {
      await _api.sendMessage(widget.conversationId, 'person-001', text);
      _load();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          // Context banner
          if (_context != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: theme.primaryColor.withValues(alpha: 0.05),
              child: Row(
                children: [
                  const Icon(Icons.event, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Met at this event',
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          // Messages
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Say hello!', style: theme.textTheme.titleLarge),
                            const SizedBox(height: 8),
                            Text('Start the conversation', style: theme.textTheme.bodyMedium),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (_, i) {
                          final m = _messages[i] as Map<String, dynamic>;
                          final isMe = m['senderPersonId'] == 'person-001';
                          return Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isMe ? theme.primaryColor : Colors.grey[200],
                                borderRadius: BorderRadius.circular(16).copyWith(
                                  bottomRight: isMe ? const Radius.circular(4) : null,
                                  bottomLeft: !isMe ? const Radius.circular(4) : null,
                                ),
                              ),
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                              child: Text(
                                m['content'] ?? '',
                                style: TextStyle(color: isMe ? Colors.white : Colors.black87),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          // Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: theme.primaryColor,
                  onPressed: _send,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
