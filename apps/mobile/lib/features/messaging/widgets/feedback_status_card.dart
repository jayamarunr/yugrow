// ─── FeedbackStatusCard ─────────────────────────────────────
// Renders a feedback status update in the conversation.
// Communicates the status of a professional's reported feedback.
//
// Expected message content (JSON):
// {
//   "title": "Duplicate Events",
//   "status": "Accepted",
//   "statusColor": "#16A34A",
//   "sprint": "Sprint 12",
//   "note": "We've added this to our roadmap."
// }

import 'package:flutter/material.dart';
import 'dart:convert';

class FeedbackStatusCard extends StatelessWidget {
  final Map<String, dynamic> message;
  final String? time;

  const FeedbackStatusCard({
    super.key,
    required this.message,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rawContent = message['content'] as String? ?? '{}';
    Map<String, dynamic> data;
    try {
      data = jsonDecode(rawContent) as Map<String, dynamic>;
    } catch (_) {
      data = {};
    }

    final title = data['title'] as String? ?? 'Feedback';
    final status = data['status'] as String? ?? 'Received';
    final statusColorHex = data['statusColor'] as String? ?? '#F59E0B';
    final statusColor = _parseColor(statusColorHex);
    final sprint = data['sprint'] as String?;
    final note = data['note'] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.feedback, size: 18, color: statusColor),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Feedback Received',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Sprint
                  if (sprint != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Icon(Icons.speed, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            sprint,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),

                  // Note
                  if (note != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        note,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.4),
                      ),
                    ),
                ],
              ),
            ),

            // Timestamp
            if (time != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Text(time ?? '', style: TextStyle(fontSize: 10, color: Colors.grey[400])),
              ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
