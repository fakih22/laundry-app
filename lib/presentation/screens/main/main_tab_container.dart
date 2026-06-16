import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/glass_card.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'tracking_screen.dart';
import 'reward_screen.dart';
import 'profile_screen.dart';

class MainTabContainer extends StatefulWidget {
  final int initialTab;

  const MainTabContainer({
    super.key,
    this.initialTab = 0,
  });

  @override
  State<MainTabContainer> createState() => _MainTabContainerState();
}

class _MainTabContainerState extends State<MainTabContainer> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
    const TrackingScreen(),
    const RewardScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 72,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            borderRadius: 24,
            shadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withAlpha(20),
                blurRadius: 25,
                offset: const Offset(0, -4),
              ),
            ],
            // Wrap Row dalam LayoutBuilder agar item tidak overflow
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double maxWidth = constraints.maxWidth;
                return Row(
                  children: [
                    _buildNavItem(0, Icons.home_outlined, Icons.home, 'Beranda', maxWidth),
                    _buildNavItem(1, Icons.receipt_long_outlined, Icons.receipt_long, 'Riwayat', maxWidth),
                    _buildNavItem(2, Icons.local_shipping_outlined, Icons.local_shipping, 'Lacak', maxWidth),
                    _buildNavItem(3, Icons.stars_outlined, Icons.stars, 'Reward', maxWidth),
                    _buildNavItem(4, Icons.person_outline, Icons.person, 'Profil', maxWidth),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData inactiveIcon, IconData activeIcon, String label, double maxWidth) {
    final bool isSelected = _currentIndex == index;

    // Tentukan padding & margin berdasarkan lebar yang tersedia
    final double horizontalMargin = maxWidth < 360 ? 1.0 : 2.0;
    final double horizontalPadding = isSelected
        ? (maxWidth < 360 ? (maxWidth < 320 ? 4.0 : 6.0) : 10.0)
        : 0.0;
    final double iconTextSpacing = maxWidth < 360 ? 3.0 : 5.0;
    final bool showLabel = isSelected && maxWidth > 300;

    return Expanded(
      // Tab aktif mendapat flex lebih besar agar teks label punya ruang jika ditampilkan
      flex: (isSelected && showLabel) ? 2 : 1,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: horizontalMargin),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 6,
          ),
          decoration: isSelected
              ? BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(20),
                )
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                isSelected ? activeIcon : inactiveIcon,
                color: isSelected ? AppColors.primary : AppColors.secondary,
                size: 22,
              ),
              if (isSelected && showLabel) ...[
                SizedBox(width: iconTextSpacing),
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
