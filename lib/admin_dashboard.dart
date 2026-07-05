import 'package:flutter/material.dart';
import 'order.dart';

class AppEmployee {
  final String name;
  final String role;
  final String email;
  final bool isActive;
  final List<String> permissions;

  const AppEmployee({
    required this.name,
    required this.role,
    required this.email,
    this.isActive = true,
    this.permissions = const [],
  });
}

const List<Map<String, dynamic>> _roleData = [
  {
    'role': 'super_admin',
    'label': 'Super Admin',
    'color': Color(0xFF7C3AED),
    'permissions': ['POS', 'Orders', 'Menu', 'Employees', 'Reports', 'Settings'],
  },
  {
    'role': 'admin',
    'label': 'Admin',
    'color': Color(0xFF3B82F6),
    'permissions': ['POS', 'Orders', 'Menu', 'Reports'],
  },
  {
    'role': 'manager',
    'label': 'Manager',
    'color': Color(0xFFF59E0B),
    'permissions': ['POS', 'Orders', 'Reports'],
  },
  {
    'role': 'cashier',
    'label': 'Cashier',
    'color': Color(0xFF10B981),
    'permissions': ['POS', 'Orders'],
  },
  {
    'role': 'barista',
    'label': 'Barista',
    'color': Color(0xFF6366F1),
    'permissions': ['Orders'],
  },
];

const List<AppEmployee> _sampleEmployees = [
  AppEmployee(
    name: 'Juan Dela Cruz',
    role: 'super_admin',
    email: 'juan@coffeeshop101.com',
    isActive: true,
  ),
  AppEmployee(
    name: 'Maria Santos',
    role: 'admin',
    email: 'maria@coffeeshop101.com',
    isActive: true,
  ),
  AppEmployee(
    name: 'Pedro Reyes',
    role: 'manager',
    email: 'pedro@coffeeshop101.com',
    isActive: true,
  ),
  AppEmployee(
    name: 'Ana Gonzales',
    role: 'cashier',
    email: 'ana@coffeeshop101.com',
    isActive: true,
  ),
  AppEmployee(
    name: 'Jose Garcia',
    role: 'cashier',
    email: 'jose@coffeeshop101.com',
    isActive: false,
  ),
  AppEmployee(
    name: 'Luisa Fernandez',
    role: 'barista',
    email: 'luisa@coffeeshop101.com',
    isActive: true,
  ),
  AppEmployee(
    name: 'Carlos Mendoza',
    role: 'barista',
    email: 'carlos@coffeeshop101.com',
    isActive: true,
  ),
];

class AdminDashboard extends StatefulWidget {
  final List<Order> orders;
  final ValueChanged<int> onAdvanceStatus;
  final VoidCallback onExitAdmin;

  const AdminDashboard({
    super.key,
    required this.orders,
    required this.onAdvanceStatus,
    required this.onExitAdmin,
  });

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedNav = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgMain = isDark ? const Color(0xFF0F1115) : const Color(0xFFF8FAFC);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: bgMain,
      body: Row(
        children: [
          Container(
            width: 220,
            color: bgSurface,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/CoffeeShop101.png',
                        width: 48,
                        height: 48,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ADMIN',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 3,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: Column(
                    children: [
                      _navItem(0, Icons.point_of_sale, 'POS', Icons.shopping_cart_outlined),
                      _navItem(1, Icons.people_outline, 'Employees', Icons.badge_outlined),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Material(
                  color: Colors.transparent,
                  child: ListTile(
                    dense: true,
                    leading: Icon(Icons.arrow_back, size: 18, color: textMuted),
                    title: Text(
                      'Back to Menu',
                      style: TextStyle(fontSize: 12, color: textMuted),
                    ),
                    onTap: widget.onExitAdmin,
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(width: 1, color: borderColor),
          Expanded(
            child: _selectedNav == 0 ? _buildPOSSection() : _buildEmployeesSection(),
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label, IconData activeIcon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final isSelected = _selectedNav == index;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        dense: true,
        tileColor: isSelected
            ? primaryColor.withValues(alpha: 0.1)
            : Colors.transparent,
        leading: Icon(
          isSelected ? activeIcon : icon,
          size: 18,
          color: isSelected ? primaryColor : textMuted,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? primaryColor : textMuted,
          ),
        ),
        onTap: () => setState(() => _selectedNav = index),
      ),
    );
  }

  Widget _buildPOSSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    final pending = widget.orders.where((o) => o.status == 'pending').length;
    final preparing = widget.orders.where((o) => o.status == 'preparing').length;
    final ready = widget.orders.where((o) => o.status == 'ready').length;
    final todayTotal = widget.orders.fold<double>(
      0, (sum, o) => sum + o.total,
    );

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'POINT OF SALE',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: textColor,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _statCard('Pending', '$pending', Colors.orange, bgSurface, borderColor),
              const SizedBox(width: 16),
              _statCard('Preparing', '$preparing', Colors.blue, bgSurface, borderColor),
              const SizedBox(width: 16),
              _statCard('Ready', '$ready', Colors.green, bgSurface, borderColor),
              const SizedBox(width: 16),
              _statCard(
                'Today\'s Sales',
                'Php ${todayTotal.toStringAsFixed(0)}',
                primaryColor,
                bgSurface,
                borderColor,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: AdminPanel(
              orders: widget.orders,
              onAdvanceStatus: widget.onAdvanceStatus,
              onExitAdmin: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color color, Color bgSurface, Color borderColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: textMuted, letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeesSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EMPLOYEES',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: textColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_sampleEmployees.length} total',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Role-Based Access Control (RBAC)',
            style: TextStyle(fontSize: 12, color: textMuted, letterSpacing: 0.5),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: _sampleEmployees.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final employee = _sampleEmployees[index];
                final roleInfo = _roleData.firstWhere(
                  (r) => r['role'] == employee.role,
                  orElse: () => _roleData[0],
                );
                final roleColor = roleInfo['color'] as Color;
                final roleLabel = roleInfo['label'] as String;
                final perms = roleInfo['permissions'] as List<String>;

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: bgSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: roleColor.withValues(alpha: 0.15),
                            child: Text(
                              employee.name.split(' ').map((n) => n[0]).take(2).join(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: roleColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      employee.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: roleColor.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        roleLabel,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: roleColor,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    if (!employee.isActive)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'INACTIVE',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.redAccent,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  employee.email,
                                  style: TextStyle(fontSize: 12, color: textMuted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'ACCESS PERMISSIONS',
                        style: TextStyle(
                          fontSize: 10,
                          color: textMuted,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['POS', 'Orders', 'Menu', 'Reports', 'Employees', 'Settings']
                            .map((perm) {
                          final hasAccess = perms.contains(perm);
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: hasAccess
                                  ? roleColor.withValues(alpha: 0.12)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: hasAccess
                                    ? roleColor.withValues(alpha: 0.3)
                                    : borderColor,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  hasAccess ? Icons.check_circle : Icons.remove_circle_outline,
                                  size: 12,
                                  color: hasAccess ? roleColor : textMuted,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  perm,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: hasAccess ? roleColor : textMuted,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
