import 'package:flutter/material.dart';

class ItemCard extends StatefulWidget {
  final String imageUrl;
  final String itemName;
  final String itemLabel;
  final String itemDescription;
  final List<Map<String, dynamic>> availableSizes;
  final List<Map<String, dynamic>> availableAddOns;

  const ItemCard({
    super.key,
    required this.imageUrl,
    required this.itemName,
    required this.itemLabel,
    required this.itemDescription,
    required this.availableSizes,
    required this.availableAddOns,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  late String _selectedSize;
  int _quantity = 1;

  // Add-ons tracking
  late Map<String, bool> _addOns;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.availableSizes.isNotEmpty
        ? widget.availableSizes[0]['name'] as String
        : '';
    _addOns = {
      for (var addOn in widget.availableAddOns)
        '${addOn['name']} (Php ${(addOn['price'] as num).toStringAsFixed(2)})': false,
    };
  }

  void _increment() {
    setState(() => _quantity++);
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  double get _totalPrice {
    final sizeMap = widget.availableSizes.firstWhere(
      (s) => s['name'] == _selectedSize,
      orElse: () => {'price': 0.0},
    );
    double base = (sizeMap['price'] as num).toDouble();

    double addOnsTotal = 0.0;
    _addOns.forEach((key, isSelected) {
      if (isSelected) {
        final name = key.split(' (')[0];
        final addOnMap = widget.availableAddOns.firstWhere(
          (a) => a['name'] == name,
          orElse: () => {'price': 0.0},
        );
        addOnsTotal += (addOnMap['price'] as num).toDouble();
      }
    });
    return (base + addOnsTotal) * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    // Determine colors based on Theme
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF171A21) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;
    final textColor = isDark
        ? const Color(0xFFE2E8F0)
        : const Color(0xFF0F172A);
    final textMuted = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final primaryColor = isDark
        ? const Color(0xFF93C5FD)
        : const Color(0xFF3B82F6);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive values
        double cardWidth = constraints.maxWidth;
        if (cardWidth > 370) cardWidth = 370;

        bool isCompact = cardWidth < 340;

        double imgHeight = isCompact ? 130 : 200;
        double paddingOffset = isCompact ? 16.0 : 24.0;
        double headerFontSize = isCompact ? 16 : 20;
        double priceFontSize = isCompact ? 15 : 18;
        double subFontSize = isCompact ? 11 : 13;
        double defaultFontSize = isCompact ? 12 : 14;

        return Container(
          constraints: const BoxConstraints(maxWidth: 370),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image Section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: widget.imageUrl.isNotEmpty
                        ? Image.network(
                            widget.imageUrl,
                            width: double.infinity,
                            height: imgHeight,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              height: imgHeight,
                              width: double.infinity,
                              color: isDark
                                  ? const Color(0xFF222730)
                                  : Colors.grey.shade200,
                              child: Icon(
                                Icons.image,
                                size: isCompact ? 48 : 64,
                                color: textMuted,
                              ),
                            ),
                          )
                        : Container(
                            height: imgHeight,
                            width: double.infinity,
                            color: isDark
                                ? const Color(0xFF222730)
                                : Colors.grey.shade200,
                            child: Icon(
                              Icons.local_cafe,
                              size: isCompact ? 48 : 64,
                              color: textMuted,
                            ),
                          ),
                  ),
                  if (widget.itemLabel.isNotEmpty)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.itemLabel.toUpperCase(),
                          style: TextStyle(
                            fontSize: isCompact ? 9 : 10,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? const Color(0xFF0F1115)
                                : Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              Padding(
                padding: EdgeInsets.all(paddingOffset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.itemName,
                            style: TextStyle(
                              fontSize: headerFontSize,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                        Text(
                          'Php ${_totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: priceFontSize,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.itemDescription,
                      style: TextStyle(fontSize: subFontSize, color: textMuted),
                    ),

                    SizedBox(height: isCompact ? 16 : 24),

                    // Size Choices
                    if (widget.availableSizes.isNotEmpty) ...[
                      Text(
                        'Size',
                        style: TextStyle(
                          fontSize: defaultFontSize,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: isCompact ? 8 : 12),
                      
                      // Clean 2-column implementation using an adaptive, non-scrollable GridView
                      GridView.count(
                        shrinkWrap: true,                  // Forces grid to only take up needed vertical space
                        physics: const NeverScrollableScrollPhysics(), // Prevents nested scrolling conflict inside sidebars/scroll views
                        crossAxisCount: 2,                 // Enforces exactly 2 columns
                        crossAxisSpacing: 12,              // Horizontal spacing between cards
                        mainAxisSpacing: 12,               // Vertical spacing between rows
                        childAspectRatio: isCompact ? 2.5 : 2.0, // Adjusts height-to-width ratio of the cards to match your minimalist styling
                        children: widget.availableSizes.map((size) {
                          final name = size['name'] as String;
                          final price = (size['price'] as num).toStringAsFixed(2);
                          
                          return _buildSizeOption(
                            name,
                            'Php $price',
                            primaryColor,
                            borderColor,
                            textColor,
                            isCompact,
                          );
                        }).toList(),
                      ),
                      
                      SizedBox(height: isCompact ? 16 : 24),
                    ],

                    // Add-ons
                    if (widget.availableAddOns.isNotEmpty) ...[
                      Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          iconColor: textColor,
                          collapsedIconColor: textColor,
                          title: Align(
                            alignment: Alignment.centerLeft, // Forces header text left
                            child: Text(
                              'Add-ons',
                              style: TextStyle(
                                fontSize: defaultFontSize,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                          children: [
                            // Alignment wrapper forces the entire child dropdown block to left-align
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // Left-align elements inside column
                                mainAxisSize: MainAxisSize.min,
                                children: _addOns.keys.map((key) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _addOns[key] = !(_addOns[key] ?? false);
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6.0), // Cleaner vertical touch target
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min, // Keeps row width tight against contents
                                        children: [
                                          SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Checkbox(
                                              value: _addOns[key],
                                              activeColor: primaryColor,
                                              checkColor: isDark ? bgColor : Colors.white,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  _addOns[key] = value ?? false;
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 12), // Slightly increased spacing for cleaner typography
                                          Flexible(
                                            child: Text(
                                              key,
                                              style: TextStyle(
                                                fontSize: subFontSize,
                                                color: textColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isCompact ? 16 : 24),
                    ],

                    // Bottom Actions: Quantity and Add to Order
                    Row(
                      children: [
                        // Quantity
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  size: isCompact ? 16 : 18,
                                ),
                                color: textMuted,
                                onPressed: _decrement,
                                padding: EdgeInsets.all(isCompact ? 4 : 8),
                                constraints:
                                    const BoxConstraints(), // tightens spacing
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isCompact ? 4.0 : 8.0,
                                ),
                                child: Text(
                                  '$_quantity',
                                  style: TextStyle(
                                    fontSize: defaultFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  size: isCompact ? 16 : 18,
                                ),
                                color: textColor,
                                onPressed: _increment,
                                padding: EdgeInsets.all(isCompact ? 4 : 8),
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: isCompact ? 12 : 16),

                        // Add to Order Button
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: isDark
                                  ? const Color(0xFF0F1115)
                                  : Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: isCompact ? 12 : 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              'Add to Order',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isCompact ? 12 : 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSizeOption(
    String title,
    String subtitle,
    Color primaryColor,
    Color borderColor,
    Color textColor,
    bool isCompact,
  ) {
    bool isSelected = _selectedSize == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedSize = title),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isCompact ? 8.0 : 12.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? primaryColor : borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isCompact ? 12 : 14,
                color: isSelected ? primaryColor : textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: isCompact ? 10 : 12,
                color: isSelected ? primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
