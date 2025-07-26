import 'package:flutter/material.dart';
import 'package:foody/features/follow/screens/profile_subscription_page.dart';
import 'package:foody/features/home/screens/detail.dart';
import 'package:foody/features/home/screens/product_detail_expiring.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:provider/provider.dart';
import 'package:foody/providers/data_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  String searchQuery = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final isDark = THelperFunctions.isDarkMode(context);
    final filteredRecipes =
        dataProvider.recipes
            .where(
              (recipe) =>
                  recipe.name.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList();

    final filteredProducts =
        dataProvider.products
            .where(
              (product) => product.name.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
            )
            .toList();

    final filteredUsers =
        dataProvider.users
            .where(
              (user) =>
                  user.nombre?.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ??
                  false,
            )
            .toList();

    return Container(
      color: isDark ? CColors.dark : CColors.light,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: isDark ? CColors.dark : CColors.light,
            iconTheme: IconThemeData(
              color: isDark ? Colors.white : Colors.black,
            ),
            elevation: 1,
            title: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(141, 0, 0, 0),
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Buscar recetas, productos o usuarios...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              labelColor: isDark ? Colors.white : CColors.dark,
              unselectedLabelColor:
                  isDark ? CColors.textCategory : CColors.textCategory,
              indicatorColor: Colors.green,
              tabs: const [
                Tab(text: 'Recetas'),
                Tab(text: 'Productos'),
                Tab(text: 'Usuarios'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildList(filteredRecipes, 'Recetas'),
              _buildList(filteredProducts, 'Productos'),
              _buildList(filteredUsers, 'Usuarios'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<dynamic> items, String type) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No se encontraron resultados.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              type == 'Usuarios'
                  ? (item.avatarUrl ?? 'https://via.placeholder.com/150')
                  : type == 'Productos'
                  ? (item.photoUrl ?? 'https://via.placeholder.com/150')
                  : (item.imageUrl ?? 'https://via.placeholder.com/150'),
            ),
          ),
          title: Text(
            type == 'Usuarios'
                ? '${item.nombre ?? ''} ${item.apellido ?? ''}'
                : item.name,
          ),
          subtitle:
              type == 'Usuarios'
                  ? Text(item.correo ?? 'Sin correo')
                  : type == 'Productos'
                  ? Text('Cantidad: ${item.quantity}')
                  : type == 'Recetas'
                  ? Text('Rating: ${item.averageRating.toStringAsFixed(1)}')
                  : null,
          onTap: () {
            if (type == 'Usuarios') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ProfileSubscriptionPage(
                        correo: item.correo,
                        nombre: item.nombre ?? '',
                        apellido: item.apellido ?? '',
                        avatarUrl:
                            item.avatarUrl ?? 'https://via.placeholder.com/150',
                      ),
                ),
              );
            } else if (type == 'Recetas') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailPage(recipeId: item.id),
                ),
              );
            } else if (type == 'Productos') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ProductDetailExpiringScreen(product: item),
                ),
              );
            }
          },
        );
      },
    );
  }
}
