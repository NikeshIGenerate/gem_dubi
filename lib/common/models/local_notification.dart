class GroupLocalNotification {
  final DateTime date;
  final List<LocalNotification> notifications;

  GroupLocalNotification({required this.date, required this.notifications});
}

class LocalNotification {
  final int id;
  final String title;
  final String body;
  final DateTime createdAt;

  const LocalNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  factory LocalNotification.fromJson(Map<String, dynamic> json) {
    return LocalNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'LocalNotification{id: $id, title: $title, body: $body, createdAt: ${createdAt.toIso8601String()}}';
  }
}
