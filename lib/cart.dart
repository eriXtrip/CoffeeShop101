import 'package:flutter/material.dart';

class CartItem {
  final String itemName;
  String sizeName;
  double sizePrice;
  List<String> addOnNames;
  double addOnsPrice;
  int quantity;
  List<Map<String, dynamic>> availableSizes;
  List<Map<String, dynamic>> availableAddOns;

  CartItem({
    required this.itemName,
    required this.sizeName,
    required this.sizePrice,
    required this.addOnNames,
    required this.addOnsPrice,
    this.quantity = 1,
    this.availableSizes = const [],
    this.availableAddOns = const [],
  });

  double get totalPrice => (sizePrice + addOnsPrice) * quantity;
}

class CartSheet extends StatelessWidget {
  final List<CartItem> items;
  final VoidCallback onClear;
  final ValueChanged<int> onIncrement;
  final ValueChanged<int> onDecrement;
  final ValueChanged<int>? onEdit;
  final VoidCallback? onCheckout;

  const CartSheet({
    super.key,
    required this.items,
    required this.onClear,
    required this.onIncrement,
    required this.onDecrement,
    this.onEdit,
    this.onCheckout,
  });

  double get _subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);


    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: textMuted.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'YOUR ORDER',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: textColor,
                ),
              ),
              if (items.isNotEmpty)
                TextButton(
                  onPressed: onClear,
                  child: Text('clear', style: TextStyle(color: textMuted, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 48, color: textMuted),
                  const SizedBox(height: 12),
                  Text('Your cart is empty', style: TextStyle(color: textMuted, fontSize: 14)),
                ],
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: onEdit != null ? () => onEdit!(index) : null,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.itemName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                    if (onEdit != null)
                                      Icon(Icons.edit, size: 12, color: textMuted),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.sizeName,
                                  style: TextStyle(fontSize: 12, color: textMuted),
                                ),
                                if (item.addOnNames.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      '+${item.addOnNames.join(', +')}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: textMuted,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Php ${item.totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove, size: 14),
                                  color: textMuted,
                                  onPressed: () => onDecrement(index),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    '${item.quantity}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add, size: 14),
                                  color: textMuted,
                                  onPressed: () => onIncrement(index),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          if (items.isNotEmpty) ...[
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: textColor,
                  ),
                ),
                Text(
                  'Php ${_subtotal.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: isDark ? const Color(0xFF0F1115) : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onCheckout,
                child: const Text(
                  'CHECKOUT',
                  style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.5),
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class EditCartSheet extends StatefulWidget {
  final CartItem item;
  final ValueChanged<CartItem> onUpdate;
  final VoidCallback onDelete;

  const EditCartSheet({
    super.key,
    required this.item,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<EditCartSheet> createState() => _EditCartSheetState();
}

class _EditCartSheetState extends State<EditCartSheet> {
  late String _selectedSize;
  late int _quantity;
  late Map<String, bool> _addOns;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.item.sizeName;
    _quantity = widget.item.quantity;
    _addOns = {
      for (var addOn in widget.item.availableAddOns)
        '${addOn['name']} (Php ${(addOn['price'] as num).toStringAsFixed(2)})':
            widget.item.addOnNames.contains(addOn['name']),
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final textMuted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: textMuted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'EDIT ${widget.item.itemName.toUpperCase()}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: textColor,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onDelete();
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (widget.item.availableSizes.isNotEmpty) ...[
            Text(
              'SIZE',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: widget.item.availableSizes.map((size) {
                final name = size['name'] as String;
                final price = (size['price'] as num).toStringAsFixed(2);
                final isSelected = _selectedSize == name;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSize = name),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: isSelected ? primaryColor : textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Php $price',
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? primaryColor : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],

          if (widget.item.availableAddOns.isNotEmpty) ...[
            Text(
              'ADD-ONS',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            ..._addOns.keys.map((key) {
              return InkWell(
                onTap: () {
                  setState(() => _addOns[key] = !(_addOns[key] ?? false));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _addOns[key],
                          activeColor: primaryColor,
                          checkColor: isDark
                              ? const Color(0xFF171A21)
                              : Colors.white,
                          onChanged: (bool? value) {
                            setState(() => _addOns[key] = value ?? false);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        key,
                        style: TextStyle(fontSize: 12, color: textColor),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
          ],

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'QUANTITY',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, size: 18),
                    color: textMuted,
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '$_quantity',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: 18),
                    color: textMuted,
                    onPressed: () => setState(() => _quantity++),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: isDark ? const Color(0xFF0F1115) : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                final names = <String>[];
                double addOnCost = 0;
                _addOns.forEach((key, isSelected) {
                  if (isSelected) {
                    final name = key.split(' (')[0];
                    final addOnMap = widget.item.availableAddOns.firstWhere(
                      (a) => a['name'] == name,
                      orElse: () => {'price': 0.0},
                    );
                    names.add(name);
                    addOnCost += (addOnMap['price'] as num).toDouble();
                  }
                });
                final sizePrice = widget.item.availableSizes.firstWhere(
                  (s) => s['name'] == _selectedSize,
                  orElse: () => {'price': 0.0},
                );
                widget.item.sizeName = _selectedSize;
                widget.item.sizePrice = (sizePrice['price'] as num).toDouble();
                widget.item.addOnNames = names;
                widget.item.addOnsPrice = addOnCost;
                widget.item.quantity = _quantity;
                widget.onUpdate(widget.item);
                Navigator.of(context).pop();
              },
              child: const Text(
                'UPDATE',
                style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
