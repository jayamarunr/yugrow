// â”€â”€â”€ FeedbackStatusCard â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
import '../../../core/theme/app_colors.dart';
import 'dart:convert';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import 'package:yugrow_mobile/core/theme/app_typography.dart';

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
          borderRadius: AppRadius.lgCircular,
          border: Border.all(color: AppColors.border),
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
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md),
              decoration: const BoxDecoration(
                color: AppColors.surfaceHover,
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
                      borderRadius: AppRadius.smCircular,
                    ),
                    child: Icon(Icons.feedback, size: 18, color: statusColor),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  const Expanded(
                    child: Text(
                      'Feedback Received',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: AppRadius.xxlCircular,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 14, color: statusColor),
                        const SizedBox(width: AppSpacing.xs),
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
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Row(
                        children: [
                          Icon(Icons.speed, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            sprint,
                            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),

                  // Note
                  if (note != null)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.md),
                      child: Text(
                        note,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                      ),
                    ),
                ],
              ),
            ),

            // Timestamp
            if (time != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.none, AppSpacing.lg, AppSpacing.md),
                child: Text(time ?? '', style: TextStyle(fontSize: 10, color: AppColors.textDisabled)),
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
