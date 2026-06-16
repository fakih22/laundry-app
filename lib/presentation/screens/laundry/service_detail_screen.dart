import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../state/cart_state.dart';

class ServiceDetailScreen extends StatefulWidget {
  const ServiceDetailScreen({super.key});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final NumberFormat _currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  final DateFormat _dateFormatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
  final DateFormat _timeFormatter = DateFormat('HH:mm');

  Future<void> _selectPickupDateTime(BuildContext context, CartState cart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: cart.pickupSchedule,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      locale: const Locale('id', 'ID'),
    );

    if (pickedDate != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(cart.pickupSchedule),
      );

      if (pickedTime != null && context.mounted) {
        final pickupDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        final deliveryDateTime = pickupDateTime.add(const Duration(days: 2)); // Default 2 days processing
        cart.setSchedules(pickupDateTime, deliveryDateTime);
      }
    }
  }

  Future<void> _selectDeliveryDateTime(BuildContext context, CartState cart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: cart.deliverySchedule,
      firstDate: cart.pickupSchedule.add(const Duration(hours: 24)),
      lastDate: cart.pickupSchedule.add(const Duration(days: 30)),
      locale: const Locale('id', 'ID'),
    );

    if (pickedDate != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(cart.deliverySchedule),
      );

      if (pickedTime != null && context.mounted) {
        final deliveryDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        cart.setSchedules(cart.pickupSchedule, deliveryDateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartState>(context);
    final service = cart.selectedService;

    if (service == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Layanan tidak ditemukan.'),
        ),
      );
    }

    final bool isWeightBased = service.unit == 'kg';

    return Scaffold(
      appBar: AppBar(
        title: Text(service.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            context.pop();
          },
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
                    // Service Info Banner
                    _buildServiceHeader(service),
                    const SizedBox(height: 20),
                    
                    // Weight Slider (for kg-based service)
                    if (isWeightBased) ...[
                      _buildWeightSelector(cart),
                      const SizedBox(height: 20),
                    ],
                    
                    // Specific Items Selector (for piece-based or add-on items)
                    if (service.items.isNotEmpty) ...[
                      _buildItemsSelector(cart, service),
                      const SizedBox(height: 20),
                    ],
                    
                    // Scheduling Section
                    _buildSchedulingSection(context, cart),
                    const SizedBox(height: 20),
                    
                    // Address Section
                    _buildAddressSection(cart),
                  ],
                ),
              ),
            ),
            
            // Bottom Action Bar
            _buildBottomBar(context, cart),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceHeader(dynamic service) {
    return GlassCard(
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColors.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_laundry_service, color: AppColors.primary, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Harga: ${_currencyFormatter.format(service.basePrice)} / ${service.unit}',
                      style: const TextStyle(fontSize: 14, color: AppColors.secondary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            service.description,
            style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightSelector(CartState cart) {
    return GlassCard(
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Perkiraan Berat Cucian',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          const Text(
            'Estimasi berat cucian Anda untuk penjemputan. Timbangan asli akan dilakukan oleh kurir.',
            style: TextStyle(fontSize: 12, color: AppColors.secondary),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${cart.estimatedWeight.toStringAsFixed(1)} kg',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primaryContainer),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _currencyFormatter.format(cart.selectedService!.basePrice * cart.estimatedWeight),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                ),
              ),
            ],
          ),
          Slider(
            value: cart.estimatedWeight,
            min: 1.0,
            max: 10.0,
            divisions: 18,
            activeColor: AppColors.primaryContainer,
            inactiveColor: AppColors.outlineVariant,
            label: '${cart.estimatedWeight.toStringAsFixed(1)} kg',
            onChanged: (val) {
              cart.setWeight(val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSelector(CartState cart, dynamic service) {
    return GlassCard(
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Pakaian',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pilih item pakaian tertentu untuk dicuci satuan atau ditambahkan ke cucian.',
            style: TextStyle(fontSize: 12, color: AppColors.secondary),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: service.items.length,
            itemBuilder: (context, index) {
              final item = service.items[index];
              // Retrieve active item qty from cart state
              final cartItem = cart.items.firstWhere((i) => i.id == item.id, orElse: () => item);
              final int qty = cartItem.quantity;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.checkroom, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                          ),
                          Text(
                            _currencyFormatter.format(item.price),
                            style: const TextStyle(fontSize: 12, color: AppColors.secondary),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: AppColors.secondary),
                          onPressed: () {
                            cart.updateItemQuantity(item.id, -1);
                          },
                        ),
                        Text(
                          '$qty',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryContainer),
                          onPressed: () {
                            cart.updateItemQuantity(item.id, 1);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSchedulingSection(BuildContext context, CartState cart) {
    return GlassCard(
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jadwal Pengantaran & Penjemputan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          
          // Pickup Time row
          GestureDetector(
            onTap: () => _selectPickupDateTime(context, cart),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.outlineVariant),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withAlpha(127),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Jadwal Penjemputan', style: TextStyle(fontSize: 11, color: AppColors.secondary)),
                        const SizedBox(height: 2),
                        Text(
                          '${_dateFormatter.format(cart.pickupSchedule)}, ${_timeFormatter.format(cart.pickupSchedule)}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.outline),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Delivery Time row
          GestureDetector(
            onTap: () => _selectDeliveryDateTime(context, cart),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.outlineVariant),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withAlpha(127),
              ),
              child: Row(
                children: [
                  const Icon(Icons.delivery_dining_outlined, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Jadwal Pengantaran (Kembali)', style: TextStyle(fontSize: 11, color: AppColors.secondary)),
                        const SizedBox(height: 2),
                        Text(
                          '${_dateFormatter.format(cart.deliverySchedule)}, ${_timeFormatter.format(cart.deliverySchedule)}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.outline),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(CartState cart) {
    return GlassCard(
      borderRadius: 24,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.map_outlined, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lokasi Penjemputan (${cart.addressName})',
                  style: const TextStyle(fontSize: 12, color: AppColors.secondary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  cart.addressDetail,
                  style: const TextStyle(fontSize: 13, color: AppColors.onSurface, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CartState cart) {
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
              const Text('Total Sementara', style: TextStyle(fontSize: 12, color: AppColors.secondary)),
              const SizedBox(height: 4),
              Text(
                _currencyFormatter.format(cart.subtotal),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primaryContainer),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              context.push('/cart');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Row(
              children: [
                Text('Lanjut'),
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
