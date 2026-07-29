import '../../../core/api/api_client.dart';
import '../models/arrival_models.dart';

class ArrivalRepository {
  final ApiClient _api = ApiClient();

  Future<List<BusinessEvent>> getNearbyEvents() async {
    try {
      final data = await _api.getActiveEvents();
      return data.map((json) => _parseEvent(json as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<Persona> getCurrentUser() async {
    try {
      final data = await _api.getProfessionalIdentity('personal');
      return Persona(
        id: data['personId'] as String? ?? 'person-self',
        name: data['name'] as String? ?? 'You',
        role: data['title'] as String? ?? '',
        company: data['company'] as String? ?? '',
        industry: (data['industries'] as List<dynamic>?)?.isNotEmpty == true
            ? (data['industries'] as List<dynamic>).first.toString()
            : '',
        skills: (data['skills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      );
    } catch (_) {
      return const Persona(
        id: 'person-self',
        name: 'You',
        role: '',
        company: '',
        industry: '',
        skills: [],
      );
    }
  }

  BusinessEvent _parseEvent(Map<String, dynamic> json) {
    final venueData = json['venue'] as Map<String, dynamic>?;
    final startDate = json['startDate'] != null ? DateTime.parse(json['startDate'] as String) : null;
    final endDate = json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null;

    final status = json['status'] as String? ?? 'active';
    String mappedStatus;
    if (status == 'ACTIVE') {
      mappedStatus = 'live';
    } else if (status == 'DRAFT') {
      mappedStatus = 'upcoming';
    } else {
      mappedStatus = 'ended';
    }

    return BusinessEvent(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Untitled Event',
      venue: venueData?['name'] as String? ?? '',
      distance: venueData?['distance'] as String? ?? '',
      professionalCount: json['professionalCount'] as int? ?? 0,
      businessCount: json['businessCount'] as int? ?? 0,
      presentCount: json['presentCount'] as int? ?? 0,
      visibleCount: json['visibleCount'] as int? ?? 0,
      visitorCount: json['visitorCount'] as int? ?? 0,
      connectionsAttending: json['connectionsAttending'] as int? ?? 0,
      expertiseMatches: json['expertiseMatches'] as int? ?? 0,
      eventType: EventType.expo,
      status: mappedStatus,
      startDate: startDate,
      endDate: endDate,
      dayNumber: 1,
      totalDays: startDate != null && endDate != null
          ? (endDate.difference(startDate).inDays + 1)
          : 1,
      description: json['description'] as String? ?? '',
      venueAddress: venueData?['address'] as String? ?? '',
      organizerName: (json['organizer'] as Map<String, dynamic>?)?['name'] as String? ?? '',
      startHour: startDate?.hour ?? 9,
      startMinute: startDate?.minute ?? 0,
    );
  }
}
