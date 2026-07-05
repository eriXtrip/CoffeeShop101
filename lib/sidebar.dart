import 'package:flutter/material.dart';
import 'main.dart';
import 'login.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;
  final bool isSidebarLeft;
  final ValueChanged<bool> onSidebarLeftChanged;
  final bool isDark;
  final VoidCallback toggleTheme;
  final bool isAdmin;
  final ValueChanged<bool> onAdminChanged;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onCategorySelected,
    required this.isSidebarLeft,
    required this.onSidebarLeftChanged,
    required this.isDark,
    required this.toggleTheme,
    this.isAdmin = false,
    required this.onAdminChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Resolve color states elegantly
    final bgSidebar = isDark
        ? AppColors.bgSurfaceDark
        : AppColors.bgSurfaceLight;
    final colorTextMain = isDark
        ? AppColors.textMainDark
        : AppColors.textMainLight;
    final colorTextMuted = isDark
        ? AppColors.textMutedDark
        : AppColors.textMutedLight;
    final colorPrimary = isDark
        ? AppColors.primaryDark
        : AppColors.primaryLight;

    return Container(
      width: 260,
      color: bgSidebar,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Keeps nav items left-aligned
        children: [
          // Minimalist Header (Centered Logo + Text)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/CoffeeShop101.png',
                  width: 78,
                  height: 78,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),
                Text(
                  'COFFEE SHOP 101',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3.0,
                    color: colorTextMain,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),

          // Navigation Section (Scrollable for large sets)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(AppMenuData.categories.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < AppMenuData.categories.length - 1
                          ? 16.0
                          : 0.0,
                    ),
                    child: _buildMinimalNavItem(
                      label: (AppMenuData.categories[index]['name'] as String).toUpperCase(),
                      isSelected: selectedIndex == index,
                      activeColor: colorPrimary,
                      inactiveColor: colorTextMuted,
                      onTap: () => onCategorySelected(index),
                    ),
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // System Utility Controls
          _buildMinimalToggle(
            label: 'sidebar left',
            value: isSidebarLeft,
            onChanged: onSidebarLeftChanged,
            activeColor: colorPrimary,
            textColor: colorTextMuted,
          ),
          _buildMinimalToggle(
            label: 'dark theme',
            value: isDark,
            onChanged: (val) => toggleTheme(),
            activeColor: colorPrimary,
            textColor: colorTextMuted,
          ),
          _buildMinimalToggle(
            label: 'admin mode',
            value: isAdmin,
            onChanged: onAdminChanged,
            activeColor: Colors.amber,
            textColor: colorTextMuted,
          ),
          const SizedBox(height: 32),

          // Action State Button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: colorTextMain,
                foregroundColor: bgSidebar,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text(
                'login',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Purely text-driven navigation layout helper
  Widget _buildMinimalNavItem({
    required String label,
    required bool isSelected,
    required Color activeColor,
    required Color inactiveColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? activeColor : Colors.transparent,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Scaled down, low-noise toggle layout
  Widget _buildMinimalToggle({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color activeColor,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
          Transform.scale(
            scale:
                0.7, // Shrinking down standard bulky switches handles minimal balance nicely
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: activeColor,
              activeTrackColor: activeColor.withValues(alpha: 0.2),
              inactiveThumbColor: textColor.withValues(alpha: 0.6),
              inactiveTrackColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
