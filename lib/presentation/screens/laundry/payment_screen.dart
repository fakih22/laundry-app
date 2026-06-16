import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../state/cart_state.dart';
import '../../state/order_state.dart';
import '../../../data/services/mock_payment_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final MockPaymentService _paymentService = MockPaymentService();
  String _selectedMethod = 'QRIS';
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _ewalletMethods = [
    {'name': 'GoPay', 'icon': Icons.wallet},
    {'name': 'OVO', 'icon': Icons.account_balance_wallet},
    {'name': 'DANA', 'icon': Icons.wallet},
  ];

  final List<Map<String, dynamic>> _vaMethods = [
    {'name': 'BCA Virtual Account', 'icon': Icons.account_balance},
    {'name': 'Mandiri Virtual Account', 'icon': Icons.account_balance},
    {'name': 'BRI Virtual Account', 'icon': Icons.account_balance},
  ];

  void _handlePayment(BuildContext context, CartState cart, OrderState orderState) async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment transaction
    final success = await _paymentService.processPayment(
      orderId: 'LK-temp',
      paymentMethod: _selectedMethod,
      amount: cart.totalAmount,
    );

    if (success && context.mounted) {
      // Create and save order
      final createdOrder = await orderState.placeOrder(cart, _selectedMethod);
      
      if (context.mounted) {
        setState(() {
          _isProcessing = false;
        });

        if (createdOrder != null) {
          // Clear cart
          cart.clearCart();
          // Redirect to success page
          context.go('/success?type=payment_success&orderId=${createdOrder.id}');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal membuat pesanan. Silakan coba lagi.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } else {
      if (context.mounted) {
        setState(() {
          _isProcessing = false;
        });
        context.push('/failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartState>(context);
    final orderState = Provider.of<OrderState>(context);
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Pembayaran'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          Container(
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
                        // Bill Amount Summary Card
                        _buildBillAmountCard(cart, currencyFormatter),
                        const SizedBox(height: 24),
                        
                        // QRIS Option
                        const Text(
                          'Rekomendasi Pembayaran',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                        const SizedBox(height: 12),
                        _buildMethodTile('QRIS', Icons.qr_code_2, subtitle: 'Bayar instan dengan aplikasi pembayaran apa pun'),
                        const SizedBox(height: 20),
                        
                        // E-wallet Options
                        const Text(
                          'Dompet Digital (E-Wallet)',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                        const SizedBox(height: 12),
                        ..._ewalletMethods.map((m) => _buildMethodTile(m['name'], m['icon'])),
                        const SizedBox(height: 20),
                        
                        // VA Options
                        const Text(
                          'Transfer Virtual Account',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                        const SizedBox(height: 12),
                        ..._vaMethods.map((m) => _buildMethodTile(m['name'], m['icon'])),
                        const SizedBox(height: 20),
                        
                        // COD Option
                        const Text(
                          'Metode Lainnya',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                        const SizedBox(height: 12),
                        _buildMethodTile('Bayar di Tempat (COD)', Icons.money, subtitle: 'Bayar tunai ke kurir saat jemput pakaian'),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                
                // Bottom Action Bar
                _buildBottomActionBar(context, cart, orderState, currencyFormatter),
              ],
            ),
          ),
          
          // Processing overlay spinner
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: GlassCard(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  borderRadius: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryContainer)),
                      SizedBox(height: 16),
                      Text(
                        'Memproses Pembayaran...',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Mohon jangan tutup aplikasi',
                        style: TextStyle(fontSize: 12, color: AppColors.secondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBillAmountCard(CartState cart, NumberFormat currencyFormatter) {
    return GlassCard(
      borderRadius: 24,
      color: AppColors.primaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL TAGIHAN',
                style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0),
              ),
              SizedBox(height: 4),
              Text(
                'Sudah termasuk PPN & Ongkir',
                style: TextStyle(color: Colors.white60, fontSize: 11),
              ),
            ],
          ),
          Text(
            currencyFormatter.format(cart.totalAmount),
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodTile(String name, IconData icon, {String? subtitle}) {
    final bool isSelected = _selectedMethod == name;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMethod = name;
          });
        },
        child: GlassCard(
          borderRadius: 20,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          color: isSelected ? Colors.white : Colors.white.withAlpha(150),
          border: Border.all(
            color: isSelected ? AppColors.primaryContainer : const Color(0xFFE3F2FD).withAlpha(127),
            width: isSelected ? 2 : 1,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.secondaryContainer : AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 11, color: AppColors.secondary),
                      ),
                    ],
                  ],
                ),
              ),
              Radio<String>(
                value: name,
                groupValue: _selectedMethod,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedMethod = val;
                    });
                  }
                },
                activeColor: AppColors.primaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, CartState cart, OrderState orderState, NumberFormat currencyFormatter) {
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
              const Text('Metode Terpilih', style: TextStyle(fontSize: 11, color: AppColors.secondary)),
              const SizedBox(height: 4),
              Text(
                _selectedMethod,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => _handlePayment(context, cart, orderState),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Bayar Sekarang'),
          ),
        ],
      ),
    );
  }
}
