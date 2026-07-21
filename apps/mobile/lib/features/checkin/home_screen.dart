import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/api/api_client.dart';
import '../../core/widgets/attendee_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _api = ApiClient();
  Map<String, dynamic>? _activeEvent;
  bool _loading = true;
  bool _checkedIn = false;
  String _selectedWorkspace = 'personal';
  Map<String, dynamic>? _presence;

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
      final presence = await _api.checkIn({
        'personId': 'person-001', // TODO: use actual user ID
        'workspaceId': _selectedWorkspace == 'personal' ? 'workspace-personal' : 'workspace-001',
        'eventId': _activeEvent!['id'],
        'venueId': _activeEvent!['venue']['id'],
      });
      if (mounted) {
        setState(() {
          _presence = presence;
          _checkedIn = true;
        });
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: theme.disabledColor),
            const SizedBox(height: 16),
            Text('No active events nearby', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Events near you will appear here', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveEvent(ThemeData theme) {
    final venue = _activeEvent!['venue'] as Map<String, dynamic>?;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(flex: 2),
          // Event info
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(Icons.explore, size: 48, color: Color(0xFF2563EB)),
                const SizedBox(height: 16),
                Text(_activeEvent!['name'], style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(venue?['name'] ?? '', style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
                const SizedBox(height: 4),
                Text('${_activeEvent!['name']} people here now', style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const Spacer(flex: 1),
          // Workspace selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Checking in as', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                _workspaceOption('personal', 'Personal', Icons.person_outline),
                const SizedBox(height: 4),
                _workspaceOption('company', 'My Company', Icons.business_outlined),
                if (_selectedWorkspace == 'company') ...[
                  const SizedBox(height: 4),
                  _workspaceOption('company2', 'Second Company', Icons.business_outlined),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          // I'M HERE button
          SizedBox(
            width: double.infinity,
            height: 64,
            child: ElevatedButton.icon(
              onPressed: _doCheckin,
              icon: const Icon(Icons.near_me, size: 28),
              label: Text("I'M HERE", style: theme.textTheme.labelLarge?.copyWith(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2563EB).withValues(alpha: 0.1) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: selected ? const Color(0xFF2563EB) : const Color(0xFF64748B)),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
            const Spacer(),
            if (selected) const Icon(Icons.check_circle, size: 20, color: Color(0xFF2563EB)),
          ],
        ),
      ),
    );
  }
}
