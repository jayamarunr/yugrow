// â”€â”€â”€ ProfileCard â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
import '../../../core/theme/app_colors.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import 'package:yugrow_mobile/core/theme/app_typography.dart';

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
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgCircular),
      child: InkWell(
        borderRadius: AppRadius.lgCircular,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              if (headline != null || company != null) ...[
                const SizedBox(height: AppSpacing.sm),
                _buildTitleRow(theme),
              ],
              if (location != null) ...[
                const SizedBox(height: AppSpacing.xs),
                _buildLocation(theme),
              ],
              if (about != null && about!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text(about!, style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    maxLines: 3, overflow: TextOverflow.ellipsis),
              ],
              if (skills.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                _buildTags(theme, skills, 'Skills'),
              ],
              if (industries.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                _buildTags(theme, industries, 'Industries'),
              ],
              if (website != null || linkedIn != null) ...[
                const SizedBox(height: AppSpacing.md),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: AppColors.primary.withValues(alpha: 0.15),
        child: Text(_initial,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary)),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: headline != null
          ? Text(headline!, style: AppTypography.caption.copyWith(color: AppColors.textSecondary), maxLines: 1)
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
          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
          backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
              ? NetworkImage(photoUrl!)
              : null,
          child: photoUrl == null || photoUrl!.isEmpty
              ? Text(_initial,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary))
              : null,
        ),
        const SizedBox(width: AppSpacing.lg),
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
      parts.join(' Â· '),
      style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildLocation(ThemeData theme) {
    return Row(
      children: [
        Icon(LucideIcons.map_pin, size: 12, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.xs),
        Text(location!,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
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
                color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: AppRadius.mdCircular,
                ),
                child: Text(tag,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.primary)),
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
          const SizedBox(width: AppSpacing.md),
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
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Text(text,
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );

  }
}
