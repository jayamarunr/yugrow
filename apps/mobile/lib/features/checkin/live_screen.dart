import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/auth/auth_service.dart';
import '../profile/widgets/profile_card.dart';

class LiveScreen extends ConsumerStatefulWidget {
  final String eventId;
  const LiveScreen({super.key, required this.eventId});
  @override
  ConsumerState<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends ConsumerState<LiveScreen> {
  final _api = ApiClient();
  List<dynamic> _attendees = [];
  bool _loading = true;

  String? get _personId => ref.read(authProvider).person?['id'] as String?;
  String? get _workspaceId => ref.read(authProvider).workspace?['id'] as String?;

  @override
  void initState() {
    super.initState();
    _loadAttendees();
  }

  Future<void> _loadAttendees() async {
    final pid = _personId;
    if (pid == null) return;
    try {
      final attendees = await _api.getLiveAttendees(widget.eventId, viewerPersonId: pid);
      if (mounted) setState(() { _attendees = attendees; _loading = false; });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _connect(String targetPersonId) async {
    final pid = _personId;
    final wid = _workspaceId;
    if (pid == null || wid == null) return;
    try {
      await _api.sendConnectionRequest({
        'fromPersonId': pid,
        'toPersonId': targetPersonId,
        'workspaceId': wid,
        'eventId': widget.eventId,
        'venueId': '',
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connection request sent!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pid = _personId;
    return Scaffold(
      appBar: AppBar(title: const Text('People Here Now')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _attendees.isEmpty
              ? Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.celebration_outlined, size: 72, color: theme.primaryColor.withValues(alpha: 0.4)),
                        const SizedBox(height: 20),
                        Text("You're checked in!", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text(
                          'Waiting for other professionals to arrive...',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share, size: 18),
                          label: const Text('Share Event'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            minimumSize: const Size(200, 44),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton.icon(
                          onPressed: _loadAttendees,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Refresh'),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Nearby professionals will appear here automatically.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: theme.disabledColor.withValues(alpha: 0.7)),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadAttendees,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _attendees.length,
                    itemBuilder: (_, i) {
                      final a = _attendees[i] as Map<String, dynamic>;
                      final name = a['name'] as String? ?? 'Unknown';
                      final headline = [a['title'], a['company']]
                          .whereType<String>()
                          .where((s) => s.isNotEmpty)
                          .join(' · ');
                      final isMe = pid != null && a['personId'] == pid;
                      return ProfileCard(
                        compact: true,
                        name: name,
                        headline: headline.isNotEmpty ? headline : null,
                        onTap: () {},
                        trailing: !isMe
                            ? TextButton(
                                onPressed: () => _connect(a['personId']),
                                child: const Text('Connect',
                                    style: TextStyle(fontWeight: FontWeight.w600)),
                              )
                            : null,
                      );
                    },
                  ),
                ),
    );
  }
}
