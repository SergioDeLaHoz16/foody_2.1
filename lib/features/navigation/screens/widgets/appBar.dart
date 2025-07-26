import 'package:flutter/material.dart';
import 'package:foody/features/inventory/models/models.dart';
import 'package:foody/features/navigation/screens/widgets/iconButtonBox.dart';
import 'package:foody/features/profile/screen/profile.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:foody/features/notifications/notifications_service.dart';
import 'package:foody/features/notifications/products_expiring_soon_page.dart';
import 'package:foody/providers/data_provider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final currentUser = dataProvider.currentUser;
    final myProducts =
        currentUser == null
            ? <Product>[]
            : dataProvider.products
                .where((p) => p.createdBy == currentUser.correo)
                .toList()
                .cast<Product>();

    // Productos próximos a caducar (<= 3 días)
    final expiringProducts =
        myProducts
            .where((p) => p.expiryDate.difference(DateTime.now()).inDays <= 3)
            .toList();
    final expiringCount = expiringProducts.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 20.0),
      child: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 16.0),
          child: IconButtonBox(
            imagePath:
                isDark ? 'assets/logos/logo3.png' : 'assets/logos/logo.png',
            onTap: () {},
          ),
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap:
                    () => THelperFunctions.navigateToScreen(
                      context,
                      ProfileScreen(),
                    ),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/logos/Ellipse 2.png'),
                ),
              ),
              const SizedBox(width: 16),
              Stack(
                children: [
                  IconButtonBox(
                    imagePath:
                        isDark
                            ? 'assets/logos/notification_dark.png'
                            : 'assets/logos/Frame.png',
                    onTap: () async {
                      await NotificationService.notifyExpiringProducts(
                        expiringProducts,
                        currentUser?.correo ?? '',
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => ProductsExpiringSoonPage(
                                products: expiringProducts,
                              ),
                        ),
                      );
                    },
                  ),
                  if (expiringCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          expiringCount.toString(),
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}
