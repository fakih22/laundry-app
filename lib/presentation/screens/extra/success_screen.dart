import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../domain/models/order_model.dart';
import '../../state/order_state.dart';

class SuccessScreen extends StatefulWidget {
  final String type; // 'payment_success' or 'order_completed'
  final String? orderId;

  const SuccessScreen({
    super.key,
    required this.type,
    this.orderId,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPayment = widget.type == 'payment_success';
    final orderState = Provider.of<OrderState>(context);
    
    // Find matching order if id is supplied
    final matchedOrder = widget.orderId != null
        ? orderState.orders.firstWhere((o) => o.id == widget.orderId, orElse: () => orderState.orders.first)
        : orderState.orders.isNotEmpty ? orderState.orders.first : null;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E9), // Gentle green
              Color(0xFFF9F9F9),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                
                // Animated circular badge
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2E7D32),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent,
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.check, size: 56, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Title
                Text(
                  isPayment ? 'Pembayaran Sukses!' : 'Lacak Pengiriman Anda',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                
                // Subtitle
                Text(
                  isPayment
                      ? 'Pesanan Anda telah berhasil dibuat. Kurir akan datang sesuai jadwal penjemputan.'
                      : 'Terima kasih telah memesan layanan laundry di LaundryKu. Pakaian Anda sedang diproses oleh kurir.',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.secondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Brief Details Card
                if (matchedOrder != null)
                  GlassCard(
                    borderRadius: 24,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildDetailRow('ID Transaksi', matchedOrder.id),
                        const SizedBox(height: 8),
                        _buildDetailRow('Layanan', matchedOrder.serviceName),
                        const SizedBox(height: 8),
                        _buildDetailRow('Estimasi Selesai', DateFormat('dd MMM yyyy').format(matchedOrder.deliveryDate)),
                        const SizedBox(height: 8),
                        _buildDetailRow('Status Saat Ini', matchedOrder.status.displayNameIndonesian, valueColor: AppColors.primaryContainer),
                      ],
                    ),
                  ),
                  
                const Spacer(),
                
                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/main'); // Go back to Home Dashboard
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Ke Beranda Utama'),
                  ),
                ),
                const SizedBox(height: 12),
                
                if (isPayment)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Switch active index to the tracking screen
                        context.go('/main');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Lihat Pesanan Saya'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.secondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}
