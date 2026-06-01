import 'package:flutter/material.dart';
import 'item_card.dart';
import 'sidebar.dart';

void main() {
  runApp(const MyApp());
}

class AppColors {
  // Dark Theme
  static const bgMainDark = Color(0xFF0F1115);
  static const bgSurfaceDark = Color(0xFF171A21);
  static const textMainDark = Color(0xFFE2E8F0);
  static const textMutedDark = Color(0xFF94A3B8);
  static const primaryDark = Color(0xFF93C5FD);

  // Light Theme (Clean Minimalist Alternative to Brown)
  static const bgMainLight = Color(0xFFF8FAFC);
  static const bgSurfaceLight = Color(0xFFFFFFFF);
  static const textMainLight = Color(0xFF0F172A);
  static const textMutedLight = Color(0xFF64748B);
  static const primaryLight = Color(0xFF3B82F6);
}

class AppMenuData {
  // Mirrored directly from your 'categories' table
  static const List<Map<String, dynamic>> categories = [
    {'id': 1, 'name': 'coffee'},
    {'id': 2, 'name': 'non-coffee'},
    {'id': 3, 'name': 'pastries'},
  ];
}

class AppItemData {
  // Linked explicitly to categories via 'category_id'
  static const List<Map<String, dynamic>> items = [
    {
      'id': 1,
      'category_id': 1,
      'name': 'Spanish Latte',
      'label': 'BEST SELLER',
      'description': 'Signature espresso with sweet condensed milk.',
    },
    {
      'id': 2,
      'category_id': 1,
      'name': 'Iced Americano',
      'label': '',
      'description': 'Rich espresso shots topped with cold water and ice.',
    },
    {
      'id': 3,
      'category_id': 2,
      'name': 'Matcha Latte',
      'label': 'NEW',
      'description': 'Pure Japanese Uji matcha whisked with creamy milk.',
    },
    {
      'id': 4,
      'category_id': 3,
      'name': 'Butter Croissant',
      'label': '',
      'description': 'Flaky, golden, and layered with premium French butter.',
    },
  ];
}

class AppSizeData {
  // Stripped down into structural IDs and unformatted numeric values for mathematical operations
  static const List<Map<String, dynamic>> sizes = [
    {'id': 1, 'name': '16oz', 'price': 55.00},
    {'id': 2, 'name': '22oz', 'price': 95.00},
    {'id': 3, 'name': 'One Size', 'price': 110.00},
  ];
}

class AppAddOnsData {
  static const List<Map<String, dynamic>> addOns = [
    {'id': 1, 'name': 'Espresso Shot', 'price': 30.00},
    {'id': 2, 'name': 'Oat Milk Substitute', 'price': 40.00},
    {'id': 3, 'name': 'Caramel Drizzle', 'price': 15.00},
    {'id': 4, 'name': 'Vanilla Syrup', 'price': 15.00},
    {'id': 5, 'name': 'Sea Salt Cream', 'price': 20.00},
  ];
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Shop 101',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.bgMainLight,
        fontFamily: 'Courier',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgMainDark,
      ),
      home: HomePage(
        toggleTheme: toggleTheme,
        isDark: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const HomePage({super.key, required this.toggleTheme, required this.isDark});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isSidebarLeft = true;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 800;
    final isDark = widget.isDark;

    // Resolve color states elegantly
    final bgSidebar = isDark
        ? AppColors.bgSurfaceDark
        : AppColors.bgSurfaceLight;
    final bgContent = isDark ? AppColors.bgMainDark : AppColors.bgMainLight;
    final colorTextMain = isDark
        ? AppColors.textMainDark
        : AppColors.textMainLight;
    final colorTextMuted = isDark
        ? AppColors.textMutedDark
        : AppColors.textMutedLight;
    final colorPrimary = isDark
        ? AppColors.primaryDark
        : AppColors.primaryLight;

    // Create the Sidebar widget dynamically
    Widget sidebarWidget = Sidebar(
      selectedIndex: _selectedIndex,
      onCategorySelected: (index) {
        setState(() => _selectedIndex = index);
        if (isSmallScreen) {
          Navigator.of(context).pop(); // Close drawer on selection
        }
      },
      isSidebarLeft: _isSidebarLeft,
      onSidebarLeftChanged: (val) => setState(() => _isSidebarLeft = val),
      isDark: isDark,
      toggleTheme: widget.toggleTheme,
    );

    Widget mainContent = Expanded(
      child: Container(
        color: bgContent,
        child: Column(
          children: [
            // Top Bar
            Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 16.0),
      child: isSmallScreen
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Builder(
                      builder: (context) {
                        return IconButton(
                          icon: Icon(
                            _isSidebarLeft ? Icons.chevron_right : Icons.chevron_left,
                            color: colorTextMain,
                          ),
                          onPressed: () {
                            if (_isSidebarLeft) {
                              Scaffold.of(context).openDrawer();
                            } else {
                              Scaffold.of(context).openEndDrawer();
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      (AppMenuData.categories[_selectedIndex]['name'] as String).toUpperCase(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                        color: colorTextMain,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'search...',
                      hintStyle: TextStyle(
                        color: colorTextMuted,
                        fontSize: 13,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: colorTextMuted,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: bgSidebar,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: colorTextMain, fontSize: 14),
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Builder(
                      builder: (context) {
                        return IconButton(
                          icon: Icon(
                            _isSidebarLeft ? Icons.chevron_right : Icons.chevron_left,
                            color: colorTextMain,
                          ),
                          onPressed: () {
                            if (_isSidebarLeft) {
                              Scaffold.of(context).openDrawer();
                            } else {
                              Scaffold.of(context).openEndDrawer();
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      (AppMenuData.categories[_selectedIndex]['name'] as String).toUpperCase(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                        color: colorTextMain,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'search...',
                      hintStyle: TextStyle(
                        color: colorTextMuted,
                        fontSize: 13,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: colorTextMuted,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: bgSidebar,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: colorTextMain, fontSize: 14),
                  ),
                ),
              ],
            ),
    ),
            // Main scrollable area
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final currentCategory = AppMenuData.categories[_selectedIndex];
                  final categoryId = currentCategory['id'] as int;
                  final filteredItems = AppItemData.items
                      .where((item) => item['category_id'] == categoryId)
                      .toList();

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 32.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            constraints.maxHeight -
                            32.0, // Accounts for padding
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Wrap(
                            key: ValueKey<int>(_selectedIndex),
                            spacing: 24,
                            runSpacing: 24,
                            children: filteredItems.map((item) {
                              List<Map<String, dynamic>> sizes = [];
                              List<Map<String, dynamic>> addOns = [];

                              if (categoryId == 1 || categoryId == 2) {
                                // Coffee & Non-Coffee: 16oz (id 1) and 22oz (id 2) sizes
                                sizes = AppSizeData.sizes
                                    .where((s) => s['id'] == 1 || s['id'] == 2)
                                    .toList();
                                addOns = AppAddOnsData.addOns;
                              } else if (categoryId == 3) {
                                // Pastries: One Size (id 3) only, no add-ons
                                sizes = AppSizeData.sizes
                                    .where((s) => s['id'] == 3)
                                    .toList();
                                addOns = [];
                              }

                              return ItemCard(
                                key: ValueKey<int>(item['id'] as int),
                                imageUrl: '',
                                itemName: item['name'] as String,
                                itemLabel: item['label'] as String,
                                itemDescription: item['description'] as String,
                                availableSizes: sizes,
                                availableAddOns: addOns,
                              );
                            }).toList(),
                          ),
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
    );

    return Scaffold(
      drawer: isSmallScreen && _isSidebarLeft ? Drawer(width: 260, elevation: 0, child: sidebarWidget) : null,
      endDrawer: isSmallScreen && !_isSidebarLeft ? Drawer(width: 260, elevation: 0, child: sidebarWidget) : null,
      body: Row(
        children: [
          if (!isSmallScreen && _isSidebarLeft) sidebarWidget,
          mainContent,
          if (!isSmallScreen && !_isSidebarLeft) sidebarWidget,
        ],
      ),
    );
  }
}
