import '../../../core/api/api_client.dart';
import '../models/professional.dart';

class DiscoveryRepository {
  final ApiClient _api = ApiClient();

  Future<List<Professional>> getProfessionals({String? eventId, String? viewerPersonId}) async {
    try {
      final data = await _api.getLiveAttendees(eventId ?? '', viewerPersonId: viewerPersonId);
      return data.map((json) => _parseProfessional(json as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Professional>> getNewArrivals() async {
    return [];
  }

  Professional _parseProfessional(Map<String, dynamic> json) {
    final minutesAgo = json['checkedInAt'] != null
        ? DateTime.now().difference(DateTime.parse(json['checkedInAt'] as String)).inMinutes
        : 0;

    return Professional(
      id: json['personId'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      title: json['title'] as String? ?? '',
      company: json['company'] as String? ?? '',
      industry: json['industry'] as String? ?? '',
      photoUrl: json['avatarUrl'] as String? ?? '',
      mutualConnections: (json['mutualConnections'] as num?)?.toInt() ?? 0,
      isRecentlyArrived: minutesAgo < 5,
      minutesAgo: minutesAgo,
      about: json['bio'] as String? ?? '',
      skills: (json['skills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      lookingFor: json['lookingFor'] as String? ?? '',
      checkedInAt: json['checkedInAt'] != null ? DateTime.parse(json['checkedInAt'] as String) : null,
    );
  }
}
