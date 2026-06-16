import '../../domain/models/notification_model.dart';
import '../../domain/services/notification_service.dart';

class MockNotificationService implements NotificationService {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: 'notif-1',
      title: 'Pesanan Diproses',
      message: 'Pesanan LK-9021 Anda sedang dicuci oleh tim LaundryKu.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      type: NotificationType.order,
      isRead: false,
    ),
    NotificationModel(
      id: 'notif-2',
      title: 'Hemat Akhir Pekan',
      message: 'Gunakan kode promo BERSIHHEMAT untuk diskon Rp 10.000 akhir pekan ini!',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      type: NotificationType.promo,
      isRead: false,
    ),
    NotificationModel(
      id: 'notif-3',
      title: 'Pembayaran Sukses',
      message: 'Pembayaran untuk pesanan LK-8842 telah berhasil diterima.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      type: NotificationType.order,
      isRead: true,
    ),
  ];

  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_notifications);
  }

  @override
  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }
}
