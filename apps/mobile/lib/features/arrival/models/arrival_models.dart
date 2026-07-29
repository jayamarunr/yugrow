enum EventType { expo, conference, meetup, workshop, exhibition }

class BusinessEvent {
  final String id;
  final String name;
  final String venue;
  final String distance;
  final int professionalCount;
  final int connectionsAttending;
  final int expertiseMatches;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  final int startHour;
  final int startMinute;
  final int dayNumber;
  final int totalDays;
  final String description;
  final String venueAddress;
  final String organizerName;
  final String ticketUrl;
  final EventType eventType;
  final int businessCount;
  final int speakerCount;
  final int sponsorCount;
  final int presentCount;
  final int visibleCount;
  final int visitorCount;
  final Map<String, int> peopleBreakdown;

  const BusinessEvent({
    required this.id,
    required this.name,
    required this.venue,
    required this.distance,
    required this.professionalCount,
    this.connectionsAttending = 0,
    this.expertiseMatches = 0,
    required this.status,
    this.startDate,
    this.endDate,
    this.startHour = 9,
    this.startMinute = 0,
    this.dayNumber = 1,
    this.totalDays = 1,
    this.description = '',
    this.venueAddress = '',
    this.organizerName = '',
    this.ticketUrl = '',
    this.eventType = EventType.conference,
    this.businessCount = 0,
    this.speakerCount = 0,
    this.sponsorCount = 0,
    this.presentCount = 0,
    this.visibleCount = 0,
    this.visitorCount = 0,
    this.peopleBreakdown = const {},
  });

  String get statusText {
    switch (status) {
      case 'live':
        return 'Live now';
      case 'starting_soon':
        final hour = startHour > 12 ? startHour - 12 : startHour;
        final amPm = startHour >= 12 ? 'PM' : 'AM';
        return 'Starts at $hour:${startMinute.toString().padLeft(2, '0')} $amPm';
      case 'today':
        final hour = startHour > 12 ? startHour - 12 : startHour;
        final amPm = startHour >= 12 ? 'PM' : 'AM';
        return 'Today, $hour:${startMinute.toString().padLeft(2, '0')} $amPm';
      case 'tomorrow':
        return 'Tomorrow';
      default:
        return status;
    }
  }

  String get dayLabel {
    if (totalDays <= 1) return '';
    if (dayNumber == totalDays) return 'Final Day';
    return 'Day $dayNumber of $totalDays';
  }

  /// Primary metric label for the event type (shown on card)
  String get primaryMetricLabel {
    switch (eventType) {
      case EventType.expo:
      case EventType.exhibition:
        return 'Businesses';
      case EventType.conference:
        return 'Attendees';
      case EventType.meetup:
        return 'Professionals';
      case EventType.workshop:
        return 'Participants';
    }
  }

  /// Primary metric value
  int get primaryMetricValue {
    switch (eventType) {
      case EventType.expo:
      case EventType.exhibition:
        return businessCount;
      case EventType.conference:
      case EventType.meetup:
      case EventType.workshop:
        return professionalCount;
    }
  }

  /// Secondary metric label
  String get secondaryMetricLabel {
    switch (eventType) {
      case EventType.expo:
      case EventType.exhibition:
        return 'Professionals';
      case EventType.conference:
        return 'Speakers';
      case EventType.meetup:
        return 'Companies';
      case EventType.workshop:
        return 'Instructor';
    }
  }

  /// Secondary metric value
  int get secondaryMetricValue {
    switch (eventType) {
      case EventType.expo:
      case EventType.exhibition:
        return professionalCount;
      case EventType.conference:
        return speakerCount;
      case EventType.meetup:
        return businessCount;
      case EventType.workshop:
        return 1; // typically 1 instructor
    }
  }

  /// Whether to show the secondary metric on the card
  bool get showSecondaryMetric => secondaryMetricValue > 0;
}

class Persona {
  final String id;
  final String name;
  final String role;
  final String company;
  final String industry;
  final List<String> skills;
  final String photoUrl;

  const Persona({
    required this.id,
    required this.name,
    required this.role,
    required this.company,
    required this.industry,
    this.skills = const [],
    this.photoUrl = '',
  });
}
