import 'dart:async';
import 'dart:math';
import '../models/professional.dart';
import '../repository/discovery_repository.dart';

/// Types of entities that can have presence at an event.
/// Reserved for future use: organization, booth, session, product, sponsor.
enum PresenceType {
  professional,
  organization,
  booth,
  session,
  product,
  sponsor,
}

/// Who can see this presence entry.
enum PresenceVisibility {
  /// Visible to all attendees at the event (default for professionals)
  everyone,

  /// Visible only to specific groups (e.g., exhibitors only)
  restricted,

  /// Visible only to the organization and its representatives
  organizationOnly,
}

/// Optional metadata carried by a presence entry.
/// Extends without changing the Presence class signature.
class PresenceContext {
  final String? boothId;
  final String? sessionId;
  final Map<String, String> attributes;

  const PresenceContext({
    this.boothId,
    this.sessionId,
    this.attributes = const {},
  });
}

/// A generic presence entry — any entity type at any time.
///
/// The engine doesn't know what an Organization or Booth is.
/// It only knows: *something became present.*
class Presence {
  /// Unique ID for this presence entry
  final String presenceId;

  /// The type of entity that is present
  final PresenceType type;

  /// The ID of the underlying entity (professional ID, org ID, etc.)
  final String entityId;

  /// Human-readable name for display
  final String displayName;

  /// When this presence started
  final DateTime checkedInAt;

  /// When this presence expires (null = never)
  final DateTime? expiresAt;

  /// Visibility scope
  final PresenceVisibility visibility;

  /// Optional context data
  final PresenceContext context;

  /// The underlying professional data (null for non-professional types)
  final Professional? professional;

  const Presence({
    required this.presenceId,
    required this.type,
    required this.entityId,
    required this.displayName,
    required this.checkedInAt,
    this.expiresAt,
    this.visibility = PresenceVisibility.everyone,
    this.context = const PresenceContext(),
    this.professional,
  });

  /// Filter to only professional-type presences
  static List<Professional> onlyProfessionals(List<Presence> presences) {
    return presences
        .where((p) => p.type == PresenceType.professional && p.professional != null)
        .map((p) => p.professional!)
        .toList();
  }

  /// Create a professional presence entry with 60-minute expiry
  factory Presence.fromProfessional(Professional p, DateTime checkedInAt) {
    return Presence(
      presenceId: 'pres_${p.id}_${checkedInAt.millisecondsSinceEpoch}',
      type: PresenceType.professional,
      entityId: p.id,
      displayName: p.name,
      checkedInAt: checkedInAt,
      expiresAt: checkedInAt.add(const Duration(minutes: 60)),
      professional: p,
    );
  }

  String get timeAgo {
    final diff = DateTime.now().difference(checkedInAt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes == 1) return '1 min ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes} mins ago';
    if (diff.inHours == 1) return '1 hour ago';
    return '${diff.inHours} hours ago';
  }

  /// Whether this presence has expired
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
}

/// Central engine that makes the event feel alive.
///
/// Emits events: arrivals, expiries, count changes, time ticks.
/// Supports multiple presence types (Professional, Organization, Booth, Session).
class PresenceEngine {
  final DiscoveryRepository _repository;
  final Random _random = Random();

  List<Presence> _active = [];
  Timer? _arrivalTimer;
  Timer? _tickTimer;
  bool _running = false;

  /// Stream of presence events
  final _controller = StreamController<PresenceEvent>.broadcast();
  Stream<PresenceEvent> get events => _controller.stream;

  /// Current active count across all types
  int get activeCount => _active.length;

  /// Current active list (sorted: newest first)
  List<Presence> get active => List.unmodifiable(_active);

  /// Convenience: active professionals only
  List<Professional> get activeProfessionals =>
      Presence.onlyProfessionals(_active);

  PresenceEngine({DiscoveryRepository? repository})
      : _repository = repository ?? DiscoveryRepository();

  /// Start the engine. Call when Discovery screen mounts.
  void start() {
    if (_running) return;
    _running = true;

    // Load initial professionals
    _repository.getProfessionals().then((pros) {
      if (!_running) return;
      final now = DateTime.now();
      _active = pros.map((p) => Presence.fromProfessional(p, now)).toList();
      _controller.add(PresenceInitial(List.from(_active)));
    });

    // Periodic new arrivals every 20-40 seconds
    _scheduleNextArrival();

    // Tick every 30 seconds to update relative times
    _tickTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!_running) return;
      _controller.add(PresenceTimeTick(List.from(_active)));
    });
  }

  /// Stop the engine. Call when Discovery screen disposes.
  void stop() {
    _running = false;
    _arrivalTimer?.cancel();
    _tickTimer?.cancel();
  }

  void _scheduleNextArrival() {
    if (!_running) return;
    final delay = 20 + _random.nextInt(21); // 20-40 seconds
    _arrivalTimer = Timer(Duration(seconds: delay), () {
      if (!_running) return;
      _addRandomArrival();
      _scheduleNextArrival();
    });
  }

  Future<void> _addRandomArrival() async {
    final arrivals = await _repository.getNewArrivals();
    if (!_running || arrivals.isEmpty) return;

    // Pick one random arrival
    final arrival = arrivals[_random.nextInt(arrivals.length)];

    // Add with a checkedInAt timestamp
    final now = DateTime.now();
    final presence = Presence.fromProfessional(arrival, now);

    _active = [presence, ..._active];
    _controller.add(PresenceArrival(presence, List.from(_active)));

    // Schedule expiry after 60 minutes
    Timer(const Duration(minutes: 60), () {
      if (!_running) return;
      _active.removeWhere((p) => p.presenceId == presence.presenceId);
      _controller.add(PresenceExpiry(presence, List.from(_active)));
    });
  }

  /// Manually check in a professional (from the Arrival flow)
  void checkIn(Professional professional) {
    final now = DateTime.now();
    final presence = Presence.fromProfessional(professional, now);

    _active = [presence, ..._active];
    _controller.add(PresenceArrival(presence, List.from(_active)));
  }

  /// Generate a heartbeat message based on current state
  String generateHeartbeatMessage() {
    final pros = activeProfessionals;
    if (pros.isEmpty) return 'Waiting for professionals to arrive...';

    // Pick a recently arrived professional (from the first few)
    final recent = pros.take(5).toList();
    if (recent.isEmpty) return '${pros.length} professionals nearby';

    final pick = recent[_random.nextInt(recent.length)];
    final msgType = _random.nextInt(5);

    switch (msgType) {
      case 0:
        return '${pick.name} just checked in';
      case 1:
        final industries = [
          'Manufacturing', 'Fintech', 'AI', 'Healthcare',
          'SaaS', 'Automotive', 'Logistics', 'Energy',
        ];
        return 'Someone from ${industries[_random.nextInt(industries.length)]} arrived';
      case 2:
        final roles = ['Founder', 'Engineer', 'Investor', 'Designer', 'Product Manager'];
        return 'A ${roles[_random.nextInt(roles.length)]} just checked in';
      case 3:
        return '${pros.length} ${pros.length == 1 ? 'professional is' : 'professionals are'} nearby';
      case 4:
        return 'A company matching your interests is now here';
      default:
        return '${pick.name} just checked in';
    }
  }

  void dispose() {
    stop();
    _controller.close();
  }
}

/// Events emitted by the PresenceEngine
sealed class PresenceEvent {
  final List<Presence> presences;
  const PresenceEvent(this.presences);
}

class PresenceInitial extends PresenceEvent {
  const PresenceInitial(super.presences);
}

class PresenceArrival extends PresenceEvent {
  final Presence arrival;
  const PresenceArrival(this.arrival, super.presences);
}

class PresenceExpiry extends PresenceEvent {
  final Presence expired;
  const PresenceExpiry(this.expired, super.presences);
}

class PresenceTimeTick extends PresenceEvent {
  const PresenceTimeTick(super.presences);
}
