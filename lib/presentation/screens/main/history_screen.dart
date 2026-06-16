import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../state/order_state.dart';
import '../../state/cart_state.dart';
import '../../../domain/models/order_model.dart';
import '../../../domain/models/laundry_service.dart';
import '../../../data/services/mock_laundry_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleReorder(BuildContext context, OrderModel order) async {
    // Find service and redirect to detail
    final catalogueService = MockLaundryService();
    final services = await catalogueService.getServices();
    
    // Find matching service
    LaundryService? matchedService;
    for (var s in services) {
      if (s.name == order.serviceName.replaceAll('Premium ', '')) {
        matchedService = s;
        break;
      }
    }
    matchedService ??= services.first;

    if (context.mounted) {
      final cartState = Provider.of<CartState>(context, listen: false);
      cartState.selectService(matchedService);
      context.push('/service-detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderState = Provider.of<OrderState>(context);
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.secondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'Aktif'),
            Tab(text: 'Selesai'),
            Tab(text: 'Dibatalkan'),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE3F2FD),
              Color(0xFFF9F9F9),
            ],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildOrderList(orderState.activeOrders, currencyFormatter, dateFormatter, isLinkToTrack: true),
            _buildOrderList(orderState.completedOrders, currencyFormatter, dateFormatter),
            _buildOrderList(orderState.cancelledOrders, currencyFormatter, dateFormatter),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(
    List<OrderModel> orders,
    NumberFormat currencyFormatter,
    DateFormat dateFormatter, {
    bool isLinkToTrack = false,
  }) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer.withAlpha(77),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            const Text(
              'Belum Ada Pesanan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Anda belum memiliki transaksi di kategori ini saat ini.',
                style: TextStyle(fontSize: 14, color: AppColors.secondary),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: GlassCard(
            borderRadius: 24,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID Pesanan: ${order.id}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary),
                    ),
                    _buildStatusBadge(order.status),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Title
                Text(
                  order.serviceName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                const SizedBox(height: 12),
                const Divider(color: AppColors.outlineVariant, height: 1),
                const SizedBox(height: 12),
                
                // Info Details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.secondary),
                            const SizedBox(width: 6),
                            Text(
                              dateFormatter.format(order.orderDate),
                              style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.payments_outlined, size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              currencyFormatter.format(order.totalAmount),
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    // Button action
                    if (isLinkToTrack)
                      ElevatedButton(
                        onPressed: () {
                          context.push('/success?type=order_completed&orderId=${order.id}');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Lacak', style: TextStyle(fontSize: 13)),
                      )
                    else
                      OutlinedButton(
                        onPressed: () => _handleReorder(context, order),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Pesan Lagi', style: TextStyle(fontSize: 13)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color bgColor;
    Color textColor;
    String label = status.displayNameIndonesian;

    switch (status) {
      case OrderStatus.received:
      case OrderStatus.pickupAssigned:
      case OrderStatus.processing:
      case OrderStatus.ironing:
      case OrderStatus.packaging:
      case OrderStatus.delivery:
        bgColor = AppColors.secondaryContainer;
        textColor = AppColors.primary;
        break;
      case OrderStatus.completed:
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        break;
      case OrderStatus.cancelled:
        bgColor = AppColors.errorContainer;
        textColor = AppColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
