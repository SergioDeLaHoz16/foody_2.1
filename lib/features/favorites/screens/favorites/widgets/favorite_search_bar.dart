import 'package:flutter/material.dart';
import 'package:foody/features/home/screens/search_screen.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';

class FavoriteSearchBar extends StatelessWidget {
  const FavoriteSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchScreen()),
        );
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isDark ? CColors.dark : CColors.lightContainer,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(color: Color.fromARGB(141, 0, 0, 0), blurRadius: 3),
          ],
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 9.0),
              child: Icon(Icons.search, color: Colors.grey),
            ),
            Text(
              'Buscar recetas, productos o usuarios.',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
