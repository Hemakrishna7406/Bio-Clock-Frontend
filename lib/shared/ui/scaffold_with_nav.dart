import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/app_theme.dart';

/// 4-tab navigation: Home, Inventory, [Scan], Graph, Profile.
/// Center tab has an elevated green circle with scanner icon.
class ScaffoldWithNav extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNav({super.key, required this.child});

  // The 4 "regular" nav items (Scan is the elevated center button).
  static const _destinations = [
    _NavItem(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: 'Home',
        path: '/'),
    _NavItem(
        icon: Icons.inventory_2_outlined,
        selectedIcon: Icons.inventory_2,
        label: 'Inventory',
        path: '/inventory'),
    // index 2 = Scan — handled as the elevated center button
    _NavItem(
        icon: Icons.show_chart_outlined,
        selectedIcon: Icons.show_chart,
        label: 'Graph',
        path: '/graph'),
    _NavItem(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'Profile',
        path: '/profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selected = _selectedIndex(location);
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          if (isWide)
            NavigationRail(
              backgroundColor: bgColor,
              selectedIndex: _railIndex(selected),
              onDestinationSelected: (i) => _navigateRail(context, i),
              labelType: NavigationRailLabelType.selected,
              indicatorColor: AppTheme.accentGreen.withValues(alpha: 0.12),
              selectedIconTheme:
                  const IconThemeData(color: AppTheme.accentGreen),
              selectedLabelTextStyle: const TextStyle(
                color: AppTheme.accentGreen,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              unselectedIconTheme: IconThemeData(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.4),
              ),
              unselectedLabelTextStyle: TextStyle(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.4),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppTheme.gradientPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.eco, color: Colors.white, size: 22),
                ),
              ),
              destinations: [
                ..._destinations.map((d) => NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.selectedIcon),
                      label: Text(d.label),
                    )),
                // Scan as a rail destination (index 4 in the rail)
                const NavigationRailDestination(
                  icon: Icon(Icons.qr_code_scanner_outlined),
                  selectedIcon: Icon(Icons.qr_code_scanner),
                  label: Text('Scan'),
                ),
              ],
            ),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar:
          isWide ? null : _buildBottomNav(context, selected, isDark, bgColor),
    );
  }

  Widget _buildBottomNav(
      BuildContext context, int selected, bool isDark, Color bgColor) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Regular nav items — visual order: Home, Inventory, [gap], Graph, Profile
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navButton(context, 0, selected, _destinations[0]), // Home
              _navButton(context, 1, selected, _destinations[1]), // Inventory
              const SizedBox(width: 64), // space for center scan button
              _navButton(context, 3, selected, _destinations[2]), // Graph
              _navButton(context, 4, selected, _destinations[3]), // Profile
            ],
          ),

          // Center elevated scan button
          Positioned(
            top: -18,
            child: GestureDetector(
              onTap: () => context.go('/scan'),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.gradientPrimary,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentGreen.withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.qr_code_scanner,
                    color: Colors.white, size: 26),
              ),
            ),
          ),

          // Scan label below the elevated button
          Positioned(
            bottom: 8,
            child: Text(
              'Scan',
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected == 2 ? FontWeight.w700 : FontWeight.w500,
                color: selected == 2
                    ? AppTheme.accentGreen
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.4)
                        : Colors.black.withValues(alpha: 0.4)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton(
      BuildContext context, int index, int selected, _NavItem item) {
    final isSelected = selected == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.go(item.path),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? item.selectedIcon : item.icon,
              size: 24,
              color: isSelected
                  ? AppTheme.accentGreen
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.4)
                      : Colors.black.withValues(alpha: 0.4)),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppTheme.accentGreen
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.4)
                        : Colors.black.withValues(alpha: 0.4)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns the visual tab index for the given route.
  /// 0=Home, 1=Inventory, 2=Scan, 3=Graph, 4=Profile
  int _selectedIndex(String location) {
    if (location == '/') return 0;
    if (location == '/inventory') return 1;
    if (location == '/scan') return 2;
    if (location == '/graph') return 3;
    if (location == '/profile') return 4;
    if (location == '/settings') return 4; // show profile as selected
    if (location == '/about') return 4;
    return 0;
  }

  /// Converts the visual `_selectedIndex` to a NavigationRail index.
  /// Rail order: Home(0), Inventory(1), Graph(2), Profile(3), Scan(4)
  /// Visual order: Home(0), Inventory(1), Scan(2), Graph(3), Profile(4)
  int _railIndex(int visualIndex) {
    return switch (visualIndex) {
      0 => 0, // Home
      1 => 1, // Inventory
      2 => 4, // Scan → last rail item
      3 => 2, // Graph
      4 => 3, // Profile
      _ => 0,
    };
  }

  /// Converts a NavigationRail tap index to a path and navigates.
  /// Rail order: Home(0), Inventory(1), Graph(2), Profile(3), Scan(4)
  void _navigateRail(BuildContext context, int railIndex) {
    final path = switch (railIndex) {
      0 => '/',
      1 => '/inventory',
      2 => '/graph',
      3 => '/profile',
      4 => '/scan',
      _ => '/',
    };
    context.go(path);
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String path;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.path,
  });
}
