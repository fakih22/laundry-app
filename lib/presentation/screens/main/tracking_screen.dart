import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../state/order_state.dart';
import '../../../domain/models/order_model.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderState = Provider.of<OrderState>(context);
    final activeOrders = orderState.activeOrders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lacak Pesanan'),
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
        child: activeOrders.isEmpty
            ? _buildEmptyState(context)
            : _buildTrackingDetails(context, activeOrders.first),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
            child: const Icon(Icons.local_shipping_outlined, size: 64, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tidak Ada Pengiriman Aktif',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Anda tidak memiliki pesanan yang sedang dikirim saat ini.',
              style: TextStyle(fontSize: 14, color: AppColors.secondary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Direct user to orders tab or back to home
            },
            child: const Text('Pesan Laundry Sekarang'),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingDetails(BuildContext context, OrderModel order) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Map Placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              height: 200,
              width: double.infinity,
              color: AppColors.secondaryContainer,
              child: Stack(
                children: [
                  Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuC1HEDLXMDXLPsVuejSK9LXAUPrxlo9ygJtKKZELfooVUEmslejjdVGo1NKp70cyKqZrmhR5ahPDGlGhTWSw6StHFdPvMPTKu2HMBZU1XsCpPHjMqxdqj2WcSPczUmgdAkLIepb81pdHzBMNoJwUJWjY-3qID9dN3kQNULjjmuMapsCukimt2KUBi3mlvfomI_OawRK5n3GdazTnfLHzhNxSVjYJf0UmArre7Nuo8PcKwfold_wlXc9tQzaumpQFAQCFVuxe2dpTGcY',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(
                    color: AppColors.primary.withAlpha(26),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_shipping, color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'KURIR EN ROUTE',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Driver Info Card
          _buildDriverCard(order),
          const SizedBox(height: 20),
          
          // Timeline Steps
          const Text(
            'Status Pesanan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          _buildTrackingTimeline(order),
        ],
      ),
    );
  }

  Widget _buildDriverCard(OrderModel order) {
    return GlassCard(
      borderRadius: 24,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(order.driverAvatar),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.driverName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${order.driverRating} (${order.driverOrdersCount} order)',
                          style: const TextStyle(fontSize: 12, color: AppColors.secondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'KURIR JEMPUT',
                  style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text('Chat'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone_outlined, size: 18),
                  label: const Text('Telepon'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline(OrderModel order) {
    final List<OrderStatus> allSteps = [
      OrderStatus.received,
      OrderStatus.pickupAssigned,
      OrderStatus.processing,
      OrderStatus.ironing,
      OrderStatus.packaging,
      OrderStatus.delivery,
      OrderStatus.completed,
    ];

    // Find current index
    int currentIndex = allSteps.indexOf(order.status);
    if (order.status == OrderStatus.cancelled) {
      currentIndex = -1; // special handling
    }

    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: allSteps.length,
        itemBuilder: (context, index) {
          final step = allSteps[index];
          final bool isCompleted = index < currentIndex;
          final bool isActive = index == currentIndex;
          final bool isLast = index == allSteps.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Line + Indicator Column
                Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.primaryContainer
                            : isActive
                                ? AppColors.primary
                                : AppColors.outlineVariant,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(77),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                              ]
                            : null,
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : isActive
                              ? const Icon(Icons.play_arrow, size: 14, color: Colors.white)
                              : null,
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: isCompleted ? AppColors.primaryContainer : AppColors.outlineVariant,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                // Text Column
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.displayNameIndonesian,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isActive
                                ? AppColors.primary
                                : isCompleted
                                    ? AppColors.onSurface
                                    : AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isActive ? step.stepDescriptionIndonesian : 'Langkah pengerjaan laundry.',
                          style: TextStyle(
                            fontSize: 12,
                            color: isActive ? AppColors.onSurfaceVariant : AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
