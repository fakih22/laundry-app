import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../state/cart_state.dart';
import '../../../data/services/mock_laundry_service.dart';
import '../../../domain/models/promo_model.dart';

class PromoListScreen extends StatefulWidget {
  const PromoListScreen({super.key});

  @override
  State<PromoListScreen> createState() => _PromoListScreenState();
}

class _PromoListScreenState extends State<PromoListScreen> {
  final MockLaundryService _laundryService = MockLaundryService();
  List<PromoModel> _promos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPromos();
  }

  Future<void> _loadPromos() async {
    try {
      final prms = await _laundryService.getPromos();
      if (mounted) {
        setState(() {
          _promos = prms;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartState>(context);
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Voucher Promo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryContainer)))
            : _promos.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: _promos.length,
                    itemBuilder: (context, index) {
                      final promo = _promos[index];
                      final bool isApplicable = cart.subtotal >= promo.minTransaction;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: GlassCard(
                          borderRadius: 24,
                          padding: const EdgeInsets.all(20),
                          color: isApplicable ? Colors.white : Colors.white.withAlpha(127),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryContainer,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      promo.code,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                                    ),
                                  ),
                                  Text(
                                    'Hingga ${DateFormat('dd MMM yyyy').format(promo.expiryDate)}',
                                    style: const TextStyle(fontSize: 11, color: AppColors.secondary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                promo.title,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                promo.description,
                                style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.4),
                              ),
                              const SizedBox(height: 12),
                              const Divider(color: AppColors.outlineVariant, height: 1),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Min. Transaksi: ${currencyFormatter.format(promo.minTransaction)}',
                                    style: const TextStyle(fontSize: 12, color: AppColors.secondary),
                                  ),
                                  ElevatedButton(
                                    onPressed: isApplicable
                                        ? () {
                                            cart.applyPromo(promo);
                                            Navigator.of(context).pop();
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: const Text('Gunakan', style: TextStyle(fontSize: 13)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.confirmation_num_outlined, size: 64, color: AppColors.secondary),
          SizedBox(height: 16),
          Text(
            'Tidak Ada Voucher Tersedia',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
