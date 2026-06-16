import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../state/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartState>(context);
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormatter = DateFormat('EEE, d MMM yyyy, HH:mm', 'id_ID');

    final service = cart.selectedService;
    if (service == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Keranjang')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart_outlined, size: 64, color: AppColors.secondary),
              const SizedBox(height: 16),
              const Text('Keranjang Anda Kosong', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/main'),
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Keranjang'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary order card
                    _buildOrderSummaryCard(cart, service, currencyFormatter, dateFormatter),
                    const SizedBox(height: 20),
                    
                    // Promo Section
                    _buildPromoSection(context, cart),
                    const SizedBox(height: 20),
                    
                    // Bill Details
                    _buildBillDetailsCard(cart, currencyFormatter),
                  ],
                ),
              ),
            ),
            
            // Bottom Action bar
            _buildBottomActionBar(context, cart, currencyFormatter),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard(
    CartState cart,
    dynamic service,
    NumberFormat currencyFormatter,
    DateFormat dateFormatter,
  ) {
    return GlassCard(
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ringkasan Layanan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  service.unit.toUpperCase(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            service.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryContainer),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.outlineVariant, height: 1),
          const SizedBox(height: 12),
          
          // Show weight or item quantities
          if (service.unit == 'kg') ...[
            _buildSummaryRow(Icons.scale_outlined, 'Perkiraan Berat', '${cart.estimatedWeight.toStringAsFixed(1)} kg'),
            const SizedBox(height: 8),
          ],
          
          if (cart.items.isNotEmpty) ...[
            const Text(
              'Rincian Pakaian:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary),
            ),
            const SizedBox(height: 6),
            ...cart.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0, left: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.name, style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant)),
                    Text('${item.quantity}x', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
          ],
          
          _buildSummaryRow(Icons.calendar_today_outlined, 'Penjemputan', dateFormatter.format(cart.pickupSchedule)),
          const SizedBox(height: 8),
          _buildSummaryRow(Icons.delivery_dining_outlined, 'Pengantaran', dateFormatter.format(cart.deliverySchedule)),
          const SizedBox(height: 8),
          _buildSummaryRow(Icons.pin_drop_outlined, 'Alamat Jemput', cart.addressDetail, isMultiline: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value, {bool isMultiline = false}) {
    return Row(
      crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: AppColors.secondary),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontSize: 13, color: AppColors.secondary)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            maxLines: isMultiline ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPromoSection(BuildContext context, CartState cart) {
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.confirmation_num_outlined, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: cart.appliedPromo == null
                ? const Text(
                    'Pakai voucher diskon hemat',
                    style: TextStyle(fontSize: 13, color: AppColors.secondary),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Voucher Aktif: ${cart.appliedPromo!.code}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryContainer),
                      ),
                      Text(
                        'Hemat Rp ${cart.appliedPromo!.discountAmount.toInt()}',
                        style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
          ),
          if (cart.appliedPromo == null)
            TextButton(
              onPressed: () => context.push('/promo'),
              child: const Text('Pilih', style: TextStyle(fontWeight: FontWeight.bold)),
            )
          else
            IconButton(
              icon: const Icon(Icons.cancel, color: AppColors.error),
              onPressed: () => cart.removePromo(),
            ),
        ],
      ),
    );
  }

  Widget _buildBillDetailsCard(CartState cart, NumberFormat currencyFormatter) {
    return GlassCard(
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Pembayaran',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          _buildBillRow('Subtotal Layanan', cart.subtotal, currencyFormatter),
          const SizedBox(height: 10),
          _buildBillRow('Biaya Antar Jemput', cart.deliveryFee, currencyFormatter),
          const SizedBox(height: 10),
          _buildBillRow('Pajak PPN (5%)', cart.tax, currencyFormatter),
          if (cart.appliedPromo != null) ...[
            const SizedBox(height: 10),
            _buildBillRow('Potongan Voucher', -cart.discount, currencyFormatter, isDiscount: true),
          ],
          const SizedBox(height: 12),
          const Divider(color: AppColors.outlineVariant, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              Text(
                currencyFormatter.format(cart.totalAmount),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primaryContainer),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String title, double amount, NumberFormat currencyFormatter, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 13, color: AppColors.secondary)),
        Text(
          currencyFormatter.format(amount),
          style: TextStyle(
            fontSize: 13,
            fontWeight: isDiscount ? FontWeight.bold : FontWeight.w600,
            color: isDiscount ? Colors.green : AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(BuildContext context, CartState cart, NumberFormat currencyFormatter) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Total Pembayaran', style: TextStyle(fontSize: 12, color: AppColors.secondary)),
              const SizedBox(height: 4),
              Text(
                currencyFormatter.format(cart.totalAmount),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primaryContainer),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              context.push('/payment');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Row(
              children: [
                Text('Pilih Pembayaran'),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
