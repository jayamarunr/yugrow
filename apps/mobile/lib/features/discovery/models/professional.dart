class Professional {
  final String id;
  final String name;
  final String title;
  final String company;
  final String industry;
  final String photoUrl;
  final int mutualConnections;
  final String relevanceReason;
  final bool isRecentlyArrived;
  final int minutesAgo;
  final String about;
  final List<String> skills;
  final String lookingFor;
  final String recentActivity;
  final int broadcastsThisMonth;
  final DateTime? checkedInAt;

  const Professional({
    required this.id,
    required this.name,
    required this.title,
    required this.company,
    required this.industry,
    this.photoUrl = '',
    this.mutualConnections = 0,
    this.relevanceReason = '',
    this.isRecentlyArrived = false,
    this.minutesAgo = 0,
    this.about = '',
    this.skills = const [],
    this.lookingFor = '',
    this.recentActivity = '',
    this.broadcastsThisMonth = 0,
    this.checkedInAt,
  });

  String get timeAgo {
    if (checkedInAt != null) {
      final diff = DateTime.now().difference(checkedInAt!);
      if (diff.inSeconds < 60) return 'Just now';
      if (diff.inMinutes == 1) return '1 min ago';
      if (diff.inMinutes < 60) return '${diff.inMinutes} mins ago';
      if (diff.inHours == 1) return '1 hour ago';
      return '${diff.inHours} hours ago';
    }
    if (minutesAgo < 1) return 'Just now';
    if (minutesAgo == 1) return '1 min ago';
    return '$minutesAgo mins ago';
  }
}
