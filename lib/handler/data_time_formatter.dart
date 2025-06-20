class DateTimeFormatter {
   static DateTimeFormatter? _instance;

  DateTimeFormatter._internal();
  static DateTimeFormatter get instance {
     _instance ??= DateTimeFormatter._internal();
    return _instance!;
  }

  static String calculateTimeDifference(String createdAt) {
     try {
      DateTime notificationTime = DateTime.parse(createdAt);
      notificationTime = notificationTime.toLocal();
      DateTime currentTime = DateTime.now();

      Duration difference = currentTime.difference(notificationTime);

      if (difference.inSeconds < 60) {
        return '${difference.inSeconds} sec ago';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} min ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hr ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        int weeks = (difference.inDays / 7).floor();
        return '$weeks week${weeks > 1 ? 's' : ''} ago';
      } else if (difference.inDays < 365) {
        int months = (difference.inDays / 30).floor();
        return '$months month${months > 1 ? 's' : ''} ago';
      } else {
        int years = (difference.inDays / 365).floor();
        return '$years year${years > 1 ? 's' : ''} ago';
      }
    } catch (e) {
      return 'Just now';
    }
  }
}