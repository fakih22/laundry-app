import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../state/auth_state.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    final user = authState.currentUser;

    final List<Map<String, dynamic>> rewards = [
      {
        'title': 'Diskon Rp 20.000',
        'points': 500,
        'description': 'Potongan langsung untuk semua jenis layanan.',
        'icon': Icons.card_giftcard,
      },
      {
        'title': 'Gratis Setrika Saja 1 Kg',
        'points': 300,
        'description': 'Layanan setrika uap gratis untuk 1 kg pakaian.',
        'icon': Icons.iron_outlined,
      },
      {
        'title': 'Diskon Pengiriman Rp 10.000',
        'points': 200,
        'description': 'Kupon potongan ongkos kirim ke alamat Anda.',
        'icon': Icons.local_shipping_outlined,
      },
      {
        'title': 'Parfum Premium Ekstra',
        'points': 150,
        'description': 'Pilihan wewangian premium tahan lama untuk cucian Anda.',
        'icon': Icons.ac_unit,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward Loyalitas'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Point summary header
              _buildPointsHeader(user),
              const SizedBox(height: 24),
              
              // Points Progression Bar
              _buildPointsProgression(),
              const SizedBox(height: 28),
              
              // Rewards List
              const Text(
                'Tukarkan Poin Anda',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              _buildRewardsList(context, rewards, user?.points ?? 2850),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointsHeader(dynamic user) {
    return GlassCard(
      borderRadius: 24,
      color: AppColors.primaryContainer,
      border: Border.all(color: Colors.white.withAlpha(50)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'STATUS MEMBERSHIP',
                style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.stars, color: Colors.amber, size: 14),
                    SizedBox(width: 4),
                    Text('Platinum', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${user?.points ?? 2850}',
            style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800),
          ),
          const Text(
            'Poin Terkumpul',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsProgression() {
    return GlassCard(
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tingkat Berikutnya: VIP',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              Text(
                '150 Poin Lagi',
                style: TextStyle(fontSize: 12, color: AppColors.secondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 2850 / 3000,
              minHeight: 8,
              backgroundColor: AppColors.secondaryContainer,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryContainer),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dapatkan keuntungan gratis ongkir tanpa batas di tingkat VIP.',
            style: TextStyle(fontSize: 11, color: AppColors.secondary),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsList(BuildContext context, List<Map<String, dynamic>> rewards, int userPoints) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        final r = rewards[index];
        final bool canClaim = userPoints >= r['points'];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            borderRadius: 20,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(r['icon'], color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        r['description'],
                        style: const TextStyle(fontSize: 12, color: AppColors.secondary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${r['points']} Poin',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: canClaim ? AppColors.primaryContainer : AppColors.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: canClaim
                      ? () {
                          // Claim action
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Voucher "${r['title']}" berhasil ditukarkan!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Klaim', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
