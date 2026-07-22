import 'dart:async';
import 'dart:math';
import '../models/professional.dart';
import '../repository/discovery_repository.dart';

/// Central engine that makes the event feel alive.
///
/// Emits events: arrivals, expiries, count changes, time ticks.
/// The Discovery screen subscribes to it — it does not own presence state.
class PresenceEngine {
  final DiscoveryRepository _repository;
  final Random _random = Random();

  List<Professional> _active = [];
  Timer? _arrivalTimer;
  Timer? _tickTimer;
  bool _running = false;

  /// Stream of presence events
  final _controller = StreamController<PresenceEvent>.broadcast();
  Stream<PresenceEvent> get events => _controller.stream;

  /// Current active count
  int get activeCount => _active.length;

  /// Current active list (sorted: newest first)
  List<Professional> get active => List.unmodifiable(_active);

  PresenceEngine({DiscoveryRepository? repository})
      : _repository = repository ?? DiscoveryRepository();

  /// Start the engine. Call when Discovery screen mounts.
  void start() {
    if (_running) return;
    _running = true;

    // Load initial professionals
    _repository.getProfessionals().then((pros) {
      if (!_running) return;
      _active = pros;
      _controller.add(PresenceInitial(pros));
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
    final timedArrival = Professional(
      id: arrival.id,
      name: arrival.name,
      title: arrival.title,
      company: arrival.company,
      industry: arrival.industry,
      photoUrl: arrival.photoUrl,
      mutualConnections: arrival.mutualConnections,
      relevanceReason: arrival.relevanceReason,
      isRecentlyArrived: true,
      minutesAgo: 0,
      about: arrival.about,
      skills: arrival.skills,
      lookingFor: arrival.lookingFor,
      recentActivity: arrival.recentActivity,
      broadcastsThisMonth: arrival.broadcastsThisMonth,
      checkedInAt: now,
    );

    _active = [timedArrival, ..._active];
    _controller.add(PresenceArrival(timedArrival, List.from(_active)));

    // Schedule expiry after 60 minutes
    Timer(const Duration(minutes: 60), () {
      if (!_running) return;
      _active.removeWhere((p) => p.id == timedArrival.id);
      _controller.add(PresenceExpiry(timedArrival, List.from(_active)));
    });
  }

  /// Manually check in a professional (from the Arrival flow)
  void checkIn(Professional professional) {
    final now = DateTime.now();
    final timed = Professional(
      id: professional.id,
      name: professional.name,
      title: professional.title,
      company: professional.company,
      industry: professional.industry,
      photoUrl: professional.photoUrl,
      mutualConnections: professional.mutualConnections,
      relevanceReason: professional.relevanceReason,
      isRecentlyArrived: true,
      minutesAgo: 0,
      about: professional.about,
      skills: professional.skills,
      lookingFor: professional.lookingFor,
      recentActivity: professional.recentActivity,
      broadcastsThisMonth: professional.broadcastsThisMonth,
      checkedInAt: now,
    );

    _active = [timed, ..._active];
    _controller.add(PresenceArrival(timed, List.from(_active)));
  }

  /// Generate a heartbeat message based on current state
  String generateHeartbeatMessage() {
    if (_active.isEmpty) return 'Waiting for professionals to arrive...';

    // Pick a recently arrived professional (from the first few)
    final recent = _active.take(5).toList();
    if (recent.isEmpty) return '${_active.length} professionals nearby';

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
        return '${_active.length} ${_active.length == 1 ? 'professional is' : 'professionals are'} nearby';
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
  final List<Professional> professionals;
  const PresenceEvent(this.professionals);
}

class PresenceInitial extends PresenceEvent {
  const PresenceInitial(super.professionals);
}

class PresenceArrival extends PresenceEvent {
  final Professional arrival;
  const PresenceArrival(this.arrival, super.professionals);
}

class PresenceExpiry extends PresenceEvent {
  final Professional expired;
  const PresenceExpiry(this.expired, super.professionals);
}

class PresenceTimeTick extends PresenceEvent {
  const PresenceTimeTick(super.professionals);
}
