// ─── MessageRenderer ────────────────────────────────────────
// Extensible message type renderer.
//
// To add a new message type:
//   1. Add entry to MessageType enum (backend)
//   2. Create a widget for the card
//   3. Add a case to MessageRenderer.build
//
// No existing code needs to change.

import 'package:flutter/material.dart';
import 'release_message_card.dart';
import 'announcement_card.dart';
import 'feedback_status_card.dart';

/// Supported message types.
/// Must match backend MessageType enum values.
enum MessageType { text, system, releaseNote, announcement, feedbackStatus }

/// Renderer registry — maps types to builder functions.
/// Future types register here without modifying existing code.
final Map<MessageType, Widget Function(Map<String, dynamic> message, {bool? isMe, String? time})> _renderers = {
  MessageType.text: _buildTextMessage,
  MessageType.system: _buildSystemMessage,
  MessageType.releaseNote: (m, {isMe, time}) => ReleaseMessageCard(message: m, time: time),
  MessageType.announcement: (m, {isMe, time}) => AnnouncementCard(message: m, time: time),
  MessageType.feedbackStatus: (m, {isMe, time}) => FeedbackStatusCard(message: m, time: time),
};

/// Parse the message type from a raw API response.
MessageType _parseType(String? rawType) {
  switch (rawType?.toUpperCase()) {
    case 'SYSTEM':
      return MessageType.system;
    case 'RELEASE_NOTE':
      return MessageType.releaseNote;
    case 'ANNOUNCEMENT':
      return MessageType.announcement;
    case 'FEEDBACK_STATUS':
      return MessageType.feedbackStatus;
    default:
      return MessageType.text;
  }
}

/// Build the appropriate widget for a message.
Widget buildMessage(Map<String, dynamic> message, {bool? isMe, String? time}) {
  final rawType = message['type'] as String?;
  final type = _parseType(rawType);
  final builder = _renderers[type] ?? _renderers[MessageType.text]!;
  return builder(message, isMe: isMe, time: time);
}

// ── Text message builder (default) ────────────────────────────────
Widget _buildTextMessage(Map<String, dynamic> message, {bool? isMe, String? time}) {
  final content = message['content'] as String? ?? '';
  final isLast = message['isLast'] == true;
  final me = isMe ?? false;

  return Align(
    alignment: me ? Alignment.centerRight : Alignment.centerLeft,
    child: Column(
      crossAxisAlignment: me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: me ? const Color(0xFF0F766E) : Colors.grey[200],
            borderRadius: BorderRadius.circular(18).copyWith(
              bottomRight: me ? const Radius.circular(4) : null,
              bottomLeft: !me ? const Radius.circular(4) : null,
            ),
          ),
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: me ? Colors.white : Colors.black87,
            ),
          ),
        ),
        if (time != null || isLast)
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4, bottom: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (time != null)
                  Text(time, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                if (isLast) ...[
                  if (time != null) const SizedBox(width: 4),
                  Icon(Icons.check, size: 12, color: Colors.grey[400]),
                ],
              ],
            ),
          ),
      ],
    ),
  );
}

// ── System message builder (e.g. welcome messages) ────────────────
Widget _buildSystemMessage(Map<String, dynamic> message, {bool? isMe, String? time}) {
  final content = message['content'] as String? ?? '';

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F766E).withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF0F766E).withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.favorite, size: 16, color: Color(0xFF0F766E)),
                  SizedBox(width: 6),
                  Text(
                    'Yugrow',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F766E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                content,
                style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937), height: 1.5),
              ),
            ],
          ),
        ),
        if (time != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(time, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
          ),
      ],
    ),
  );
}

/// Register a new message type renderer.
/// Call this at app startup to extend available message types.
void registerMessageRenderer(MessageType type, Widget Function(Map<String, dynamic> message, {bool? isMe, String? time}) builder) {
  _renderers[type] = builder;
}
