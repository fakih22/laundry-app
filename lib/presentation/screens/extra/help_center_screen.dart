import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/glass_card.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        'q': 'Bagaimana cara memesan layanan antar jemput?',
        'a': 'Pilih layanan di halaman Beranda, sesuaikan berat perkiraan atau jumlah item, tentukan tanggal penjemputan dan pengantaran, pilih metode pembayaran, dan ketuk bayar. Kurir akan datang sesuai jadwal.'
      },
      {
        'q': 'Berapa biaya pengiriman di LaundryKu?',
        'a': 'Biaya pengantaran dan penjemputan pakaian di LaundryKu adalah gratis (Rp 0) untuk seluruh area jangkauan operasional kami dengan minimal pemesanan Rp 30.000.'
      },
      {
        'q': 'Bagaimana jika pakaian saya rusak atau hilang?',
        'a': 'LaundryKu menyediakan jaminan ganti rugi hingga 10x lipat biaya cuci jika terjadi kerusakan atau kehilangan pakaian akibat kelalaian operasional kami.'
      },
      {
        'q': 'Berapa lama proses pencucian?',
        'a': 'Layanan standar diselesaikan dalam waktu 2 hari kerja. Kami juga menyediakan layanan Kilat (Express) yang selesai dalam waktu 24 jam dengan biaya tambahan.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusat Bantuan'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Support Banner Contact
              _buildSupportContactBanner(context),
              const SizedBox(height: 24),
              
              // FAQ Header
              const Text(
                'Pertanyaan Sering Diajukan (FAQ)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 12),
              
              // FAQ list
              _buildFaqList(faqs),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportContactBanner(BuildContext context) {
    return GlassCard(
      borderRadius: 24,
      color: AppColors.primaryContainer,
      border: Border.all(color: Colors.white.withAlpha(50)),
      child: Column(
        children: [
          const Icon(Icons.support_agent, size: 48, color: Colors.white),
          const SizedBox(height: 12),
          const Text(
            'Butuh Bantuan Lebih Cepat?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tim CS kami siap membantu Anda 24/7 untuk keluhan atau kendala penjemputan.',
            style: TextStyle(fontSize: 12, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat, color: AppColors.primary),
                  label: const Text('WhatsApp CS'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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

  Widget _buildFaqList(List<Map<String, String>> faqs) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        final faq = faqs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            borderRadius: 20,
            padding: const EdgeInsets.all(4),
            child: ExpansionTile(
              title: Text(
                faq['q']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
              ),
              shape: const Border(), // remove separator borders
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                Text(
                  faq['a']!,
                  style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
