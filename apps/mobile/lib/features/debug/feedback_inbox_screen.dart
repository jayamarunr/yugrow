// â”€â”€â”€ Yugrow Feedback Inbox â€” Founder Tool â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Lists all system conversation feedback from professionals.
// Founder can read messages and reply as Yugrow.

import 'package:flutter/material.dart';
import 'package:yugrow_mobile/core/theme/app_colors.dart';
import '../../core/api/api_client.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import 'package:yugrow_mobile/core/theme/app_typography.dart';

class FeedbackInboxScreen extends StatefulWidget {
  const FeedbackInboxScreen({super.key});

  @override
  State<FeedbackInboxScreen> createState() => _FeedbackInboxScreenState();
}

class _FeedbackInboxScreenState extends State<FeedbackInboxScreen> {
  final _api = ApiClient();
  Map<String, dynamic>? _inbox;
  bool _loading = true;
  String? _replyPersonId;
  final _replyCtrl = TextEditingController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _replyCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final inbox = await _api.getFeedbackInbox();
      if (mounted) setState(() { _inbox = inbox; _loading = false; });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _sendReply() async {
    final text = _replyCtrl.text.trim();
    if (text.isEmpty || _replyPersonId == null) return;
    setState(() => _sending = true);
    try {
      await _api.replyToFeedback(_replyPersonId!, text);
      _replyCtrl.clear();
      setState(() => _replyPersonId = null);
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reply sent as Yugrow')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _inbox?['items'] as List<dynamic>? ?? [];
    final unread = _inbox?['unread'] as int? ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Inbox ($unread unread)'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined, size: 64, color: theme.disabledColor),
                      const SizedBox(height: AppSpacing.lg),
                      Text('No feedback yet', style: theme.textTheme.titleLarge),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Messages from professionals will appear here', style: theme.textTheme.bodyMedium),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    // â”€â”€ Reply Panel â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    if (_replyPersonId != null)
                      Card(
                        color: theme.primaryColor.withValues(alpha: 0.05),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text('Replying as Yugrow ðŸ’š', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.primaryColor)),
                              const SizedBox(height: AppSpacing.sm),
                              TextField(
                                controller: _replyCtrl,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  hintText: 'Type your reply...',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => setState(() { _replyPersonId = null; _replyCtrl.clear(); }),
                                    child: const Text('Cancel'),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  ElevatedButton(
                                    onPressed: _sending ? null : _sendReply,
                                    child: _sending
                                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                        : const Text('Send Reply'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    // â”€â”€ Feedback List â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    ...items.map((item) {
                      final i = item as Map<String, dynamic>;
                      final name = i['name'] as String? ?? 'Unknown';
                      final title = i['title'] as String?;
                      final company = i['company'] as String?;
                      final lastMsg = i['lastMessage'] as Map<String, dynamic>?;
                      final needsReply = lastMsg?['isFromProfessional'] == true;
                      final msgContent = lastMsg?['content'] as String? ?? '(no messages)';
                      final msgTime = lastMsg?['createdAt'] as String? ?? '';

                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.mdCircular,
                          side: needsReply ? BorderSide(color: theme.primaryColor.withValues(alpha: 0.3)) : BorderSide.none,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                                    child: Text(name[0], style: TextStyle(fontSize: 14, color: theme.primaryColor)),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                        if (title != null || company != null)
                                          Text(
                                            [title, company].whereType<String>().join(' Â· '),
                                            style: TextStyle(fontSize: 11, color: theme.disabledColor),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (needsReply)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                                      decoration: BoxDecoration(
                                        color: Colors.orange[50],
                                        borderRadius: AppRadius.smCircular,
                                      ),
                                      child: Text('Reply', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.warning)),
                                    ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                msgContent.length > 120 ? '${msgContent.substring(0, 120)}...' : msgContent,
                                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                              ),
                              if (msgTime.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                                  child: Text(_formatTime(msgTime), style: TextStyle(fontSize: 10, color: theme.disabledColor)),
                                ),
                              const SizedBox(height: AppSpacing.sm),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (i['personId'] != null)
                                    OutlinedButton.icon(
                                      onPressed: () => setState(() {
                                        _replyPersonId = i['personId'] as String?;
                                        _replyCtrl.text = '';
                                      }),
                                      icon: const Icon(Icons.reply, size: 14),
                                      label: const Text('Reply', style: AppTypography.caption),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        shape: RoundedRectangleBorder(borderRadius: AppRadius.smCircular),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
    );
  }

  String _formatTime(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dt.month}/${dt.day}';
    } catch (_) {
      return '';

    }
  }
}
