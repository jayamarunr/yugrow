import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import '../profile/widgets/profile_card.dart';

class LiveScreen extends StatefulWidget {
  final String eventId;
  const LiveScreen({super.key, required this.eventId});
  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  final _api = ApiClient();
  List<dynamic> _attendees = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAttendees();
  }

  Future<void> _loadAttendees() async {
    try {
      final attendees = await _api.getLiveAttendees(widget.eventId, viewerPersonId: 'person-001');
      if (mounted) setState(() { _attendees = attendees; _loading = false; });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _connect(String personId) async {
    try {
      await _api.sendConnectionRequest({
        'fromPersonId': 'person-001',
        'toPersonId': personId,
        'workspaceId': 'workspace-001',
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
    return Scaffold(
      appBar: AppBar(title: const Text('People Here Now')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _attendees.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 64, color: theme.disabledColor),
                      const SizedBox(height: 16),
                      Text('No one else here yet', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('Be the first! Share this event with others.', style: theme.textTheme.bodyMedium),
                    ],
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
                      return ProfileCard(
                        compact: true,
                        name: name,
                        headline: headline.isNotEmpty ? headline : null,
                        onTap: () {},
                        trailing: a['personId'] != 'person-001'
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
