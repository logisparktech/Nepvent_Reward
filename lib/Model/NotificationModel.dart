class NotificationModel {
  final String id;
  final List<NotificationPicture> notificationPicture;
  final List viewedUser;
  final String title;
  final String content;
  final DateTime date;
  final String time;
  final String redirectedUrl;

  NotificationModel({
    required this.id,
    required this.notificationPicture,
    required this.viewedUser,
    required this.title,
    required this.content,
    required this.date,
    required this.time,
    required this.redirectedUrl,
  });
}

class NotificationPicture {
  final String id;
  final String url;

  NotificationPicture({
    required this.id,
    required this.url,
  });
}
