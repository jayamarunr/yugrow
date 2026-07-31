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
import '../../../core/theme/app_colors.dart';
import 'release_message_card.dart';
import 'announcement_card.dart';
import 'feedback_status_card.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';

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
          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: me ? AppColors.primary : AppColors.border,
            borderRadius: AppRadius.xlCircular.copyWith(
              bottomRight: me ? const Radius.circular(4) : null,
              bottomLeft: !me ? const Radius.circular(4) : null,
            ),
          ),
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: me ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
        if (time != null || isLast)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs, right: AppSpacing.xs, bottom: AppSpacing.sm),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (time != null)
                  Text(time, style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                if (isLast) ...[
                  if (time != null) const SizedBox(width: AppSpacing.xs),
                  Icon(Icons.check, size: 12, color: AppColors.textDisabled),
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
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            borderRadius: AppRadius.mdCircular,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.favorite, size: 16, color: AppColors.primary),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'Yugrow',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                content,
                style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.5),
              ),
            ],
          ),
        ),
        if (time != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(time, style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
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
