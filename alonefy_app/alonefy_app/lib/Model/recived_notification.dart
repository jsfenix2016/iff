class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final String? body;
  final int id;
  final String? payload;
  final String? title;
}
