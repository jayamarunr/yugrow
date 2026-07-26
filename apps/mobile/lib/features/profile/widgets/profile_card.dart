// ─── ProfileCard ──────────────────────────────────────────────
// Reusable component for displaying a professional profile.
// Used across: event attendees, search, connection requests,
// chat header, profile preview, and the Me screen.
//
// Usage:
//   ProfileCard(
//     name: 'Jayam Arun',
//     headline: 'Founder at Yugrow',
//     company: 'Yugrow',
//     photoUrl: 'https://...',
//     skills: ['AI', 'Product', 'SaaS'],
//     location: 'Chennai',
//     onTap: () => ...,
//   )

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String? headline;
  final String? company;
  final String? photoUrl;
  final String? about;
  final String? location;
  final String? website;
  final String? linkedIn;
  final List<String> skills;
  final List<String> industries;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final Widget? trailing;
  final bool compact; // Smaller variant for lists

  const ProfileCard({
    super.key,
    required this.name,
    this.headline,
    this.company,
    this.photoUrl,
    this.about,
    this.location,
    this.website,
    this.linkedIn,
    this.skills = const [],
    this.industries = const [],
    this.onTap,
    this.onEdit,
    this.trailing,
    this.compact = false,
  });

  String get _initial => name.isNotEmpty ? name[0].toUpperCase() : '?';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (compact) return _buildCompact(theme);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              if (headline != null || company != null) ...[
                const SizedBox(height: 6),
                _buildTitleRow(theme),
              ],
              if (location != null) ...[
                const SizedBox(height: 4),
                _buildLocation(theme),
              ],
              if (about != null && about!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(about!, style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    maxLines: 3, overflow: TextOverflow.ellipsis),
              ],
              if (skills.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildTags(theme, skills, 'Skills'),
              ],
              if (industries.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildTags(theme, industries, 'Industries'),
              ],
              if (website != null || linkedIn != null) ...[
                const SizedBox(height: 10),
                _buildLinks(theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompact(ThemeData theme) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: const Color(0xFF0F766E).withValues(alpha: 0.15),
        child: Text(_initial,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F766E))),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: headline != null
          ? Text(headline!, style: TextStyle(fontSize: 12, color: Colors.grey[600]), maxLines: 1)
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFF0F766E).withValues(alpha: 0.15),
          backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
              ? NetworkImage(photoUrl!)
              : null,
          child: photoUrl == null || photoUrl!.isEmpty
              ? Text(_initial,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F766E)))
              : null,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        if (onEdit != null)
          IconButton(
            icon: const Icon(LucideIcons.pencil, size: 18),
            onPressed: onEdit,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        if (trailing != null) trailing!,
      ],
    );
  }

  Widget _buildTitleRow(ThemeData theme) {
    final parts = <String>[];
    if (headline != null && headline!.isNotEmpty) parts.add(headline!);
    if (company != null && company!.isNotEmpty) parts.add(company!);

    return Text(
      parts.join(' · '),
      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildLocation(ThemeData theme) {
    return Row(
      children: [
        Icon(LucideIcons.map_pin, size: 12, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(location!,
            style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      ],
    );
  }

  Widget _buildTags(ThemeData theme, List<String> tags, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500])),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F766E).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(tag,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF0F766E))),
              )).toList(),
        ),
      ],
    );
  }

  Widget _buildLinks(ThemeData theme) {
    return Row(
      children: [
        if (website != null && website!.isNotEmpty)
          _linkChip(LucideIcons.globe, website!, theme),
        if (linkedIn != null && linkedIn!.isNotEmpty) ...[
          const SizedBox(width: 12),
          _linkChip(LucideIcons.briefcase, linkedIn!, theme),
        ],
      ],
    );
  }

  Widget _linkChip(IconData icon, String text, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        // TODO: Open URL
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[500]),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
