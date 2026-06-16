import '../models/notification_model.dart';

abstract class NotificationService {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String id);
}
