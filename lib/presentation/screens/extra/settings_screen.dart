import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../state/theme_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailAlerts = false;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
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
              // Group 1: Appearance
              _buildSectionTitle('Tampilan & Tema'),
              const SizedBox(height: 8),
              GlassCard(
                borderRadius: 24,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.dark_mode_outlined, color: AppColors.primary),
                      title: const Text('Mode Gelap (Dark Mode)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      trailing: Switch(
                        value: themeState.isDarkMode,
                        activeColor: AppColors.primaryContainer,
                        onChanged: (val) {
                          themeState.toggleTheme();
                        },
                      ),
                    ),
                    const Divider(color: AppColors.outlineVariant, height: 1),
                    ListTile(
                      leading: const Icon(Icons.translate, color: AppColors.primary),
                      title: const Text('Bahasa Aplikasi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      trailing: const Text(
                        'Bahasa Indonesia',
                        style: TextStyle(color: AppColors.secondary, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Group 2: Notifications
              _buildSectionTitle('Notifikasi & Pemberitahuan'),
              const SizedBox(height: 8),
              GlassCard(
                borderRadius: 24,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
                      title: const Text('Notifikasi Push HP', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      trailing: Switch(
                        value: _pushNotifications,
                        activeColor: AppColors.primaryContainer,
                        onChanged: (val) {
                          setState(() {
                            _pushNotifications = val;
                          });
                        },
                      ),
                    ),
                    const Divider(color: AppColors.outlineVariant, height: 1),
                    ListTile(
                      leading: const Icon(Icons.email_outlined, color: AppColors.primary),
                      title: const Text('Laporan Email Mingguan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      trailing: Switch(
                        value: _emailAlerts,
                        activeColor: AppColors.primaryContainer,
                        onChanged: (val) {
                          setState(() {
                            _emailAlerts = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Group 3: Privacy and Terms
              _buildSectionTitle('Informasi Lainnya'),
              const SizedBox(height: 8),
              GlassCard(
                borderRadius: 24,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.verified_user_outlined, color: AppColors.primary),
                      title: const Text('Kebijakan Privasi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.outline),
                      onTap: () {},
                    ),
                    const Divider(color: AppColors.outlineVariant, height: 1),
                    ListTile(
                      leading: const Icon(Icons.description_outlined, color: AppColors.primary),
                      title: const Text('Syarat & Ketentuan Layanan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.outline),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary, letterSpacing: 0.5),
      ),
    );
  }
}
