import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../core/api/api_client.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _api = ApiClient();
  Map<String, dynamic>? _activeEvent;
  bool _loading = true;
  String _selectedWorkspace = 'personal';

  @override
  void initState() {
    super.initState();
    _loadActiveEvent();
  }

  Future<void> _loadActiveEvent() async {
    try {
      final events = await _api.getActiveEvents();
      if (events.isNotEmpty && mounted) {
        setState(() {
          _activeEvent = events.first as Map<String, dynamic>;
          _loading = false;
        });
      } else if (mounted) {
        setState(() => _loading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _doCheckin() async {
    if (_activeEvent == null) return;
    try {
      await _api.checkIn({
        'personId': 'current-person-id',
        'workspaceId': _selectedWorkspace == 'personal' ? 'workspace-personal' : 'workspace-001',
        'eventId': _activeEvent!['id'],
        'venueId': _activeEvent!['venue']['id'],
      });
      if (mounted) {
        context.go('/live/${_activeEvent!['id']}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Check-in failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Yugrow')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _activeEvent == null
              ? _buildNoEvent(theme)
              : _buildActiveEvent(theme),
    );
  }

  Widget _buildNoEvent(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: theme.disabledColor),
            const SizedBox(height: AppSpacing.lg),
            Text('No active events nearby', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text('Events near you will appear here', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveEvent(ThemeData theme) {
    final venue = _activeEvent!['venue'] as Map<String, dynamic>?;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          const Spacer(flex: 2),
          // Event info
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: AppRadius.xxlCircular,
            ),
            child: Column(
              children: [
                const Icon(Icons.explore, size: 48, color: AppColors.info),
                const SizedBox(height: AppSpacing.lg),
                Text(_activeEvent!['name'], style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.sm),
                Text(venue?['name'] ?? '', style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.xs),
                Text('${_activeEvent!['name']} people here now', style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const Spacer(flex: 1),
          // Workspace selector
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.mdCircular,
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Checking in as', style: theme.textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.sm),
                _workspaceOption('personal', 'Personal', Icons.person_outline),
                const SizedBox(height: AppSpacing.xs),
                _workspaceOption('company', 'My Company', Icons.business_outlined),
                if (_selectedWorkspace == 'company') ...[
                  const SizedBox(height: AppSpacing.xs),
                  _workspaceOption('company2', 'Second Company', Icons.business_outlined),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // I'M HERE button
          SizedBox(
            width: double.infinity,
            height: 64,
            child: ElevatedButton.icon(
              onPressed: _doCheckin,
              icon: const Icon(Icons.near_me, size: 28),
              label: Text("I'M HERE", style: theme.textTheme.labelLarge?.copyWith(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.info,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.xlCircular),
              ),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _workspaceOption(String id, String label, IconData icon) {
    final selected = _selectedWorkspace == id;
    return InkWell(
      onTap: () => setState(() => _selectedWorkspace = id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: selected ? AppColors.info.withValues(alpha: 0.1) : null,
          borderRadius: AppRadius.smCircular,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: selected ? AppColors.info : AppColors.textDisabled),
            const SizedBox(width: AppSpacing.md),
            Text(label, style: TextStyle(fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
            const Spacer(),
            if (selected) const Icon(Icons.check_circle, size: 20, color: AppColors.info),
          ],
        ),
      ),
    );
  }
}
