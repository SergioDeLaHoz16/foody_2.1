import 'package:flutter/material.dart';
import 'package:foody/features/inventory/models/models.dart';
import 'package:foody/features/notifications/notifications_service.dart';
import 'package:foody/features/notifications/products_expiring_soon_page.dart';

class NotificationBellWidget extends StatefulWidget {
  final List<Product> userProducts;
  final String userEmail;

  const NotificationBellWidget({
    Key? key,
    required this.userProducts,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<NotificationBellWidget> createState() => _NotificationBellWidgetState();
}

class _NotificationBellWidgetState extends State<NotificationBellWidget> {
  bool _notified = false;

  List<Product> get _expiringProducts {
    final now = DateTime.now();
    return widget.userProducts
        .where((p) => p.expiryDate.difference(now).inDays <= 3)
        .toList();
  }

  int get _expiringCount => _expiringProducts.length;

  void _openExpiringProductsPage() async {
    await NotificationService.notifyExpiringProducts(
      widget.userProducts,
      widget.userEmail,
    );
    setState(() {
      _notified = true;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductsExpiringSoonPage(products: _expiringProducts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            _notified ? Icons.notifications_active : Icons.notifications_none,
            color: _notified ? Colors.orange : Colors.grey,
          ),
          tooltip: 'Ver productos próximos a caducar',
          onPressed: _openExpiringProductsPage,
        ),
        if (_expiringCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                _expiringCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
