import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'cart.dart';
import 'item_card.dart';
import 'main.dart';
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

const List<Map<String, dynamic>> _defaultRoles = [
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

const List<String> _allPermissions = [
  'POS', 'Orders', 'Menu', 'Reports', 'Employees', 'Settings',
];

const List<Map<String, dynamic>> _defaultMenuCategories = [
  {'id': 1, 'name': 'coffee'},
  {'id': 2, 'name': 'non-coffee'},
  {'id': 3, 'name': 'pastries'},
];

const List<Map<String, dynamic>> _defaultGlobalAddOns = [
  {'id': 1, 'name': 'Espresso Shot', 'price': 30.0, 'isAvailable': true},
  {'id': 2, 'name': 'Oat Milk Substitute', 'price': 40.0, 'isAvailable': true},
  {'id': 3, 'name': 'Caramel Drizzle', 'price': 15.0, 'isAvailable': true},
  {'id': 4, 'name': 'Vanilla Syrup', 'price': 15.0, 'isAvailable': true},
  {'id': 5, 'name': 'Sea Salt Cream', 'price': 20.0, 'isAvailable': true},
];

const List<Map<String, dynamic>> _defaultMenuItems = [
  {
    'id': 1,
    'category_id': 1,
    'name': 'Spanish Latte',
    'label': 'BEST SELLER',
    'description': 'Signature espresso with sweet condensed milk.',
    'isAvailable': true,
    'imageUrl': '',
    'sizes': [
      {'name': '16oz', 'price': 55.0},
      {'name': '22oz', 'price': 95.0},
    ],
    'addOnIds': [1, 2, 3, 4, 5],
  },
  {
    'id': 2,
    'category_id': 1,
    'name': 'Iced Americano',
    'label': '',
    'description': 'Rich espresso shots topped with cold water and ice.',
    'isAvailable': true,
    'imageUrl': '',
    'sizes': [
      {'name': '16oz', 'price': 55.0},
      {'name': '22oz', 'price': 95.0},
    ],
    'addOnIds': [1, 4],
  },
  {
    'id': 3,
    'category_id': 2,
    'name': 'Matcha Latte',
    'label': 'NEW',
    'description': 'Pure Japanese Uji matcha whisked with creamy milk.',
    'isAvailable': true,
    'imageUrl': '',
    'sizes': [
      {'name': '16oz', 'price': 55.0},
      {'name': '22oz', 'price': 95.0},
    ],
    'addOnIds': [2, 4],
  },
  {
    'id': 4,
    'category_id': 3,
    'name': 'Butter Croissant',
    'label': '',
    'description': 'Flaky, golden, and layered with premium French butter.',
    'isAvailable': true,
    'imageUrl': '',
    'sizes': [
      {'name': 'One Size', 'price': 110.0},
    ],
    'addOnIds': [],
  },
];

const List<AppEmployee> _defaultEmployees = [
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

final List<Order> _dummyOrders = [
  Order(
    customerName: 'John Smith',
    paymentMethod: 'gcash',
    status: 'pending',
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    items: [
      CartItem(
        itemName: 'Spanish Latte',
        sizeName: '22oz',
        sizePrice: 95.00,
        addOnNames: ['Caramel Drizzle', 'Vanilla Syrup'],
        addOnsPrice: 30.00,
        quantity: 2,
      ),
      CartItem(
        itemName: 'Butter Croissant',
        sizeName: 'One Size',
        sizePrice: 110.00,
        addOnNames: [],
        addOnsPrice: 0,
        quantity: 1,
      ),
    ],
  ),
  Order(
    customerName: 'Emily Davis',
    paymentMethod: 'cash',
    status: 'pending',
    timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
    items: [
      CartItem(
        itemName: 'Iced Americano',
        sizeName: '16oz',
        sizePrice: 55.00,
        addOnNames: ['Espresso Shot'],
        addOnsPrice: 30.00,
        quantity: 1,
      ),
    ],
  ),
  Order(
    customerName: 'Michael Brown',
    paymentMethod: 'gcash',
    status: 'preparing',
    timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
    items: [
      CartItem(
        itemName: 'Matcha Latte',
        sizeName: '22oz',
        sizePrice: 95.00,
        addOnNames: ['Oat Milk Substitute'],
        addOnsPrice: 40.00,
        quantity: 1,
      ),
      CartItem(
        itemName: 'Spanish Latte',
        sizeName: '16oz',
        sizePrice: 55.00,
        addOnNames: ['Sea Salt Cream'],
        addOnsPrice: 20.00,
        quantity: 1,
      ),
    ],
  ),
  Order(
    customerName: 'Sarah Wilson',
    paymentMethod: 'cash',
    status: 'preparing',
    timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    items: [
      CartItem(
        itemName: 'Butter Croissant',
        sizeName: 'One Size',
        sizePrice: 110.00,
        addOnNames: [],
        addOnsPrice: 0,
        quantity: 3,
      ),
    ],
  ),
  Order(
    customerName: 'David Garcia',
    paymentMethod: 'gcash',
    status: 'ready',
    timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
    items: [
      CartItem(
        itemName: 'Spanish Latte',
        sizeName: '16oz',
        sizePrice: 55.00,
        addOnNames: ['Caramel Drizzle'],
        addOnsPrice: 15.00,
        quantity: 1,
      ),
    ],
  ),
  Order(
    customerName: 'Jessica Lee',
    paymentMethod: 'cash',
    status: 'done',
    timestamp: DateTime.now().subtract(const Duration(minutes: 60)),
    items: [
      CartItem(
        itemName: 'Iced Americano',
        sizeName: '22oz',
        sizePrice: 95.00,
        addOnNames: ['Vanilla Syrup'],
        addOnsPrice: 15.00,
        quantity: 1,
      ),
      CartItem(
        itemName: 'Matcha Latte',
        sizeName: '16oz',
        sizePrice: 55.00,
        addOnNames: [],
        addOnsPrice: 0,
        quantity: 1,
      ),
    ],
  ),
];

class AdminDashboard extends StatefulWidget {
  final List<Order> orders;
  final ValueChanged<int> onAdvanceStatus;
  final VoidCallback onExitAdmin;
  final ValueChanged<Order> onPlaceOrder;

  const AdminDashboard({
    super.key,
    required this.orders,
    required this.onAdvanceStatus,
    required this.onExitAdmin,
    required this.onPlaceOrder,
  });

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedNav = 0;
  int _nextItemId = 5;
  int _nextAddOnId = 6;
  int _selectedCat = 0;
  final List<CartItem> _cartItems = [];
  Uint8List? _qrImageData;

  late List<Map<String, dynamic>> _menuItems;
  late List<Map<String, dynamic>> _menuCategories;
  late List<Map<String, dynamic>> _globalAddOns;
  late List<Map<String, dynamic>> _roles;
  late List<AppEmployee> _employees;

  @override
  void initState() {
    super.initState();
    _menuItems = _defaultMenuItems.map((e) => Map<String, dynamic>.from(e)).toList();
    _menuCategories = _defaultMenuCategories.map((e) => Map<String, dynamic>.from(e)).toList();
    _globalAddOns = _defaultGlobalAddOns.map((e) => Map<String, dynamic>.from(e)).toList();
    _roles = _defaultRoles.map((e) => Map<String, dynamic>.from(e)).toList();
    _employees = List.from(_defaultEmployees);
    for (final item in _menuItems) {
      item['sizes'] = (item['sizes'] as List).map((s) => Map<String, dynamic>.from(s)).toList();
      item['addOnIds'] = (item['addOnIds'] as List).map((a) => a).toList();
    }
  }

  List<Order> get _orders =>
      widget.orders.isNotEmpty ? widget.orders : _dummyOrders;

  bool _isWidescreen(double w) => w >= 900;
  bool _isTablet(double w) => w >= 600 && w < 900;
  bool _isPhone(double w) => w < 600;

  String _navTitle() {
    switch (_selectedNav) {
      case 0: return 'POS';
      case 1: return 'ORDER';
      case 2: return 'MENU';
      case 3: return 'ADD-ONS';
      case 4: return 'EMPLOYEES';
      case 5: return 'REPORTS';
      default: return '';
    }
  }

  Widget _navBody() {
    switch (_selectedNav) {
      case 0: return _buildPhonePOSSection();
      case 1: return _buildPhoneMenuOrderingSection();
      case 2: return _buildMenuSection();
      case 3: return _buildAddOnsSection();
      case 4: return _buildEmployeesSection();
      case 5: return _buildReportsSection();
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildSectionForNav(int nav) {
    switch (nav) {
      case 0: return _buildPOSSection();
      case 1: return _buildMenuOrderingSection();
      case 2: return _buildMenuSection();
      case 3: return _buildAddOnsSection();
      case 4: return _buildEmployeesSection();
      case 5: return _buildReportsSection();
      default: return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgMain = isDark ? const Color(0xFF0F1115) : const Color(0xFFF8FAFC);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    final screenWidth = MediaQuery.of(context).size.width;

    if (_isPhone(screenWidth)) {
      return Scaffold(
        backgroundColor: bgMain,
        appBar: AppBar(
          backgroundColor: bgSurface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.logout, color: textMuted),
            onPressed: widget.onExitAdmin,
          ),
          title: Text(
            _navTitle(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              color: textColor,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.qr_code_scanner, color: textMuted),
              onPressed: _showQrDialog,
            ),
            IconButton(
              icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: textMuted),
              onPressed: () => context.findAncestorStateOfType<MyAppState>()?.toggleTheme(),
            ),
          ],
        ),
        body: _navBody(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: borderColor)),
          ),
          child: BottomNavigationBar(
            backgroundColor: bgSurface,
            selectedItemColor: textColor,
            unselectedItemColor: textMuted,
            currentIndex: _selectedNav,
            onTap: (i) => setState(() => _selectedNav = i),
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.point_of_sale_outlined, size: 20),
                activeIcon: Icon(Icons.point_of_sale, size: 20),
                label: 'POS',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined, size: 20),
                activeIcon: Icon(Icons.receipt_long, size: 20),
                label: 'Order',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu_outlined, size: 20),
                activeIcon: Icon(Icons.restaurant_menu, size: 20),
                label: 'Menu',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.extension_outlined, size: 20),
                activeIcon: Icon(Icons.extension, size: 20),
                label: 'Add-ons',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline, size: 20),
                activeIcon: Icon(Icons.people, size: 20),
                label: 'Employees',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assessment_outlined, size: 20),
                activeIcon: Icon(Icons.assessment, size: 20),
                label: 'Reports',
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgMain,
      body: Row(
        children: [
          Container(
            width: _isWidescreen(screenWidth) ? 220 : 72,
            color: bgSurface,
            child: Column(
              children: [
                if (_isWidescreen(screenWidth))
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
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Image.asset(
                      'assets/CoffeeShop101.png',
                      width: 36,
                      height: 36,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                const Divider(height: 1),
                Expanded(
                  child: Column(
                    children: [
                      if (_isWidescreen(screenWidth)) ...[
                        _navItem(0, Icons.point_of_sale, 'POS', Icons.point_of_sale),
                        _navItem(1, Icons.receipt_long_outlined, 'Order', Icons.receipt_long),
                        _navItem(2, Icons.restaurant_menu, 'Menu', Icons.menu_book),
                        _navItem(3, Icons.extension, 'Add-ons', Icons.extension_outlined),
                        _navItem(4, Icons.people_outline, 'Employees', Icons.badge_outlined),
                        _navItem(5, Icons.assessment, 'Reports', Icons.assessment_outlined),
                      ] else ...[
                        _compactNavItem(0, Icons.point_of_sale, 'POS'),
                        _compactNavItem(1, Icons.receipt_long, 'Order'),
                        _compactNavItem(2, Icons.restaurant_menu, 'Menu'),
                        _compactNavItem(3, Icons.extension, 'Add-ons'),
                        _compactNavItem(4, Icons.people_outline, 'Employees'),
                        _compactNavItem(5, Icons.assessment, 'Reports'),
                      ],
                    ],
                  ),
                ),
                const Divider(height: 1),
                if (_isWidescreen(screenWidth))
                  Material(
                    color: Colors.transparent,
                      child: ListTile(
                        dense: true,
                        leading: Icon(Icons.logout, size: 18, color: textMuted),
                        title: Text(
                          'Logout',
                          style: TextStyle(fontSize: 12, color: textMuted),
                        ),
                      onTap: widget.onExitAdmin,
                    ),
                  )
                else
                  IconButton(
                    icon: Icon(Icons.logout, size: 20, color: textMuted),
                    onPressed: widget.onExitAdmin,
                  ),
                if (_isWidescreen(screenWidth))
                  Material(
                    color: Colors.transparent,
                    child: ListTile(
                      dense: true,
                      leading: Icon(Icons.qr_code_scanner, size: 18, color: textMuted),
                      title: Text('QR Code', style: TextStyle(fontSize: 12, color: textMuted)),
                      trailing: _qrImageData != null
                          ? Icon(Icons.check_circle, size: 16, color: Colors.green)
                          : null,
                      onTap: _showQrDialog,
                    ),
                  )
                else
                  IconButton(
                    icon: Icon(Icons.qr_code_scanner, size: 20,
                        color: _qrImageData != null ? Colors.green : textMuted),
                    onPressed: _showQrDialog,
                  ),
                if (_isWidescreen(screenWidth))
                  Material(
                    color: Colors.transparent,
                    child: SwitchListTile(
                      dense: true,
                      secondary: Icon(
                        Theme.of(context).brightness == Brightness.dark ? Icons.dark_mode : Icons.light_mode,
                        size: 18, color: textMuted,
                      ),
                      title: Text(
                        Theme.of(context).brightness == Brightness.dark ? 'Dark' : 'Light',
                        style: TextStyle(fontSize: 12, color: textMuted),
                      ),
                      value: Theme.of(context).brightness == Brightness.dark,
                      onChanged: (_) => context.findAncestorStateOfType<MyAppState>()?.toggleTheme(),
                      activeTrackColor: Colors.green.withValues(alpha: 0.2),
                      activeThumbColor: Colors.green,
                    ),
                  )
                else
                  IconButton(
                    icon: Icon(
                      Theme.of(context).brightness == Brightness.dark ? Icons.dark_mode : Icons.light_mode,
                      size: 20, color: textMuted,
                    ),
                    onPressed: () => context.findAncestorStateOfType<MyAppState>()?.toggleTheme(),
                  ),
              ],
            ),
          ),
          Visibility(
            visible: _isWidescreen(screenWidth),
            child: VerticalDivider(width: 1, color: borderColor),
          ),
          Expanded(
            child: _buildSectionForNav(_selectedNav),
          ),
        ],
      ),
    );
  }

  Widget _compactNavItem(int index, IconData icon, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final isSelected = _selectedNav == index;

    return Tooltip(
      message: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _selectedNav = index),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: isSelected ? primaryColor : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Icon(
              isSelected ? icon : icon,
              size: 22,
              color: isSelected ? primaryColor : textMuted,
            ),
          ),
        ),
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

    final screenWidth = MediaQuery.of(context).size.width;
    final padding = _isPhone(screenWidth) ? 12.0 : (_isTablet(screenWidth) ? 16.0 : 20.0);
    final gap = _isPhone(screenWidth) ? 8.0 : 12.0;
    final titleSize = _isPhone(screenWidth) ? 16.0 : 20.0;

    final displayOrders = _orders.where((o) => o.status != 'done').toList();
    final pending = displayOrders.where((o) => o.status == 'pending').length;
    final preparing = displayOrders.where((o) => o.status == 'preparing').length;
    final ready = displayOrders.where((o) => o.status == 'ready').length;
    final totalOrders = displayOrders.length;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('POINT OF SALE', style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w700, letterSpacing: 2, color: textColor)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                child: Text('$totalOrders orders', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: primaryColor)),
              ),
            ],
          ),
          SizedBox(height: gap),
          LayoutBuilder(builder: (context, constraints) {
            final cols = _isPhone(screenWidth) ? 2 : 4;
            final cardWidth = (constraints.maxWidth - (gap * (cols - 1))) / cols;
            return SizedBox(width: constraints.maxWidth, child: Wrap(spacing: gap, runSpacing: gap, children: [
              _statCard('Pending', '$pending', Colors.orange, bgSurface, borderColor, width: cardWidth),
              _statCard('Preparing', '$preparing', Colors.blue, bgSurface, borderColor, width: cardWidth),
              _statCard('Ready', '$ready', Colors.green, bgSurface, borderColor, width: cardWidth),
              _statCard('Total Orders', '$totalOrders', primaryColor, bgSurface, borderColor, width: cardWidth),
            ]));
          }),
          SizedBox(height: gap),
          Expanded(child: Row(children: [
            Expanded(flex: 2, child: _buildOrderQueue(displayOrders)),
            SizedBox(width: gap),
            Expanded(flex: 1, child: _buildReadyQueue(displayOrders)),
          ])),
        ],
      ),
    );
  }

  Widget _buildPhonePOSSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    final displayOrders = _orders.where((o) => o.status != 'done').toList();
    final pending = displayOrders.where((o) => o.status == 'pending').length;
    final preparing = displayOrders.where((o) => o.status == 'preparing').length;
    final ready = displayOrders.where((o) => o.status == 'ready').length;
    final totalOrders = displayOrders.length;

    final sortedOrders = [
      ...displayOrders.where((o) => o.status == 'ready'),
      ...displayOrders.where((o) => o.status == 'preparing'),
      ...displayOrders.where((o) => o.status == 'pending'),
    ];

    final statusColors = {'pending': Colors.orange, 'preparing': Colors.blue, 'ready': Colors.green, 'done': textMuted};

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        SizedBox(height: 72, child: Row(children: [
          _miniStat('Pending', '$pending', Colors.orange), const SizedBox(width: 8),
          _miniStat('Preparing', '$preparing', Colors.blue), const SizedBox(width: 8),
          _miniStat('Ready', '$ready', Colors.green), const SizedBox(width: 8),
          _miniStat('Total', '$totalOrders', primaryColor),
        ])),
        const SizedBox(height: 8),
        Expanded(child: sortedOrders.isEmpty
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.receipt_long_outlined, size: 36, color: textMuted),
              const SizedBox(height: 8),
              Text('No orders yet', style: TextStyle(color: textMuted, fontSize: 13)),
            ]))
          : ListView.separated(
              itemCount: sortedOrders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final order = sortedOrders[index];
                final realIndex = displayOrders.indexOf(order);
                final statusColor = statusColors[order.status] ?? textMuted;
                final isReady = order.status == 'ready';
                final card = Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bgSurface, borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isReady ? Colors.green.withValues(alpha: 0.4) : borderColor, width: isReady ? 1.5 : 1),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(order.customerName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textColor), overflow: TextOverflow.ellipsis)),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                        child: Text(order.statusLabel, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: statusColor, letterSpacing: 1))),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      Text(order.paymentMethod.toUpperCase(), style: TextStyle(fontSize: 9, color: textMuted, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text('Php ${order.total.toStringAsFixed(2)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primaryColor)),
                    ]),
                    const SizedBox(height: 4),
                    ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Text('${item.quantity}x ${item.itemName} (${item.sizeName})', style: TextStyle(fontSize: 12, color: textColor)),
                    )),
                    if (order.note.isNotEmpty) Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(order.note, style: TextStyle(fontSize: 11, color: textMuted, fontStyle: FontStyle.italic)),
                    ),
                    if (order.status != 'done')
                      Align(alignment: Alignment.centerRight, child: TextButton(
                        onPressed: () { if (realIndex >= 0) widget.onAdvanceStatus(realIndex); },
                        style: TextButton.styleFrom(backgroundColor: primaryColor.withValues(alpha: 0.1),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                        child: Text(_nextLabel(order.status), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: primaryColor)),
                      )),
                  ]),
                );
                return isReady ? _GlowingContainer(child: card) : card;
              },
            )),
      ]),
    );
  }

  Widget _buildOrderQueue(List<Order> orders) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    final screenWidth = MediaQuery.of(context).size.width;
    final innerPad = _isPhone(screenWidth) ? 10.0 : 14.0;
    final itemGap = _isPhone(screenWidth) ? 6.0 : 8.0;

    final statusColors = {
      'pending': Colors.orange,
      'preparing': Colors.blue,
      'ready': Colors.green,
      'done': textMuted,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ORDER QUEUE',
          style: TextStyle(
            fontSize: _isPhone(screenWidth) ? 14 : 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: textColor,
          ),
        ),
        SizedBox(height: itemGap),
        Expanded(
          child: orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.receipt_long_outlined, size: 28, color: textMuted),
                      const SizedBox(height: 6),
                      Text('No orders', style: TextStyle(color: textMuted, fontSize: 12)),
                    ],
                  ),
                )
              : ListView.separated(
                  itemCount: orders.length,
                  separatorBuilder: (_, _) => SizedBox(height: itemGap),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final statusColor = statusColors[order.status] ?? textMuted;

                    return Container(
                      padding: EdgeInsets.all(innerPad),
                      decoration: BoxDecoration(
                        color: bgSurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  order.customerName,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  order.statusLabel,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                order.paymentMethod.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 9,
                                  color: textMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Php ${order.total.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ...order.items.map((item) => Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Text(
                              '${item.quantity}x ${item.itemName} (${item.sizeName})',
                              style: TextStyle(fontSize: 11, color: textColor),
                            ),
                          )),
                          if (order.note.isNotEmpty) Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(order.note, style: TextStyle(fontSize: 11, color: textMuted, fontStyle: FontStyle.italic)),
                          ),
                          if (order.status != 'done')
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => widget.onAdvanceStatus(index),
                                style: TextButton.styleFrom(
                                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  _nextLabel(order.status),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildReadyQueue(List<Order> orders) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final screenWidth = MediaQuery.of(context).size.width;
    final innerPad = _isPhone(screenWidth) ? 10.0 : 14.0;
    final itemGap = _isPhone(screenWidth) ? 6.0 : 8.0;

    final readyOrders = orders.where((o) => o.status == 'ready').toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('READY', style: TextStyle(fontSize: _isPhone(screenWidth) ? 14 : 16, fontWeight: FontWeight.w700, letterSpacing: 2, color: textColor)),
        if (readyOrders.isNotEmpty) ...[const SizedBox(width: 6), Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green))],
      ]),
      SizedBox(height: itemGap),
      Expanded(child: readyOrders.isEmpty
        ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.check_circle_outline, size: 28, color: textMuted), const SizedBox(height: 6),
            Text('None ready', style: TextStyle(color: textMuted, fontSize: 12)),
          ]))
        : ListView.separated(
            itemCount: readyOrders.length,
            separatorBuilder: (_, _) => SizedBox(height: itemGap),
            itemBuilder: (context, index) {
              final order = readyOrders[index];
              return _GlowingContainer(child: Container(
                padding: EdgeInsets.all(innerPad),
                decoration: BoxDecoration(color: bgSurface, borderRadius: BorderRadius.circular(10)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Flexible(child: Text(order.customerName, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textColor), overflow: TextOverflow.ellipsis)),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                      child: Text(order.statusLabel, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green, letterSpacing: 1))),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    Text(order.paymentMethod.toUpperCase(), style: TextStyle(fontSize: 9, color: textMuted, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Text('Php ${order.total.toStringAsFixed(2)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor)),
                  ]),
                  const SizedBox(height: 4),
                  ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text('${item.quantity}x ${item.itemName} (${item.sizeName})', style: TextStyle(fontSize: 11, color: textColor)),
                  )),
                  if (order.note.isNotEmpty) Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(order.note, style: TextStyle(fontSize: 11, color: textMuted, fontStyle: FontStyle.italic)),
                  ),
                  Align(alignment: Alignment.centerRight, child: TextButton(
                    onPressed: () { final ri = orders.indexOf(order); if (ri >= 0) widget.onAdvanceStatus(ri); },
                    style: TextButton.styleFrom(backgroundColor: Colors.green.withValues(alpha: 0.15),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                    child: Text('Mark Done', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.green)),
                  )),
                ]),
              ));
            },
          )),
    ]);
  }

  Widget _miniStat(String label, String value, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(color: bgSurface, borderRadius: BorderRadius.circular(8), border: Border.all(color: borderColor)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 9, color: textMuted, letterSpacing: 0.3), textAlign: TextAlign.center),
      ]),
    ));
  }

  Widget _statCard(String label, String value, Color color, Color bgSurface, Color borderColor, {double? width}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final screenWidth = MediaQuery.of(context).size.width;
    final valueSize = _isPhone(screenWidth) ? 20.0 : (_isTablet(screenWidth) ? 22.0 : 24.0);
    final innerPad = _isPhone(screenWidth) ? 10.0 : 14.0;
    return Container(
      width: width, padding: EdgeInsets.all(innerPad),
      decoration: BoxDecoration(color: bgSurface, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 11, color: textMuted, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: valueSize, fontWeight: FontWeight.bold, color: color)),
      ]),
    );
  }

  String _nextLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Mark Preparing';
      case 'preparing':
        return 'Mark Ready';
      case 'ready':
        return 'Mark Done';
      default:
        return '';
    }
  }

  void _showQrDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: bgSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('GCash QR Code', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textColor)),
              const SizedBox(height: 16),
              if (_qrImageData != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(_qrImageData!, height: 200, fit: BoxFit.contain),
                )
              else
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: bgSurface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                  ),
                  child: Center(
                    child: Text('No QR uploaded', style: TextStyle(color: textMuted)),
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.file_upload_outlined, size: 18),
                  label: Text(_qrImageData != null ? 'Replace QR' : 'Upload QR'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: isDark ? const Color(0xFF0F1115) : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    try {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                        withData: true,
                      );
                      if (result != null && result.files.single.bytes != null) {
                        setState(() => _qrImageData = result.files.single.bytes);
                        if (ctx.mounted) Navigator.of(ctx).pop();
                      }
                    } catch (_) {}
                  },
                ),
              ),
              if (_qrImageData != null) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: () {
                      setState(() => _qrImageData = null);
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Remove QR', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _addToCart(CartItem item) {
    for (var i = 0; i < _cartItems.length; i++) {
      final existing = _cartItems[i];
      if (existing.itemName == item.itemName &&
          existing.sizeName == item.sizeName &&
          _listEqual(existing.addOnNames, item.addOnNames)) {
        setState(() => existing.quantity += item.quantity);
        return;
      }
    }
    setState(() => _cartItems.add(item));
  }

  bool _listEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _updateCartItem(int index, CartItem updated) {
    setState(() => _cartItems[index] = updated);
  }

  void _deleteCartItem(int index) {
    setState(() => _cartItems.removeAt(index));
  }

  void _clearCart() => setState(() => _cartItems.clear());

  void _incrementCartItem(int index) =>
      setState(() => _cartItems[index].quantity++);

  void _decrementCartItem(int index) {
    if (_cartItems[index].quantity > 1) {
      setState(() => _cartItems[index].quantity--);
    } else {
      setState(() => _cartItems.removeAt(index));
    }
  }

  void _placeOrder(Order order) {
    widget.onPlaceOrder(order);
    setState(() => _cartItems.clear());
    if (order.paymentMethod == 'gcash' && _qrImageData != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(_qrImageData!, fit: BoxFit.contain),
              ),
              Positioned(
                top: 0, left: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showCheckout(BuildContext context) {
    final total = _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return CheckoutSheet(
          cartItems: _cartItems,
          total: total,
          onPlaceOrder: _placeOrder,
          qrImageData: _qrImageData,
        );
      },
    );
  }

  void _showCart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return CartSheet(
              items: List.from(_cartItems),
              onClear: () {
                _clearCart();
                setSheetState(() {});
              },
              onIncrement: (index) {
                _incrementCartItem(index);
                setSheetState(() {});
              },
              onDecrement: (index) {
                _decrementCartItem(index);
                setSheetState(() {});
              },
              onEdit: (index) {
                final item = _cartItems[index];
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) {
                    return EditCartSheet(
                      item: item,
                      onUpdate: (updated) {
                        _updateCartItem(index, updated);
                      },
                      onDelete: () {
                        _deleteCartItem(index);
                      },
                    );
                  },
                ).then((_) => setSheetState(() {}));
              },
              onCheckout: () {
                Navigator.of(context).pop();
                _showCheckout(context);
              },
            );
          },
        );
      },
    );
  }

  Widget _reportCard(String label, String value, Color color, Color bgSurface, Color borderColor,
      {double? width}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final screenWidth = MediaQuery.of(context).size.width;
    final valueSize = _isPhone(screenWidth) ? 20.0 : (_isTablet(screenWidth) ? 22.0 : 24.0);
    final innerPad = _isPhone(screenWidth) ? 12.0 : 16.0;

    return Container(
      width: width,
      padding: EdgeInsets.all(innerPad),
      decoration: BoxDecoration(
        color: bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: textMuted, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: valueSize, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _reportCardCustom(String title, Color bgSurface, Color borderColor, Color textMuted, Color textColor,
      double padding, Widget child) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 11, color: textMuted, letterSpacing: 1, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          child,
        ],
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

    final screenWidth = MediaQuery.of(context).size.width;
    final padding = _isPhone(screenWidth) ? 16.0 : (_isTablet(screenWidth) ? 24.0 : 32.0);
    final titleSize = _isPhone(screenWidth) ? 18.0 : (_isTablet(screenWidth) ? 20.0 : 22.0);
    final avatarRadius = _isPhone(screenWidth) ? 18.0 : 22.0;
    final cardPad = _isPhone(screenWidth) ? 14.0 : 20.0;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'EMPLOYEES',
                    style: TextStyle(
                      fontSize: titleSize,
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
                      '${_employees.length} total',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _showRoleManager,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1F242E) : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shield_outlined, size: 14, color: textMuted),
                          const SizedBox(width: 4),
                          Text(
                            'Roles',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: textMuted,
                            ),
                          ),
                        ],
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
              SizedBox(height: _isPhone(screenWidth) ? 16.0 : 24.0),
              Expanded(
                child: _employees.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.badge_outlined, size: 48, color: textMuted.withValues(alpha: 0.4)),
                            const SizedBox(height: 12),
                            Text('No employees yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textMuted)),
                            const SizedBox(height: 4),
                            Text('Tap + to add your first employee', style: TextStyle(fontSize: 12, color: textMuted)),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: _employees.length,
                        separatorBuilder: (_, _) => SizedBox(height: _isPhone(screenWidth) ? 8 : 12),
                        itemBuilder: (context, index) {
                          final employee = _employees[index];
                          final roleInfo = _roles.firstWhere(
                            (r) => r['role'] == employee.role,
                            orElse: () => _roles[0],
                          );
                          final roleColor = roleInfo['color'] as Color;
                          final roleLabel = roleInfo['label'] as String;
                          final perms = roleInfo['permissions'] as List<String>;

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _showEmployeeForm(employee: employee, index: index),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: EdgeInsets.all(cardPad),
                                decoration: BoxDecoration(
                                  color: bgSurface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: avatarRadius,
                                          backgroundColor: roleColor.withValues(alpha: 0.15),
                                          child: Text(
                                            employee.name.split(' ').map((n) => n[0]).take(2).join(),
                                            style: TextStyle(
                                              fontSize: _isPhone(screenWidth) ? 12 : 14,
                                              fontWeight: FontWeight.bold,
                                              color: roleColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: _isPhone(screenWidth) ? 10 : 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Wrap(
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                spacing: 6,
                                                runSpacing: 4,
                                                children: [
                                                  Text(
                                                    employee.name,
                                                    style: TextStyle(
                                                      fontSize: _isPhone(screenWidth) ? 14 : 15,
                                                      fontWeight: FontWeight.w600,
                                                      color: textColor,
                                                    ),
                                                  ),
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
                                                    Container(
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
                                        Column(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.edit, size: 16, color: textMuted),
                                              onPressed: () => _showEmployeeForm(employee: employee, index: index),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                                              onPressed: () => _showDeleteEmployeeConfirm(index),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                            ),
                                          ],
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
                                      spacing: 6,
                                      runSpacing: 6,
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
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        Positioned(
          right: _isPhone(screenWidth) ? 16 : 24,
          bottom: _isPhone(screenWidth) ? 16 : 24,
          child: FloatingActionButton(
            mini: _isPhone(screenWidth),
            backgroundColor: primaryColor,
            foregroundColor: isDark ? const Color(0xFF0F1115) : Colors.white,
            onPressed: () => _showEmployeeForm(),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _showEmployeeForm({AppEmployee? employee, int? index}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    final isEditing = employee != null;
    final nameCtrl = TextEditingController(text: employee?.name ?? '');
    final emailCtrl = TextEditingController(text: employee?.email ?? '');
    late String selectedRole = employee?.role ?? 'cashier';
    late bool isActive = employee?.isActive ?? true;
    late List<String> selectedPerms = employee != null
        ? List<String>.from(employee.permissions)
        : List<String>.from(
            (_roles.firstWhere(
              (r) => r['role'] == selectedRole,
              orElse: () => _roles[0],
            )['permissions'] as List<String>),
          );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: Theme.of(ctx).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40, height: 4,
                          decoration: BoxDecoration(
                            color: textMuted.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        isEditing ? 'Edit Employee' : 'New Employee',
                        style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700,
                          letterSpacing: 1.5, color: textColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'e.g. Juan Dela Cruz',
                          labelStyle: TextStyle(color: textMuted, fontSize: 13),
                          hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5), fontSize: 13),
                          filled: true, fillColor: bgSurface,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryColor, width: 2)),
                        ),
                        style: TextStyle(color: textColor, fontSize: 14),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'juan@coffeeshop101.com',
                          labelStyle: TextStyle(color: textMuted, fontSize: 13),
                          hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5), fontSize: 13),
                          filled: true, fillColor: bgSurface,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryColor, width: 2)),
                        ),
                        style: TextStyle(color: textColor, fontSize: 14),
                      ),
                      const SizedBox(height: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ROLE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textMuted, letterSpacing: 0.5)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(color: bgSurface, borderRadius: BorderRadius.circular(8), border: Border.all(color: borderColor)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedRole,
                                isExpanded: true,
                                dropdownColor: bgSurface,
                                style: TextStyle(color: textColor, fontSize: 14),
                                items: _roles.map((r) {
                                  final roleName = r['role'] as String;
                                  final label = r['label'] as String;
                                  final color = r['color'] as Color;
                                  return DropdownMenuItem<String>(
                                    value: roleName,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8, height: 8,
                                          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(label),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (v) {
                                  if (v != null) {
                                    setSheetState(() {
                                      selectedRole = v;
                                      selectedPerms = List<String>.from(
                                        (_roles.firstWhere(
                                          (r) => r['role'] == v,
                                          orElse: () => _roles[0],
                                        )['permissions'] as List<String>),
                                      );
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Text('Active Account', style: TextStyle(fontSize: 14, color: textColor)),
                          const Spacer(),
                          Switch(
                            value: isActive,
                            onChanged: (v) => setSheetState(() => isActive = v),
                            activeThumbColor: Colors.green,
                            activeTrackColor: Colors.green.withValues(alpha: 0.2),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text('PERMISSIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textMuted, letterSpacing: 0.5)),
                      const SizedBox(height: 8),
                      ..._allPermissions.map((perm) {
                        final hasAccess = selectedPerms.contains(perm);
                        return CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          value: hasAccess,
                          title: Text(perm, style: TextStyle(fontSize: 14, color: textColor)),
                          onChanged: (_) {
                            setSheetState(() {
                              if (hasAccess) {
                                selectedPerms.remove(perm);
                              } else {
                                selectedPerms.add(perm);
                              }
                            });
                          },
                          activeColor: primaryColor,
                          checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        );
                      }),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          if (isEditing)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  _showDeleteEmployeeConfirm(index!);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.redAccent,
                                  side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.3)),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('DELETE', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1)),
                              ),
                            ),
                          if (isEditing) const SizedBox(width: 12),
                          Expanded(
                            flex: isEditing ? 1 : 2,
                            child: ElevatedButton(
                              onPressed: () {
                                final name = nameCtrl.text.trim();
                                final email = emailCtrl.text.trim();
                                if (name.isEmpty || email.isEmpty) return;
                                setState(() {
                                  final newEmployee = AppEmployee(
                                    name: name,
                                    email: email,
                                    role: selectedRole,
                                    isActive: isActive,
                                    permissions: List<String>.from(selectedPerms),
                                  );
                                  if (isEditing) {
                                    _employees[index!] = newEmployee;
                                  } else {
                                    _employees.add(newEmployee);
                                  }
                                });
                                Navigator.of(ctx).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: isDark ? const Color(0xFF0F1115) : Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(
                                isEditing ? 'SAVE' : 'ADD',
                                style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
      },
    );
  }

  void _showDeleteEmployeeConfirm(int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final employee = _employees[index];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, size: 20, color: Colors.redAccent),
            const SizedBox(width: 8),
            Text('Delete Employee', style: TextStyle(color: textColor, fontSize: 16)),
          ],
        ),
        content: Text(
          'Remove "${employee.name}" from the system?',
          style: TextStyle(color: textColor, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: TextButton.styleFrom(foregroundColor: textColor),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _employees.removeAt(index));
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  void _showRoleManager() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(ctx).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: DraggableScrollableSheet(
              initialChildSize: 0.65,
              minChildSize: 0.4,
              maxChildSize: 0.85,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40, height: 4,
                          decoration: BoxDecoration(
                            color: textMuted.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(Icons.shield, size: 20, color: textColor),
                          const SizedBox(width: 8),
                          Text(
                            'MANAGE ROLES',
                            style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700,
                              letterSpacing: 1.5, color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ..._roles.asMap().entries.map((entry) {
                        final i = entry.key;
                        final role = entry.value;
                        final name = role['role'] as String;
                        final label = role['label'] as String;
                        final color = role['color'] as Color;
                        final perms = role['permissions'] as List<String>;
                        final employeeCount = _employees.where((e) => e.role == name).length;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _showRoleForm(role: role, index: i),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: bgSurface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36, height: 36,
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(Icons.shield, size: 18, color: color),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
                                          const SizedBox(height: 2),
                                          Text('${perms.length} permissions · $employeeCount employee${employeeCount == 1 ? '' : 's'}',
                                              style: TextStyle(fontSize: 11, color: textMuted)),
                                        ],
                                      ),
                                    ),
                                    if (name != 'super_admin')
                                      IconButton(
                                        icon: Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                                        onPressed: () => _showDeleteRoleConfirm(role, i),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showRoleForm(),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add Role'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryColor,
                            side: BorderSide(color: primaryColor.withValues(alpha: 0.3)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          );
        });
      },
    );
  }

  void _showRoleForm({Map<String, dynamic>? role, int? index}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    final isEditing = role != null;
    final nameCtrl = TextEditingController(text: role?['role'] ?? '');
    final labelCtrl = TextEditingController(text: role?['label'] ?? '');
    late Color selectedColor = role != null
        ? role['color'] as Color
        : const Color(0xFF6366F1);
    late List<String> selectedPerms = role != null
        ? List<String>.from(role['permissions'] as List)
        : [];

    const presetColors = [
      Color(0xFF7C3AED), Color(0xFF3B82F6), Color(0xFFF59E0B),
      Color(0xFF10B981), Color(0xFF6366F1), Color(0xFFEF4444),
      Color(0xFFEC4899), Color(0xFF14B8A6), Color(0xFFF97316),
      Color(0xFF8B5CF6), Color(0xFF06B6D4), Color(0xFF84CC16),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: Theme.of(ctx).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.4,
              maxChildSize: 0.85,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40, height: 4,
                          decoration: BoxDecoration(
                            color: textMuted.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        isEditing ? 'Edit Role' : 'New Role',
                        style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700,
                          letterSpacing: 1.5, color: textColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          labelText: 'Role Key',
                          hintText: 'e.g. shift_lead',
                          labelStyle: TextStyle(color: textMuted, fontSize: 13),
                          hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5), fontSize: 13),
                          filled: true, fillColor: bgSurface,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryColor, width: 2)),
                        ),
                        style: TextStyle(color: textColor, fontSize: 14),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: labelCtrl,
                        decoration: InputDecoration(
                          labelText: 'Display Label',
                          hintText: 'e.g. Shift Lead',
                          labelStyle: TextStyle(color: textMuted, fontSize: 13),
                          hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5), fontSize: 13),
                          filled: true, fillColor: bgSurface,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryColor, width: 2)),
                        ),
                        style: TextStyle(color: textColor, fontSize: 14),
                      ),
                      const SizedBox(height: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('COLOR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textMuted, letterSpacing: 0.5)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: presetColors.map((c) {
                              final isSelected = selectedColor.toARGB32() == c.toARGB32();
                              return GestureDetector(
                                onTap: () => setSheetState(() => selectedColor = c),
                                child: Container(
                                  width: 32, height: 32,
                                  decoration: BoxDecoration(
                                    color: c,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? Colors.white : Colors.transparent,
                                      width: 3,
                                    ),
                                    boxShadow: isSelected
                                        ? [BoxShadow(color: c.withValues(alpha: 0.4), blurRadius: 6)]
                                        : null,
                                  ),
                                  child: isSelected
                                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                                      : null,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text('PERMISSIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textMuted, letterSpacing: 0.5)),
                      const SizedBox(height: 8),
                      ..._allPermissions.map((perm) {
                        final hasAccess = selectedPerms.contains(perm);
                        return CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          value: hasAccess,
                          title: Text(perm, style: TextStyle(fontSize: 14, color: textColor)),
                          onChanged: (_) {
                            setSheetState(() {
                              if (hasAccess) {
                                selectedPerms.remove(perm);
                              } else {
                                selectedPerms.add(perm);
                              }
                            });
                          },
                          activeColor: primaryColor,
                          checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        );
                      }),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: textMuted,
                                side: BorderSide(color: borderColor),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                final key = nameCtrl.text.trim().toLowerCase().replaceAll(' ', '_');
                                final label = labelCtrl.text.trim();
                                if (key.isEmpty || label.isEmpty) return;
                                if (!isEditing && _roles.any((r) => r['role'] == key)) return;
                                setState(() {
                                  final newRole = {
                                    'role': key,
                                    'label': label,
                                    'color': selectedColor,
                                    'permissions': List<String>.from(selectedPerms),
                                  };
                                  if (isEditing) {
                                    _roles[index!] = newRole;
                                  } else {
                                    _roles.add(newRole);
                                  }
                                });
                                Navigator.of(ctx).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: isDark ? const Color(0xFF0F1115) : Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(
                                isEditing ? 'SAVE' : 'ADD',
                                style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
      },
    );
  }

  void _showDeleteRoleConfirm(Map<String, dynamic> role, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final roleName = role['label'] as String;
    final roleKey = role['role'] as String;
    final assignedCount = _employees.where((e) => e.role == roleKey).length;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, size: 20, color: Colors.redAccent),
            const SizedBox(width: 8),
            Text('Delete Role', style: TextStyle(color: textColor, fontSize: 16)),
          ],
        ),
        content: Text(
          'Delete "$roleName"?\n'
          '${assignedCount > 0 ? '$assignedCount employee(s) currently have this role and will be reassigned.' : 'No employees currently have this role.'}',
          style: TextStyle(color: textColor, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: TextButton.styleFrom(foregroundColor: textColor),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _roles.removeAt(index);
                for (var i = 0; i < _employees.length; i++) {
                  if (_employees[i].role == roleKey) {
                    _employees[i] = AppEmployee(
                      name: _employees[i].name,
                      email: _employees[i].email,
                      role: _roles.isNotEmpty ? _roles[0]['role'] as String : '',
                      isActive: _employees[i].isActive,
                      permissions: _employees[i].permissions,
                    );
                  }
                }
              });
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    final screenWidth = MediaQuery.of(context).size.width;
    final padding = _isPhone(screenWidth) ? 16.0 : (_isTablet(screenWidth) ? 24.0 : 32.0);
    final cardGap = _isPhone(screenWidth) ? 12.0 : 16.0;

    final orders = _orders;
    final totalOrders = orders.length;
    final totalRevenue = orders.fold(0.0, (sum, o) => sum + o.total);
    final avgOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0.0;
    final totalItems = orders.fold(0, (sum, o) => sum + o.items.fold(0, (s, i) => s + i.quantity));

    final statusColors = {
      'pending': Colors.orange,
      'preparing': Colors.blue,
      'ready': Colors.green,
      'done': textMuted,
    };
    final statusLabels = {
      'pending': 'Pending',
      'preparing': 'Preparing',
      'ready': 'Ready',
      'done': 'Done',
    };

    final statusCounts = <String, int>{};
    for (final s in ['pending', 'preparing', 'ready', 'done']) {
      statusCounts[s] = orders.where((o) => o.status == s).length;
    }

    final paymentData = <String, int>{};
    for (final o in orders) {
      final pm = o.paymentMethod.toUpperCase();
      paymentData[pm] = (paymentData[pm] ?? 0) + 1;
    }

    final itemCounts = <String, int>{};
    for (final o in orders) {
      for (final item in o.items) {
        itemCounts[item.itemName] = (itemCounts[item.itemName] ?? 0) + item.quantity;
      }
    }
    final topItems = itemCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    final catRevenue = <String, double>{};
    final catCounts = <String, int>{};
    for (final cat in _menuCategories) {
      catRevenue[cat['name'] as String] = 0.0;
      catCounts[cat['name'] as String] = 0;
    }
    for (final o in orders) {
      for (final item in o.items) {
        final menuItem = _menuItems.cast<Map<String, dynamic>?>().firstWhere(
          (m) => m?['name'] == item.itemName,
          orElse: () => null,
        );
        if (menuItem != null) {
          final catName = _menuCategories
              .firstWhere((c) => c['id'] == menuItem['category_id'],
                  orElse: () => {'name': 'Other'})['name'] as String;
          catRevenue[catName] = (catRevenue[catName] ?? 0) + item.totalPrice;
          catCounts[catName] = (catCounts[catName] ?? 0) + item.quantity;
        }
      }
    }

    return Padding(
      padding: EdgeInsets.all(padding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SHOP REPORTS',
              style: TextStyle(
                fontSize: _isPhone(screenWidth) ? 18 : 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: textColor,
              ),
            ),
            SizedBox(height: cardGap),

            // Summary cards
            LayoutBuilder(builder: (context, constraints) {
              final cols = _isPhone(screenWidth) ? 2 : (_isTablet(screenWidth) ? 2 : 4);
              final cardW = (constraints.maxWidth - cardGap * (cols - 1)) / cols;
              return Wrap(
                spacing: cardGap, runSpacing: cardGap,
                children: [
                  _reportCard('Total Orders', '$totalOrders', primaryColor, bgSurface, borderColor, width: cardW),
                  _reportCard('Total Revenue', 'Php ${totalRevenue.toStringAsFixed(2)}', const Color(0xFF059669), bgSurface, borderColor, width: cardW),
                  _reportCard('Avg Order', 'Php ${avgOrderValue.toStringAsFixed(2)}', const Color(0xFF7C3AED), bgSurface, borderColor, width: cardW),
                  _reportCard('Items Sold', '$totalItems', const Color(0xFFF59E0B), bgSurface, borderColor, width: cardW),
                ],
              );
            }),

            // Row: Order Status + Payment Methods
            if (!_isPhone(screenWidth))
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _reportCardCustom(
                    'ORDER STATUS',
                    bgSurface, borderColor, textMuted, textColor, padding,
                    Column(
                      children: [
                        ...['pending', 'preparing', 'ready', 'done'].map((s) {
                          final count = statusCounts[s] ?? 0;
                          final pct = totalOrders > 0 ? count / totalOrders : 0.0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(width: 10, height: 10, decoration: BoxDecoration(
                                          shape: BoxShape.circle, color: statusColors[s],
                                        )),
                                        const SizedBox(width: 6),
                                        Text(statusLabels[s]!, style: TextStyle(fontSize: 12, color: textColor)),
                                      ],
                                    ),
                                    Text('$count', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: pct,
                                    backgroundColor: borderColor,
                                    valueColor: AlwaysStoppedAnimation(statusColors[s]!),
                                    minHeight: 6,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  )),
                  SizedBox(width: cardGap),
                  Expanded(child: _reportCardCustom(
                    'PAYMENT METHODS',
                    bgSurface, borderColor, textMuted, textColor, padding,
                    Column(
                      children: paymentData.entries.map((e) {
                        final pct = totalOrders > 0 ? e.value / totalOrders : 0.0;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(e.key == 'CASH' ? Icons.payments : Icons.phone_iphone,
                                        size: 16, color: e.key == 'CASH' ? const Color(0xFF059669) : const Color(0xFF3B82F6)),
                                      const SizedBox(width: 6),
                                      Text(e.key, style: TextStyle(fontSize: 12, color: textColor)),
                                    ],
                                  ),
                                  Text('${e.value}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  backgroundColor: borderColor,
                                  valueColor: AlwaysStoppedAnimation(e.key == 'CASH' ? const Color(0xFF059669) : const Color(0xFF3B82F6)),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  )),
                ],
              )
            else ...[
              // Phone: stacked
              _reportCardCustom(
                'ORDER STATUS', bgSurface, borderColor, textMuted, textColor, padding,
                Column(
                  children: ['pending', 'preparing', 'ready', 'done'].map((s) {
                    final count = statusCounts[s] ?? 0;
                    final pct = totalOrders > 0 ? count / totalOrders : 0.0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Row(children: [
                              Container(width: 10, height: 10, decoration: BoxDecoration(
                                shape: BoxShape.circle, color: statusColors[s],
                              )),
                              const SizedBox(width: 6),
                              Text(statusLabels[s]!, style: TextStyle(fontSize: 12, color: textColor)),
                            ]),
                            Text('$count', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
                          ]),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: pct, backgroundColor: borderColor,
                              valueColor: AlwaysStoppedAnimation(statusColors[s]!),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: cardGap),
              _reportCardCustom(
                'PAYMENT METHODS', bgSurface, borderColor, textMuted, textColor, padding,
                Column(
                  children: paymentData.entries.map((e) {
                    final pct = totalOrders > 0 ? e.value / totalOrders : 0.0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Row(children: [
                              Icon(e.key == 'CASH' ? Icons.payments : Icons.phone_iphone,
                                size: 16, color: e.key == 'CASH' ? const Color(0xFF059669) : const Color(0xFF3B82F6)),
                              const SizedBox(width: 6),
                              Text(e.key, style: TextStyle(fontSize: 12, color: textColor)),
                            ]),
                            Text('${e.value}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
                          ]),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: pct, backgroundColor: borderColor,
                              valueColor: AlwaysStoppedAnimation(e.key == 'CASH' ? const Color(0xFF059669) : const Color(0xFF3B82F6)),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            SizedBox(height: cardGap),

            // Revenue by Category
            _reportCardCustom(
              'REVENUE BY CATEGORY', bgSurface, borderColor, textMuted, textColor, padding,
              Column(
                children: catRevenue.entries.map((e) {
                  final pct = totalRevenue > 0 ? e.value / totalRevenue : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(e.key.toUpperCase(), style: TextStyle(fontSize: 12, color: textColor)),
                          Text('Php ${e.value.toStringAsFixed(2)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
                        ]),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: pct, backgroundColor: borderColor,
                            valueColor: AlwaysStoppedAnimation(primaryColor),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: cardGap),

            // Top Selling Items
            _reportCardCustom(
              'TOP SELLING ITEMS', bgSurface, borderColor, textMuted, textColor, padding,
              Column(
                children: topItems.take(10).toList().asMap().entries.map((entry) {
                  final i = entry.key;
                  final e = entry.value;
                  final pct = totalItems > 0 ? e.value / totalItems : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Text('${i + 1}',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: primaryColor)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.key, style: TextStyle(fontSize: 12, color: textColor), overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: pct, backgroundColor: borderColor,
                                  valueColor: AlwaysStoppedAnimation(primaryColor),
                                  minHeight: 5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 40,
                          child: Text('${e.value}',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOrderingSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    final screenWidth = MediaQuery.of(context).size.width;
    final padding = _isPhone(screenWidth) ? 12.0 : (_isTablet(screenWidth) ? 16.0 : 20.0);
    final gap = _isPhone(screenWidth) ? 8.0 : 12.0;
    final titleSize = _isPhone(screenWidth) ? 16.0 : 20.0;

    final categoryId = _menuCategories[_selectedCat]['id'] as int;
    final filteredItems = _menuItems
        .where((item) => item['category_id'] == categoryId && item['isAvailable'] == true)
        .toList();
    final cartQty = _cartItems.fold(0, (sum, i) => sum + i.quantity);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('ORDER MENU', style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w700, letterSpacing: 2, color: textColor)),
            const Spacer(),
            GestureDetector(
              onTap: () => _showCart(context),
              child: Badge(
                isLabelVisible: cartQty > 0,
                label: Text('$cartQty', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                backgroundColor: primaryColor,
                child: Icon(Icons.shopping_cart_outlined, color: textMuted, size: 22),
              ),
            ),
          ]),
          SizedBox(height: gap),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: List.generate(_menuCategories.length, (i) {
              final isSel = _selectedCat == i;
              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text((_menuCategories[i]['name'] as String).toUpperCase(),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: isSel ? (isDark ? const Color(0xFF0F1115) : Colors.white) : textMuted)),
                  selected: isSel,
                  onSelected: (_) => setState(() => _selectedCat = i),
                  selectedColor: primaryColor,
                  backgroundColor: bgSurface,
                  side: BorderSide(color: borderColor),
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              );
            })),
          ),
          SizedBox(height: gap),
          Expanded(
            child: filteredItems.isEmpty
              ? Center(child: Text('No items available', style: TextStyle(color: textMuted, fontSize: 13)))
              : LayoutBuilder(builder: (context, constraints) {
                  final cols = _isWidescreen(screenWidth) ? 4 : 2;
                  final itemW = (constraints.maxWidth - gap * (cols - 1)) / cols;
                  return SingleChildScrollView(
                    child: Wrap(spacing: gap, runSpacing: gap, children: filteredItems.map((item) {
                      final sizes = (item['sizes'] as List).cast<Map<String, dynamic>>();
                      final addOnIds = (item['addOnIds'] as List).cast<int>();
                      final addOns = _globalAddOns
                          .where((a) => addOnIds.contains(a['id']) && a['isAvailable'] == true)
                          .map((a) => {'name': a['name'], 'price': a['price']})
                          .toList();
                      return SizedBox(width: itemW, child: ItemCard(
                        imageUrl: item['imageUrl'] as String? ?? '',
                        itemName: item['name'] as String,
                        itemLabel: item['label'] as String? ?? '',
                        itemDescription: item['description'] as String? ?? '',
                        availableSizes: sizes,
                        availableAddOns: addOns,
                        onAddToOrder: _addToCart,
                      ));
                    }).toList()),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneMenuOrderingSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    final categoryId = _menuCategories[_selectedCat]['id'] as int;
    final filteredItems = _menuItems
        .where((item) => item['category_id'] == categoryId && item['isAvailable'] == true)
        .toList();
    final cartQty = _cartItems.fold(0, (sum, i) => sum + i.quantity);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        Row(children: [
          Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal,
            child: Row(children: List.generate(_menuCategories.length, (i) {
              final isSel = _selectedCat == i;
              return Padding(padding: EdgeInsets.only(right: 6), child: ChoiceChip(
                label: Text((_menuCategories[i]['name'] as String).toUpperCase(),
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
                    color: isSel ? (isDark ? const Color(0xFF0F1115) : Colors.white) : textMuted)),
                selected: isSel, onSelected: (_) => setState(() => _selectedCat = i),
                selectedColor: primaryColor, backgroundColor: bgSurface,
                side: BorderSide(color: borderColor), padding: EdgeInsets.symmetric(horizontal: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ));
            })),
          )),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _showCart(context),
            child: Badge(isLabelVisible: cartQty > 0,
              label: Text('$cartQty', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              backgroundColor: primaryColor,
              child: Icon(Icons.shopping_cart_outlined, color: textMuted, size: 22)),
          ),
        ]),
        const SizedBox(height: 8),
        Expanded(child: filteredItems.isEmpty
          ? Center(child: Text('No items available', style: TextStyle(color: textMuted, fontSize: 13)))
          : LayoutBuilder(builder: (context, constraints) {
              final itemW = constraints.maxWidth;
              return SingleChildScrollView(
                child: Wrap(spacing: 8, runSpacing: 8, children: filteredItems.map((item) {
                  final sizes = (item['sizes'] as List).cast<Map<String, dynamic>>();
                  final addOnIds = (item['addOnIds'] as List).cast<int>();
                  final addOns = _globalAddOns
                      .where((a) => addOnIds.contains(a['id']) && a['isAvailable'] == true)
                      .map((a) => {'name': a['name'], 'price': a['price']}).toList();
                  return SizedBox(width: itemW, child: ItemCard(
                    imageUrl: item['imageUrl'] as String? ?? '',
                    itemName: item['name'] as String, itemLabel: item['label'] as String? ?? '',
                    itemDescription: item['description'] as String? ?? '',
                    availableSizes: sizes, availableAddOns: addOns, onAddToOrder: _addToCart,
                  ));
                }).toList()),
              );
            }),
        ),
      ]),
    );
  }

  Widget _buildMenuSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    final screenWidth = MediaQuery.of(context).size.width;
    final padding = _isPhone(screenWidth) ? 12.0 : (_isTablet(screenWidth) ? 16.0 : 20.0);
    final titleSize = _isPhone(screenWidth) ? 18.0 : (_isTablet(screenWidth) ? 20.0 : 22.0);
    final sectionTitleSize = _isPhone(screenWidth) ? 14.0 : 16.0;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'MENU',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_menuItems.length} items',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: _isPhone(screenWidth) ? 12.0 : 16.0),
              Expanded(
                child: ListView.separated(
                  itemCount: _menuCategories.length,
                  separatorBuilder: (_, _) => SizedBox(height: _isPhone(screenWidth) ? 12 : 16),
                  itemBuilder: (context, catIndex) {
                    final cat = _menuCategories[catIndex];
                    final catId = cat['id'] as int;
                    final catName = cat['name'] as String;
                    final items = _menuItems.where((i) => i['category_id'] == catId).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 20,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              catName.toUpperCase(),
                              style: TextStyle(
                                fontSize: sectionTitleSize,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${items.length} items',
                              style: TextStyle(fontSize: 11, color: textMuted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (items.isEmpty)
                          Padding(
                            padding: EdgeInsets.only(
                              left: 14,
                              top: 8,
                              bottom: _isPhone(screenWidth) ? 10 : 12,
                            ),
                            child: Text(
                              'No items in this category',
                              style: TextStyle(fontSize: 12, color: textMuted, fontStyle: FontStyle.italic),
                            ),
                          )
                        else
                          ...items.map((item) {
                            final sizes = _getSizesForItem(item);
                            final itemAddOns = _getAddOnsForItem(item);
                            final isAvailable = item['isAvailable'] as bool;
                            final imageUrl = item['imageUrl'] as String? ?? '';

                            return Padding(
                              padding: EdgeInsets.only(bottom: _isPhone(screenWidth) ? 8 : 10),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _showEditMenuItemDialog(item),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: EdgeInsets.all(_isPhone(screenWidth) ? 12 : 16),
                                    decoration: BoxDecoration(
                                      color: bgSurface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isAvailable ? borderColor : Colors.red.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (imageUrl.isNotEmpty) ...[
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: imageUrl.startsWith('data:image')
                                                ? Image.memory(
                                                    decodeBase64Image(imageUrl)!,
                                                    width: 64,
                                                    height: 64,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                                                  )
                                                : Image.network(
                                                    imageUrl,
                                                    width: 64,
                                                    height: 64,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                                                  ),
                                          ),
                                          const SizedBox(width: 12),
                                        ],
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 6,
                                                    height: 6,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: isAvailable ? Colors.green : Colors.red,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      item['name'] as String,
                                                      style: TextStyle(
                                                        fontSize: _isPhone(screenWidth) ? 14 : 15,
                                                        fontWeight: FontWeight.w600,
                                                        color: isAvailable ? textColor : textMuted,
                                                      ),
                                                    ),
                                                  ),
                                                  if ((item['label'] as String).isNotEmpty)
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: primaryColor.withValues(alpha: 0.15),
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: Text(
                                                        item['label'] as String,
                                                        style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold,
                                                          color: primaryColor,
                                                          letterSpacing: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                                  if (!isAvailable)
                                                    Container(
                                                      margin: const EdgeInsets.only(left: 6),
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red.withValues(alpha: 0.15),
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: Text(
                                                        'UNAVAILABLE',
                                                        style: TextStyle(
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.redAccent,
                                                          letterSpacing: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                                  const SizedBox(width: 4),
                                                  Icon(Icons.edit, size: 14, color: textMuted),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                item['description'] as String,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isAvailable ? textMuted : textMuted.withValues(alpha: 0.5),
                                                ),
                                              ),
                                              if (sizes.isNotEmpty || itemAddOns.isNotEmpty) ...[
                                                const SizedBox(height: 8),
                                                Wrap(
                                                  spacing: 4,
                                                  runSpacing: 4,
                                                  children: [
                                                    ...sizes.map((s) => Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                      decoration: BoxDecoration(
                                                        color: primaryColor.withValues(alpha: 0.08),
                                                        borderRadius: BorderRadius.circular(6),
                                                        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
                                                      ),
                                                      child: Text(
                                                        '${s['name']} — Php ${(s['price'] as double).toStringAsFixed(0)}',
                                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: primaryColor),
                                                      ),
                                                    )),
                                                    ...itemAddOns.map((a) => Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green.withValues(alpha: 0.08),
                                                        borderRadius: BorderRadius.circular(6),
                                                        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
                                                      ),
                                                      child: Text(
                                                        '${a['name']} +Php ${(a['price'] as num).toStringAsFixed(0)}',
                                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.green.shade600),
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: _isPhone(screenWidth) ? 16 : 24,
          bottom: _isPhone(screenWidth) ? 16 : 24,
          child: FloatingActionButton(
            mini: _isPhone(screenWidth),
            backgroundColor: primaryColor,
            foregroundColor: isDark ? const Color(0xFF0F1115) : Colors.white,
            onPressed: _showAddMenuItemDialog,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _buildAddOnsSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    final screenWidth = MediaQuery.of(context).size.width;
    final padding = _isPhone(screenWidth) ? 12.0 : (_isTablet(screenWidth) ? 16.0 : 20.0);
    final titleSize = _isPhone(screenWidth) ? 18.0 : (_isTablet(screenWidth) ? 20.0 : 22.0);

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.extension, size: titleSize - 2, color: textColor),
                  const SizedBox(width: 8),
                  Text(
                    'ADD-ONS',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_globalAddOns.length} add-ons',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: _isPhone(screenWidth) ? 12.0 : 16.0),
              Expanded(
                child: _globalAddOns.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.extension_off_outlined, size: 48, color: textMuted.withValues(alpha: 0.4)),
                            const SizedBox(height: 12),
                            Text('No add-ons yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textMuted)),
                            const SizedBox(height: 4),
                            Text('Tap + to create your first add-on', style: TextStyle(fontSize: 12, color: textMuted)),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: _globalAddOns.length,
                        separatorBuilder: (_, _) => SizedBox(height: _isPhone(screenWidth) ? 8 : 10),
                        itemBuilder: (context, index) {
                          final addOn = _globalAddOns[index];
                          final name = addOn['name'] as String;
                          final price = addOn['price'] as num;
                          final available = addOn['isAvailable'] as bool;
                          final usageCount = _menuItems.where((m) {
                            final ids = m['addOnIds'] as List? ?? [];
                            return ids.contains(addOn['id']);
                          }).length;

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _showEditAddOnDialog(addOn),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: EdgeInsets.all(_isPhone(screenWidth) ? 12 : 14),
                                decoration: BoxDecoration(
                                  color: bgSurface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: available ? borderColor : Colors.red.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: available
                                            ? primaryColor.withValues(alpha: 0.1)
                                            : Colors.grey.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.extension,
                                        size: 18,
                                        color: available ? primaryColor : textMuted,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: TextStyle(
                                              fontSize: _isPhone(screenWidth) ? 14 : 15,
                                              fontWeight: FontWeight.w600,
                                              color: available ? textColor : textMuted,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Text(
                                                'Php ${price.toStringAsFixed(0)}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: available ? primaryColor : textMuted,
                                                ),
                                              ),
                                              if (usageCount > 0) ...[
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green.withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    '$usageCount item${usageCount == 1 ? '' : 's'}',
                                                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.green.shade600),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Switch(
                                      value: available,
                                      onChanged: (v) {
                                        setState(() => addOn['isAvailable'] = v);
                                      },
                                      activeThumbColor: Colors.green,
                                      activeTrackColor: Colors.green.withValues(alpha: 0.2),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit, size: 16, color: textMuted),
                                      onPressed: () => _showEditAddOnDialog(addOn),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                    ),
                                    const SizedBox(width: 2),
                                    IconButton(
                                      icon: Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                                      onPressed: () => _showDeleteAddOnConfirm(addOn),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        if (_globalAddOns.isNotEmpty)
          Positioned(
            right: _isPhone(screenWidth) ? 16 : 24,
            bottom: _isPhone(screenWidth) ? 16 : 24,
            child: FloatingActionButton(
              mini: _isPhone(screenWidth),
              backgroundColor: primaryColor,
              foregroundColor: isDark ? const Color(0xFF0F1115) : Colors.white,
              onPressed: _showAddAddOnDialog,
              child: const Icon(Icons.add),
            ),
          ),
      ],
    );
  }

  void _showAddAddOnDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: Theme.of(ctx).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: textMuted.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'New Add-on',
                    style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700,
                      letterSpacing: 1.5, color: textColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameCtrl,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'e.g. Espresso Shot',
                      labelStyle: TextStyle(color: textMuted, fontSize: 13),
                      hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5), fontSize: 13),
                      filled: true, fillColor: bgSurface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryColor, width: 2)),
                    ),
                    style: TextStyle(color: textColor, fontSize: 14),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: priceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Price',
                      hintText: '0.00',
                      prefixText: 'Php ',
                      prefixStyle: TextStyle(color: textMuted, fontSize: 14),
                      labelStyle: TextStyle(color: textMuted, fontSize: 13),
                      hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5), fontSize: 13),
                      filled: true, fillColor: bgSurface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryColor, width: 2)),
                    ),
                    style: TextStyle(color: textColor, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: textMuted,
                            side: BorderSide(color: borderColor),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final name = nameCtrl.text.trim();
                            final price = double.tryParse(priceCtrl.text.trim()) ?? 0;
                            if (name.isEmpty || price <= 0) return;
                            setState(() {
                              _globalAddOns.add({
                                'id': _nextAddOnId++,
                                'name': name,
                                'price': price,
                                'isAvailable': true,
                              });
                            });
                            Navigator.of(ctx).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: isDark ? const Color(0xFF0F1115) : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('ADD', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _showEditAddOnDialog(Map<String, dynamic> addOn) {
    final nameCtrl = TextEditingController(text: addOn['name'] as String);
    final priceCtrl = TextEditingController(text: (addOn['price'] as num).toStringAsFixed(0));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: Theme.of(ctx).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: textMuted.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Edit Add-on',
                    style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700,
                      letterSpacing: 1.5, color: textColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: textMuted, fontSize: 13),
                      filled: true, fillColor: bgSurface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryColor, width: 2)),
                    ),
                    style: TextStyle(color: textColor, fontSize: 14),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: priceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Price',
                      prefixText: 'Php ',
                      prefixStyle: TextStyle(color: textMuted, fontSize: 14),
                      labelStyle: TextStyle(color: textMuted, fontSize: 13),
                      filled: true, fillColor: bgSurface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryColor, width: 2)),
                    ),
                    style: TextStyle(color: textColor, fontSize: 14),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text('Available', style: TextStyle(fontSize: 14, color: textColor)),
                      const Spacer(),
                      Switch(
                        value: addOn['isAvailable'] as bool,
                        onChanged: (v) {
                          setSheetState(() => addOn['isAvailable'] = v);
                        },
                        activeThumbColor: Colors.green,
                        activeTrackColor: Colors.green.withValues(alpha: 0.2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: textMuted,
                            side: BorderSide(color: borderColor),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final name = nameCtrl.text.trim();
                            final price = double.tryParse(priceCtrl.text.trim()) ?? 0;
                            if (name.isEmpty || price <= 0) return;
                            setState(() {
                              addOn['name'] = name;
                              addOn['price'] = price;
                            });
                            Navigator.of(ctx).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: isDark ? const Color(0xFF0F1115) : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('SAVE', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _showDeleteAddOnConfirm(Map<String, dynamic> addOn) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, size: 20, color: Colors.redAccent),
            const SizedBox(width: 8),
            Text('Delete Add-on', style: TextStyle(color: textColor, fontSize: 16)),
          ],
        ),
        content: Text(
          'Delete "${addOn['name']}"?\nThis will remove it from all menu items that use it.',
          style: TextStyle(color: textColor, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: TextButton.styleFrom(foregroundColor: textColor),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _globalAddOns.removeWhere((a) => a['id'] == addOn['id']);
                for (final item in _menuItems) {
                  (item['addOnIds'] as List).remove(addOn['id']);
                }
              });
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getSizesForItem(Map<String, dynamic> item) {
    final sizes = item['sizes'];
    if (sizes is List) return sizes.cast<Map<String, dynamic>>();
    return [];
  }

  List<Map<String, dynamic>> _getAddOnsForItem(Map<String, dynamic> item) {
    final ids = item['addOnIds'] as List? ?? [];
    return _globalAddOns.where((a) => ids.contains(a['id'])).toList();
  }

  void _showEditMenuItemDialog(Map<String, dynamic> item) {
    _showMenuItemForm(
      title: 'Edit ${item['name']}',
      name: item['name'] as String,
      description: item['description'] as String,
      label: item['label'] as String,
      isAvailable: item['isAvailable'] as bool,
      categoryId: item['category_id'] as int,
      imageUrl: item['imageUrl'] as String? ?? '',
      initialSizes: (item['sizes'] as List).cast<Map<String, dynamic>>(),
      initialAddOnIds: (item['addOnIds'] as List).cast<int>(),
      onSave: (name, desc, label, available, catId, imageUrl, sizes, addOnIds) {
        setState(() {
          item['name'] = name;
          item['description'] = desc;
          item['label'] = label;
          item['isAvailable'] = available;
          item['category_id'] = catId;
          item['imageUrl'] = imageUrl;
          item['sizes'] = sizes;
          item['addOnIds'] = addOnIds;
        });
      },
      onDelete: () {
        setState(() => _menuItems.removeWhere((i) => i['id'] == item['id']));
      },
    );
  }

  void _showAddMenuItemDialog() {
    _showMenuItemForm(
      title: 'Add Menu Item',
      name: '',
      description: '',
      label: '',
      isAvailable: true,
      categoryId: 1,
      imageUrl: '',
      initialSizes: [],
      initialAddOnIds: [],
      onSave: (name, desc, label, available, catId, imageUrl, sizes, addOnIds) {
        setState(() {
          _menuItems.add({
            'id': _nextItemId++,
            'category_id': catId,
            'name': name,
            'label': label,
            'description': desc,
            'isAvailable': available,
            'imageUrl': imageUrl,
            'sizes': sizes,
            'addOnIds': addOnIds,
          });
        });
      },
    );
  }

  void _showMenuItemForm({
    required String title,
    required String name,
    required String description,
    required String label,
    required bool isAvailable,
    required int categoryId,
    required String imageUrl,
    required List<Map<String, dynamic>> initialSizes,
    required List<int> initialAddOnIds,
    required void Function(String name, String desc, String label, bool available, int catId, String imageUrl, List<Map<String, dynamic>> sizes, List<int> addOnIds) onSave,
    VoidCallback? onDelete,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _MenuItemFormSheet(
          title: title,
          initialName: name,
          initialDescription: description,
          initialLabel: label,
          initialAvailable: isAvailable,
          initialCategoryId: categoryId,
          initialImageUrl: imageUrl,
          initialSizes: initialSizes,
          initialAddOnIds: initialAddOnIds,
          categories: _menuCategories,
          globalAddOns: _globalAddOns,
          onSave: onSave,
          onDelete: onDelete,
          onAddCategory: (catName) {
            setState(() {
              final newId = (_menuCategories.map((c) => c['id'] as int).reduce((a, b) => a > b ? a : b)) + 1;
              _menuCategories.add({'id': newId, 'name': catName});
            });
            return _menuCategories.last['id'] as int;
          },
        );
      },
    );
  }
}

Uint8List? decodeBase64Image(String dataUri) {
  if (dataUri.startsWith('data:image')) {
    final parts = dataUri.split(',');
    if (parts.length == 2) {
      try {
        return base64Decode(parts[1]);
      } catch (_) {
        return null;
      }
    }
  }
  return null;
}

String encodeImageToDataUri(Uint8List bytes, String ext) {
  final base64 = base64Encode(bytes);
  return 'data:image/$ext;base64,$base64';
}

class _GlowingContainer extends StatefulWidget {
  final Widget child;

  const _GlowingContainer({required this.child});

  @override
  State<_GlowingContainer> createState() => _GlowingContainerState();
}

class _GlowingContainerState extends State<_GlowingContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _glow = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glow,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.green.withValues(alpha: _glow.value),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withValues(alpha: _glow.value * 0.25),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _MenuItemFormSheet extends StatefulWidget {
  final String title;
  final String initialName;
  final String initialDescription;
  final String initialLabel;
  final bool initialAvailable;
  final int initialCategoryId;
  final String initialImageUrl;
  final List<Map<String, dynamic>> initialSizes;
  final List<int> initialAddOnIds;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> globalAddOns;
  final void Function(String name, String desc, String label, bool available, int catId, String imageUrl, List<Map<String, dynamic>> sizes, List<int> addOnIds) onSave;
  final VoidCallback? onDelete;
  final int Function(String catName) onAddCategory;

  const _MenuItemFormSheet({
    required this.title,
    required this.initialName,
    required this.initialDescription,
    required this.initialLabel,
    required this.initialAvailable,
    required this.initialCategoryId,
    required this.initialImageUrl,
    required this.initialSizes,
    required this.initialAddOnIds,
    required this.categories,
    required this.globalAddOns,
    required this.onSave,
    this.onDelete,
    required this.onAddCategory,
  });

  @override
  State<_MenuItemFormSheet> createState() => _MenuItemFormSheetState();
}

class _MenuItemFormSheetState extends State<_MenuItemFormSheet> {
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _imageUrlCtrl;
  late TextEditingController _newCatCtrl;
  late bool _available;
  late int _catId;
  late String _label;
  late List<Map<String, dynamic>> _sizes;
  late List<int> _selectedAddOnIds;
  Uint8List? _imageData;

  static const _labelOptions = ['', 'BEST SELLER', 'NEW', 'POPULAR'];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _descCtrl = TextEditingController(text: widget.initialDescription);
    _imageUrlCtrl = TextEditingController(text: widget.initialImageUrl);
    _newCatCtrl = TextEditingController();
    _available = widget.initialAvailable;
    _catId = widget.initialCategoryId;
    _label = widget.initialLabel;
    _sizes = widget.initialSizes.map((s) => Map<String, dynamic>.from(s)).toList();
    _selectedAddOnIds = List<int>.from(widget.initialAddOnIds);
    _imageData = decodeBase64Image(widget.initialImageUrl);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _imageUrlCtrl.dispose();
    _newCatCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result != null && result.files.single.bytes != null) {
        final file = result.files.single;
        final ext = file.extension ?? 'png';
        setState(() {
          _imageData = file.bytes;
          _imageUrlCtrl.text = encodeImageToDataUri(file.bytes!, ext);
        });
      }
    } catch (_) {
      _showImagePickFallback();
    }
  }

  void _showImagePickFallback() {
    final pathCtrl = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
        title: Text('Add Image', style: TextStyle(color: textColor)),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'File picker is unavailable on this platform.\nEnter a URL to a hosted image:',
                  style: TextStyle(color: textColor, fontSize: 13),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: pathCtrl,
                  decoration: const InputDecoration(
                    hintText: 'https://example.com/image.png',
                    labelText: 'Image URL',
                  ),
                  style: TextStyle(color: textColor, fontSize: 14),
                ),
              ],
            ),
          ),
          actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              final input = pathCtrl.text.trim();
              if (input.isEmpty) return;
              final scaffold = ScaffoldMessenger.of(context);
              final nav = Navigator.of(ctx);
              try {
                Uint8List? bytes;
                final httpClient = http.Client();
                try {
                  final response = await httpClient.get(Uri.parse(input));
                  if (response.statusCode == 200) {
                    bytes = response.bodyBytes;
                  }
                } finally {
                  httpClient.close();
                }
                if (bytes != null) {
                  final ext = input.split('.').last.toLowerCase();
                  final validExt = ['png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp'];
                  final finalExt = validExt.contains(ext) ? ext : 'png';
                  if (mounted) {
                    setState(() {
                      _imageData = bytes;
                      _imageUrlCtrl.text = encodeImageToDataUri(bytes!, finalExt);
                    });
                    nav.pop();
                  }
                } else {
                  scaffold.showSnackBar(
                    const SnackBar(content: Text('Could not load image from that path/URL')),
                  );
                }
              } catch (_) {
                scaffold.showSnackBar(
                  const SnackBar(content: Text('Failed to load image')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: primaryColor),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearImage() {
    setState(() {
      _imageData = null;
      _imageUrlCtrl.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final bgSurface = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: textMuted.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700,
                    letterSpacing: 1.5, color: textColor,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameCtrl,
                  decoration: _inputDecoration('Item Name', 'e.g. Spanish Latte', textMuted, bgSurface, borderColor, primaryColor),
                  style: TextStyle(color: textColor, fontSize: 14),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _descCtrl,
                  decoration: _inputDecoration('Description', 'Brief description', textMuted, bgSurface, borderColor, primaryColor),
                  style: TextStyle(color: textColor, fontSize: 14),
                  maxLines: 2,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text('IMAGE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textMuted, letterSpacing: 0.5)),
                    ),
                    if (_imageData != null)
                      GestureDetector(
                        onTap: _pickImage,
                        child: Text('Change', style: TextStyle(fontSize: 11, color: primaryColor, fontWeight: FontWeight.w600)),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_imageData != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        Image.memory(
                          _imageData!,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            height: 120,
                            decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(8)),
                            child: Center(child: Text('Invalid image', style: TextStyle(color: textMuted, fontSize: 12))),
                          ),
                        ),
                        Positioned(
                          top: 4, right: 4,
                          child: GestureDetector(
                            onTap: _clearImage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Icon(Icons.close, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: bgSurface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor, style: BorderStyle.solid),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, size: 28, color: textMuted),
                            const SizedBox(height: 6),
                            Text('Tap to add image', style: TextStyle(fontSize: 12, color: textMuted)),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('LABEL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textMuted, letterSpacing: 0.5)),
                    const SizedBox(height: 8),
                    Row(
                      children: _labelOptions.map((opt) {
                        final isSelected = _label == opt;
                        final display = opt.isEmpty ? 'NONE' : opt;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: opt == _labelOptions.last ? 0 : 8),
                            child: GestureDetector(
                              onTap: () => setState(() => _label = opt),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? primaryColor.withValues(alpha: 0.15) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: isSelected ? primaryColor : borderColor, width: isSelected ? 2 : 1),
                                ),
                                child: Text(display, textAlign: TextAlign.center, style: TextStyle(
                                  fontSize: 11, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected ? primaryColor : textMuted, letterSpacing: 0.5,
                                )),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CATEGORY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textMuted, letterSpacing: 0.5)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(color: bgSurface, borderRadius: BorderRadius.circular(8), border: Border.all(color: borderColor)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: _catId, isExpanded: true, dropdownColor: bgSurface,
                                style: TextStyle(color: textColor, fontSize: 14),
                                items: [
                                  ...widget.categories.map((c) => DropdownMenuItem<int>(
                                    value: c['id'] as int, child: Text((c['name'] as String).toUpperCase()),
                                  )),
                                  DropdownMenuItem<int>(
                                    value: -1,
                                    child: Row(
                                      children: [
                                        Icon(Icons.add, size: 16, color: primaryColor),
                                        const SizedBox(width: 6),
                                        Text('ADD CATEGORY', style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v == null) return;
                                  if (v == -1) {
                                    _showAddCategoryDialog();
                                  } else {
                                    setState(() => _catId = v);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AVAILABLE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textMuted, letterSpacing: 0.5)),
                        const SizedBox(height: 4),
                        Switch(
                          value: _available,
                          onChanged: (v) => setState(() => _available = v),
                          activeThumbColor: Colors.green,
                          activeTrackColor: Colors.green.withValues(alpha: 0.2),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionHeader('SIZES', textMuted, primaryColor, bgSurface, borderColor),
                const SizedBox(height: 8),
                ..._sizes.asMap().entries.map((entry) {
                  final i = entry.key;
                  final s = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _sizeAddOnField(s, 'name', 'Size', textMuted, bgSurface, borderColor, primaryColor, textColor, () {
                            setState(() => _sizes.removeAt(i));
                          }),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: _priceField(s, 'price', textMuted, bgSurface, borderColor, primaryColor, textColor),
                        ),
                      ],
                    ),
                  );
                }),
                _addButton('Add Size', primaryColor, bgSurface, borderColor, textMuted, () {
                  setState(() => _sizes.add({'name': '', 'price': 0.0}));
                }),
                const SizedBox(height: 20),
                _buildSectionHeader('ADD-ONS (select from global pool)', textMuted, primaryColor, bgSurface, borderColor),
                const SizedBox(height: 8),
                ...widget.globalAddOns.where((a) => a['isAvailable'] as bool).map((a) {
                  final id = a['id'] as int;
                  final checked = _selectedAddOnIds.contains(id);
                  return CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    value: checked,
                    title: Text('${a['name']} — Php ${(a['price'] as num).toStringAsFixed(0)}', style: TextStyle(fontSize: 13, color: textColor)),
                    onChanged: (_) {
                      setState(() {
                        if (checked) {
                          _selectedAddOnIds.remove(id);
                        } else {
                          _selectedAddOnIds.add(id);
                        }
                      });
                    },
                    activeColor: primaryColor,
                    checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  );
                }),
                if (widget.globalAddOns.where((a) => a['isAvailable'] as bool).isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('No available add-ons. Manage them in the Add-ons section.', style: TextStyle(fontSize: 11, color: textMuted, fontStyle: FontStyle.italic)),
                  ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (widget.onDelete != null) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () { Navigator.of(context).pop(); widget.onDelete!(); },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.3)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('DELETE', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1)),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: widget.onDelete != null ? 1 : 2,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_nameCtrl.text.trim().isEmpty) return;
                          widget.onSave(
                            _nameCtrl.text.trim(),
                            _descCtrl.text.trim(),
                            _label,
                            _available,
                            _catId,
                            _imageUrlCtrl.text.trim(),
                            _sizes.where((s) => (s['name'] as String).trim().isNotEmpty).toList(),
                            _selectedAddOnIds,
                          );
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: isDark ? const Color(0xFF0F1115) : Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('SAVE', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
        title: Text('New Category', style: TextStyle(color: Theme.of(ctx).brightness == Brightness.dark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A))),
        content: TextField(
          controller: _newCatCtrl,
          autofocus: true,
          decoration: InputDecoration(hintText: 'Category name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              final name = _newCatCtrl.text.trim();
              if (name.isEmpty) return;
              final newId = widget.onAddCategory(name.toLowerCase());
              setState(() => _catId = newId);
              _newCatCtrl.clear();
              Navigator.of(ctx).pop();
            },
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String label, Color textMuted, Color primaryColor, Color bgSurface, Color borderColor) {
    return Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textMuted, letterSpacing: 1));
  }

  Widget _sizeAddOnField(Map<String, dynamic> map, String key, String hint, Color textMuted, Color bgSurface, Color borderColor, Color primaryColor, Color textColor, VoidCallback onRemove) {
    return TextField(
      controller: TextEditingController(text: map[key] as String? ?? '')
        ..selection = TextSelection.collapsed(offset: (map[key] as String? ?? '').length),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5), fontSize: 13),
        filled: true, fillColor: bgSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryColor, width: 2)),
        suffixIcon: IconButton(
          icon: Icon(Icons.close, size: 16, color: Colors.redAccent),
          onPressed: onRemove,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
      style: TextStyle(color: textColor, fontSize: 13),
      onChanged: (v) => map[key] = v,
    );
  }

  Widget _priceField(Map<String, dynamic> map, String key, Color textMuted, Color bgSurface, Color borderColor, Color primaryColor, Color textColor) {
    return TextField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controller: TextEditingController(text: (map[key] as num?)?.toString() ?? '0')
        ..selection = TextSelection.collapsed(offset: ((map[key] as num?)?.toString() ?? '0').length),
      decoration: InputDecoration(
        prefixText: 'Php ',
        prefixStyle: TextStyle(color: textMuted, fontSize: 13),
        hintText: '0',
        hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5), fontSize: 13),
        filled: true, fillColor: bgSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryColor, width: 2)),
      ),
      style: TextStyle(color: textColor, fontSize: 13),
      onChanged: (v) => map[key] = double.tryParse(v) ?? 0.0,
    );
  }

  Widget _addButton(String label, Color primaryColor, Color bgSurface, Color borderColor, Color textMuted, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: primaryColor.withValues(alpha: 0.2), style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 14, color: primaryColor),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: primaryColor)),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint, Color textMuted, Color bgSurface, Color borderColor, Color primaryColor) {
    return InputDecoration(
      labelText: label, hintText: hint,
      labelStyle: TextStyle(color: textMuted, fontSize: 13),
      hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5), fontSize: 13),
      filled: true, fillColor: bgSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryColor, width: 2)),
    );
  }
}
