class DispenserNotification {
  final String dispenserName;
  final String message;
  final DateTime date;
  final String faculty;
  final bool isRead;

  DispenserNotification({
    required this.dispenserName,
    required this.message,
    required this.date,
    required this.faculty,
    required this.isRead,
  });
}
