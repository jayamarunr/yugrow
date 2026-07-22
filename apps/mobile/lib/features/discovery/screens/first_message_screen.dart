import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yugrow_mobile/core/theme/app_colors.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import '../models/professional.dart';

class FirstMessageScreen extends StatefulWidget {
  final Professional professional;

  const FirstMessageScreen({super.key, required this.professional});

  @override
  State<FirstMessageScreen> createState() => _FirstMessageScreenState();
}

class _FirstMessageScreenState extends State<FirstMessageScreen> {
  final _controller = TextEditingController();
  String? _selectedSuggestion;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _insertSuggestion(String text) {
    setState(() => _selectedSuggestion = text);
    _controller.text = text;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: text.length),
    );
  }

  void _onSend() {
    if (_controller.text.trim().isEmpty) return;
    HapticFeedback.lightImpact();
    // TODO: Send message — Sprint 5 (Chat integration)
    Navigator.of(context).pop();
  }

  List<String> _buildSuggestions() {
    final p = widget.professional;
    final firstName = p.name.split(' ')[0];
    final suggestions = <String>[];

    // 1. Default — event-based greeting
    suggestions.add(
      'Hi $firstName,\n\nGreat meeting you at AI Summit Chennai today.\nLooking forward to staying connected.',
    );

    // 2. Industry-based
    if (p.industry.isNotEmpty && p.company.isNotEmpty) {
      suggestions.add(
        'Hi $firstName,\n\nI noticed we\'re both working in ${p.industry}. '
        'Would love to learn more about your work at ${p.company}.',
      );
    }

    // 3. Role/skill-based
    if (p.skills.isNotEmpty) {
      final topSkill = p.skills.take(2).join(' and ');
      suggestions.add(
        'Hi $firstName,\n\nI\'d love to learn more about your experience with $topSkill. '
        'Great meeting you today!',
      );
    }

    // 4. Looking-for based
    if (p.lookingFor.isNotEmpty) {
      final looking = p.lookingFor.length > 60
          ? '${p.lookingFor.substring(0, 60)}...'
          : p.lookingFor;
      suggestions.add(
        'Hi $firstName,\n\nI saw you\'re looking for $looking. '
        'Would be great to explore how we might collaborate.',
      );
    }

    // 5. Recent activity based
    if (p.recentActivity.isNotEmpty) {
      suggestions.add(
        'Hi $firstName,\n\nI noticed $p.recentActivity. '
        'Would love to hear more about it.',
      );
    }

    return suggestions.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.professional;
    final suggestions = _buildSuggestions();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevron_left, size: 24),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Message',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Context header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            margin: const EdgeInsets.fromLTRB(
              AppSpacing.screenMobile,
              AppSpacing.sm,
              AppSpacing.screenMobile,
              0,
            ),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: AppRadius.mdCircular,
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${p.title} · ${p.company}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Meeting context
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenMobile,
              AppSpacing.lg,
              AppSpacing.screenMobile,
              0,
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.map_pin, size: 14, color: AppColors.textDisabled),
                const SizedBox(width: 6),
                Text(
                  'You met at AI Summit Chennai',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenMobile + 20,
              AppSpacing.xs,
              AppSpacing.screenMobile,
              0,
            ),
            child: Text(
              'Today · Hall B',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textDisabled,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppSpacing.lg),

          // Suggestions header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMobile),
            child: Row(
              children: [
                const Icon(LucideIcons.sparkles, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  'Conversation Starters',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Suggestion chips
          ...suggestions.map((s) => _SuggestionChip(
                text: s,
                isSelected: _selectedSuggestion == s,
                onTap: () => _insertSuggestion(s),
              )),

          const Spacer(),

          // Composer area
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
            ),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenMobile,
              AppSpacing.sm,
              AppSpacing.screenMobile,
              AppSpacing.sm + MediaQuery.of(context).padding.bottom,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: 4,
                    minLines: 1,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Write a message...',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textDisabled,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                GestureDetector(
                  onTap: _onSend,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _controller.text.trim().isEmpty
                          ? AppColors.border
                          : AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.send_horizontal,
                      size: 18,
                      color: AppColors.textInverse,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _SuggestionChip({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenMobile,
        0,
        AppSpacing.screenMobile,
        AppSpacing.sm,
      ),
      child: Material(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.surface,
        borderRadius: AppRadius.mdCircular,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdCircular,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: AppRadius.mdCircular,
              border: Border.all(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : AppColors.border,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isSelected ? LucideIcons.check : LucideIcons.plus,
                  size: 14,
                  color: isSelected ? AppColors.primary : AppColors.textDisabled,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
