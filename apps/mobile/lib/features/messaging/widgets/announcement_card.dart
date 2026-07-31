// ─── AnnouncementCard ───────────────────────────────────────
// Renders an announcement message in the conversation.
//
// Expected message content (JSON):
// {
//   "title": "Professional Meetup",
//   "date": "Saturday",
//   "location": "Chennai",
//   "description": "Join us for an evening of networking...",
//   "actionLabel": "Register",
//   "actionUrl": null
// }

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'dart:convert';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';

class AnnouncementCard extends StatelessWidget {
  final Map<String, dynamic> message;
  final String? time;

  const AnnouncementCard({
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

    final title = data['title'] as String? ?? 'Announcement';
    final date = data['date'] as String?;
    final location = data['location'] as String?;
    final description = data['description'] as String?;
    final actionLabel = data['actionLabel'] as String?;

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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.85),
                  ],
                ),
                borderRadius: const BorderRadius.only(
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
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: AppRadius.smCircular,
                    ),
                    child: const Icon(Icons.campaign, size: 18, color: Colors.white),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
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
                  // Date
                  if (date != null)
                    _infoRow(Icons.calendar_today, date),

                  // Location
                  if (location != null)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: _infoRow(Icons.location_on, location),
                    ),

                  // Description
                  if (description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.md),
                      child: Text(
                        description,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                      ),
                    ),
                ],
              ),
            ),

            // Action button
            if (actionLabel != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.none, AppSpacing.lg, AppSpacing.lg),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textInverse,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.smCircular),
                    ),
                    child: Text(actionLabel, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
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

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: AppSpacing.sm),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
