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
import 'dart:convert';

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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0F766E),
                    const Color(0xFF0F766E).withValues(alpha: 0.85),
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
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.campaign, size: 18, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date
                  if (date != null)
                    _infoRow(Icons.calendar_today, date),

                  // Location
                  if (location != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: _infoRow(Icons.location_on, location),
                    ),

                  // Description
                  if (description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        description,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.5),
                      ),
                    ),
                ],
              ),
            ),

            // Action button
            if (actionLabel != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(actionLabel, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
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

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF0F766E)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: Color(0xFF374151), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
