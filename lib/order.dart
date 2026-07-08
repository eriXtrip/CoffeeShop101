import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'cart.dart';

class Order {
  final String customerName;
  final List<CartItem> items;
  final String paymentMethod;
  final String note;
  final DateTime timestamp;
  String status;

  Order({
    required this.customerName,
    required this.items,
    required this.paymentMethod,
    this.note = '',
    DateTime? timestamp,
    this.status = 'pending',
  }) : timestamp = timestamp ?? DateTime.now();

  double get total =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'PENDING';
      case 'preparing':
        return 'PREPARING';
      case 'ready':
        return 'READY';
      case 'done':
        return 'DONE';
      default:
        return status.toUpperCase();
    }
  }
}

class CheckoutSheet extends StatefulWidget {
  final List<CartItem> cartItems;
  final double total;
  final ValueChanged<Order> onPlaceOrder;
  final Uint8List? qrImageData;

  const CheckoutSheet({
    super.key,
    required this.cartItems,
    required this.total,
    required this.onPlaceOrder,
    this.qrImageData,
  });

  @override
  State<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<CheckoutSheet> {
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  String _paymentMethod = 'cash';

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
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
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: textMuted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'CHECKOUT',
            style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700,
              letterSpacing: 2, color: textColor,
            ),
          ),
          const SizedBox(height: 20),

          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Customer Name',
              hintText: 'Enter your name',
              labelStyle: TextStyle(color: textMuted, fontSize: 13),
              hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5), fontSize: 13),
              filled: true,
              fillColor: bgSurface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
            ),
            style: TextStyle(color: textColor, fontSize: 14),
          ),
          const SizedBox(height: 20),

          Text(
            'PAYMENT METHOD',
            style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.bold, color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildPaymentOption('cash', Icons.money, 'Cash'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPaymentOption('gcash', Icons.qr_code, 'GCash'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (_paymentMethod == 'gcash') ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: bgSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  if (widget.qrImageData != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(widget.qrImageData!, height: 160, fit: BoxFit.contain),
                    )
                  else ...[
                    Icon(Icons.qr_code, size: 48, color: primaryColor),
                    const SizedBox(height: 8),
                    Text(
                      'Scan QR to Pay',
                      style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600, color: textColor,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  if (widget.qrImageData == null)
                    Text('No QR uploaded by admin', textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: textMuted)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Notes',
              hintText: 'Add a note to this order...',
              labelStyle: TextStyle(color: textMuted, fontSize: 13),
              hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5), fontSize: 13),
              filled: true,
              fillColor: bgSurface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
            ),
            style: TextStyle(color: textColor, fontSize: 14),
          ),
          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL',
                  style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700,
                    letterSpacing: 1, color: textColor,
                  ),
                ),
                Text(
                  'Php ${widget.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

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
                if (_nameController.text.trim().isEmpty) return;
                widget.onPlaceOrder(Order(
                  customerName: _nameController.text.trim(),
                  items: List.from(widget.cartItems),
                  paymentMethod: _paymentMethod,
                  note: _noteController.text.trim(),
                ));
                Navigator.of(context).pop();
              },
              child: const Text(
                'PLACE ORDER',
                style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String method, IconData icon, String label) {
    final isSelected = _paymentMethod == method;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final primaryColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    final borderColor = isDark ? const Color(0xFF1F242E) : Colors.grey.shade300;

    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = method),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
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
            Icon(icon, color: isSelected ? primaryColor : textColor, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? primaryColor : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminPanel extends StatelessWidget {
  final List<Order> orders;
  final ValueChanged<int> onAdvanceStatus;
  final VoidCallback onExitAdmin;

  const AdminPanel({
    super.key,
    required this.orders,
    required this.onAdvanceStatus,
    required this.onExitAdmin,
  });

  @override
  Widget build(BuildContext context) {
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
                'ORDER QUEUE',
                style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w700,
                  letterSpacing: 2, color: textColor,
                ),
              ),
              TextButton.icon(
                onPressed: onExitAdmin,
                icon: Icon(Icons.arrow_back, size: 16, color: textMuted),
                label: Text('Menu', style: TextStyle(color: textMuted, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (orders.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 48, color: textMuted),
                    const SizedBox(height: 12),
                    Text('No orders yet', style: TextStyle(color: textMuted, fontSize: 14)),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: orders.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final statusColors = {
                    'pending': Colors.orange,
                    'preparing': Colors.blue,
                    'ready': Colors.green,
                    'done': textMuted,
                  };
                  final statusColor = statusColors[order.status] ?? textMuted;

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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.customerName,
                              style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700, color: textColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                order.statusLabel,
                                style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold,
                                  color: statusColor, letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.paymentMethod.toUpperCase(),
                          style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '${item.quantity}x ${item.itemName} (${item.sizeName})',
                            style: TextStyle(fontSize: 13, color: textColor),
                          ),
                        )),
                        if (order.note.isNotEmpty) Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(order.note, style: TextStyle(fontSize: 12, color: textMuted, fontStyle: FontStyle.italic)),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Php ${order.total.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold, color: primaryColor,
                              ),
                            ),
                            if (order.status != 'done')
                              TextButton(
                                onPressed: () => onAdvanceStatus(index),
                                style: TextButton.styleFrom(
                                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  _nextStatusLabel(order.status),
                                  style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600, color: primaryColor,
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
            ),
        ],
      ),
    );
  }

  String _nextStatusLabel(String status) {
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
}

String nextOrderStatus(String current) {
  switch (current) {
    case 'pending':
      return 'preparing';
    case 'preparing':
      return 'ready';
    case 'ready':
      return 'done';
    default:
      return 'done';
  }
}