import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../state/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    final user = authState.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // User Avatar & Name
              _buildProfileHeader(user),
              const SizedBox(height: 28),
              
              // Menu Options Group 1 (Account details)
              _buildMenuGroup(context, 'Akun', [
                _buildMenuItem(Icons.person_outline, 'Edit Profil', () {}),
                _buildMenuItem(Icons.map_outlined, 'Alamat Saya', () {}),
              ]),
              const SizedBox(height: 20),
              
              // Menu Options Group 2 (App settings & Info)
              _buildMenuGroup(context, 'Pengaturan & Bantuan', [
                _buildMenuItem(Icons.notifications_none_outlined, 'Notifikasi', () => context.push('/notifications')),
                _buildMenuItem(Icons.settings_outlined, 'Pengaturan Aplikasi', () => context.push('/settings')),
                _buildMenuItem(Icons.help_outline, 'Pusat Bantuan', () => context.push('/help')),
              ]),
              const SizedBox(height: 28),
              
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await authState.logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  icon: const Icon(Icons.logout, size: 20),
                  label: const Text('Keluar Akun'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorContainer,
                    foregroundColor: AppColors.error,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppColors.errorContainer),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Versi Aplikasi 1.0.0 (Build 120)',
                style: TextStyle(fontSize: 11, color: AppColors.secondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withAlpha(26),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
            image: user?.profileImage != null
                ? DecorationImage(
                    image: NetworkImage(user!.profileImage),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: user?.profileImage == null
              ? const Icon(Icons.person, size: 48, color: AppColors.primary)
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          user?.name ?? 'Julian Thorne',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        Text(
          user?.email ?? 'julian@example.com',
          style: const TextStyle(fontSize: 13, color: AppColors.secondary),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.stars, color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              Text(
                user?.tier ?? 'Platinum Member',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuGroup(BuildContext context, String headerTitle, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            headerTitle,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary, letterSpacing: 0.5),
          ),
        ),
        GlassCard(
          borderRadius: 24,
          padding: EdgeInsets.zero,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: AppColors.secondaryContainer,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.outline),
      onTap: onTap,
    );
  }
}
