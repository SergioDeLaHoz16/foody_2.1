import 'package:flutter/material.dart';
import 'package:foody/features/favorites/screens/favorites.dart';
import 'package:foody/features/home/screens/home.dart';
import 'package:foody/features/inventory/screens/inventory/inventory.dart';
import 'package:foody/features/settings/screens/settings_page.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const InventoryScreen(),
    CollectionScreen(),
    SettingsPage(), // Aquí usamos la SettingsPage real
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = THelperFunctions.isDarkMode(context);
    final Color backgroundColor = isDark ? CColors.dark : CColors.primaryColor;
    final Color iconColor = Colors.white;

    return Scaffold(
      body: _pages[_currentPageIndex],
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: backgroundColor,
        itemShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        currentIndex: _currentPageIndex,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home_outlined, color: iconColor, size: 32),
            title: const Text("Inicio"),
            selectedColor: iconColor,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.inventory_2_outlined, color: iconColor, size: 28),
            title: const Text('Inventario'),
            selectedColor: iconColor,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.bookmark_border, color: iconColor, size: 32),
            title: const Text('Colecciones'),
            selectedColor: iconColor,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.settings_outlined, color: iconColor, size: 32),
            title: const Text('Configuración'),
            selectedColor: iconColor,
          ),
        ],
      ),
    );
  }
}
