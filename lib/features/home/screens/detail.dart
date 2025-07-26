import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foody/features/Comment/models/models.dart';
import 'package:foody/features/recipes/services/recipe_service.dart';
import 'package:foody/features/profile/models/user_profile_model.dart';
import 'package:foody/features/profile/controllers/profile_controllers.dart';
import 'package:foody/features/auth/controllers/controllers.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';
import 'package:provider/provider.dart';
import 'package:foody/features/favorites/controllers/favorite_controller.dart';
import 'package:foody/features/favorites/services/favorite_service.dart';
import 'package:foody/features/inventory/services/inventory_service.dart';

extension DateTimeExtensions on DateTime {
  String getRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inMinutes < 1) {
      return 'Justo ahora';
    } else if (difference.inSeconds < 60) {
      return '${difference.inSeconds} s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} d';
    } else {
      return '${difference.inDays ~/ 7} sem';
    }
  }
}

class RecipeDetailPage extends StatefulWidget {
  final String recipeId;

  const RecipeDetailPage({super.key, required this.recipeId});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final RecipeService _recipeService = RecipeService();
  final FavoriteService _favoriteService = FavoriteService();
  final InventoryService _inventoryService = InventoryService(); // <-- Agregado
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0.0;
  late Future<Map<String, dynamic>> _recipeData;

  // Mapa para almacenar cantidades disponibles por ingrediente
  Map<String, num> _userIngredientsQuantities = {};

  @override
  void initState() {
    super.initState();
    _recipeData = _fetchRecipeData();
    // Cargar favoritos si hay usuario autenticado
    final userEmail = AuthController().user.correo ?? '';
    if (userEmail.isNotEmpty) {
      Future.microtask(() {
        final favCtrl = Provider.of<FavoriteController>(context, listen: false);
        favCtrl.loadFavorites(userEmail);
      });
      // Cargar inventario del usuario
      _loadUserInventory(userEmail);
    }
  }

  Future<void> _loadUserInventory(String userEmail) async {
    try {
      // Suponiendo que los productos tienen un campo createdBy con el correo del usuario
      final products = await _inventoryService.fetchProducts();
      final now = DateTime.now();
      // Filtrar productos del usuario y no vencidos
      final userProducts = products.where(
        (p) =>
            (p.createdBy == userEmail) &&
            (p.expiryDate.isAfter(now)),
      );
      // Sumar cantidades por nombre de producto
      final Map<String, num> ingredientQuantities = {};
      for (final p in userProducts) {
        final name = p.name.trim().toLowerCase();
        ingredientQuantities[name] =
            (ingredientQuantities[name] ?? 0) + (p.quantity ?? 0);
      }
      setState(() {
        _userIngredientsQuantities = ingredientQuantities;
      });
    } catch (e) {
      print('Error cargando inventario del usuario: $e');
    }
  }

  Future<Map<String, dynamic>> _fetchRecipeData() async {
    final recipe = await _recipeService.fetchRecipeById(widget.recipeId);
    final comments = await _recipeService.fetchComments(widget.recipeId);
    return {'recipe': recipe, 'comments': comments};
  }

  Future<UserProfile?> getUserProfileByEmail(String email) async {
    final controller = ProfileController();
    print('DEBUG: Buscando perfil para email: $email');
    await controller.loadUserProfile(email);
    if (controller.userProfile == null) {
      print('ERROR: No se encontró perfil para $email');
    } else {
      print('DEBUG: Perfil encontrado: ${controller.userProfile!.nombre}');
    }
    return controller.userProfile;
  }

  Future<void> _addComment(String content, double rating) async {
    // Obtener el email del usuario autenticado
    final userEmail = AuthController().user.correo ?? '';
    // Se carga el perfil del usuario
    final userProfile = await getUserProfileByEmail(userEmail);

    final newComment = Comment(
      id: '',
      recipeId: widget.recipeId,
      userId: userProfile?.cedula ?? 'unknown_user',
      userName:
          (userProfile != null && (userProfile.nombre ?? '').trim().isNotEmpty)
              ? '${userProfile.nombre ?? ''} ${userProfile.apellido ?? ''}'
                  .trim()
              : userProfile?.correo ?? 'Usuario Anónimo',
      content: content,
      rating: rating,
      createdAt: DateTime.now(),
      avatarUrl: userProfile?.avatarUrl,
    );

    await _recipeService.addCommentToRecipe(widget.recipeId, newComment);

    setState(() {
      _recipeData = _fetchRecipeData(); // Recargar los datos
      _commentController.clear();
      _rating = 0.0;
    });
  }

  Future<int> _getFavoritesCount(String recipeId) async {
    return await _favoriteService.getFavoritesCount(recipeId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final userEmail = AuthController().user.correo ?? '';
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _recipeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar la receta.'));
          }

          final recipe = snapshot.data!['recipe'];
          final comments = snapshot.data!['comments'] as List<Comment>;

          return Column(
            children: [
              // Imagen superior
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(18),
                    ),
                    child: Image.network(
                      recipe.imageUrl ?? 'assets/images/1.png',
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/1.png', // Imagen predeterminada
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor:
                          isDark ? CColors.darkContainer : CColors.light,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color:
                              isDark ? CColors.light : CColors.primaryTextColor,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  // Corazón de favorito arriba a la derecha
                  Positioned(
                    top: 40,
                    right: 16,
                    child: Consumer<FavoriteController>(
                      builder: (context, favCtrl, _) {
                        final isFav = favCtrl.isFavorite(recipe.id);
                        return IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey,
                            size: 32,
                          ),
                          onPressed: () {
                            favCtrl.toggleFavorite(userEmail, recipe.id);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Contenido inferior
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título y rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width *
                                    0.6, // Ajusta el ancho máximo
                                child: Text(
                                  recipe.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              FutureBuilder<UserProfile?>(
                                future: getUserProfileByEmail(recipe.createdBy),
                                builder: (context, userSnapshot) {
                                  if (userSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text(
                                      'Cargando autor...',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    );
                                  }
                                  if (userSnapshot.hasError ||
                                      userSnapshot.data == null) {
                                    return const Text(
                                      'Autor desconocido',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    );
                                  }
                                  // Mostrar nombre y apellido del autor
                                  final user = userSnapshot.data!;
                                  return Text(
                                    'By ${user.nombre} ${user.apellido}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange),
                              Text(recipe.averageRating.toStringAsFixed(1)),
                            ],
                          ),
                        ],
                      ),
                      // Mostrar cantidad de favoritos debajo del título
                      FutureBuilder<int>(
                        future: _getFavoritesCount(recipe.id),
                        builder: (context, favSnapshot) {
                          if (favSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 20,
                              child: Text('Cargando favoritos...'),
                            );
                          }
                          if (favSnapshot.hasError) {
                            return const SizedBox(
                              height: 20,
                              child: Text('Error al cargar favoritos'),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                              bottom: 8.0,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: isDark ? Colors.grey : Colors.red,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${favSnapshot.data ?? 0} favoritos',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStat(
                            Icons.schedule,
                            '${recipe.preparationTime.inMinutes} mins',
                          ),
                          _buildStat(
                            Icons.signal_cellular_alt,
                            recipe.difficulty,
                          ),
                          _buildStat(
                            Icons.local_fire_department,
                            '${recipe.calories} cal',
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Descripción
                      const Text(
                        'Descripción',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        recipe.description,
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.black,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Ingredientes
                      Row(
                        children: [
                          const Text(
                            'Ingredientes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${recipe.ingredients.length})',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Suponiendo que tienes un Map con las cantidades del usuario:
                      // final Map<String, num> userIngredientsQuantities = {...};
                      ...recipe.ingredients.map<Widget>((ingredient) {
                        final ingredientName = ingredient.name;
                        final ingredientQuantity = ingredient.quantity;
                        // Usar el mapa real de cantidades del usuario (ignorando vencidos)
                        final userQty =
                            _userIngredientsQuantities[ingredientName
                                .trim()
                                .toLowerCase()];

                        Color iconColor;
                        String statusText;
                        Color statusColor;

                        if (userQty != null &&
                            userQty >= (ingredientQuantity ?? 1)) {
                          iconColor = Colors.green;
                          statusText = 'Tienes';
                          statusColor = Colors.green;
                        } else if (userQty != null && userQty > 0) {
                          iconColor = Colors.orange;
                          statusText = 'Te falta';
                          statusColor = Colors.orange;
                        } else {
                          iconColor = Colors.red;
                          statusText = 'No tienes';
                          statusColor = Colors.red;
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                userQty != null &&
                                        userQty >= (ingredientQuantity ?? 1)
                                    ? Icons.check_circle
                                    : userQty != null && userQty > 0
                                    ? Icons.error
                                    : Icons.cancel,
                                size: 18,
                                color: iconColor,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '$ingredientName (${ingredientQuantity ?? "?"})'
                                  '${userQty != null ? " - Tienes: $userQty" : ""}',
                                  style: TextStyle(
                                    color: iconColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              Text(
                                statusText,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 20),

                      // Comentarios
                      // Center(
                      //   child: ElevatedButton(
                      //     onPressed:
                      //         () => _mostrarComentarios(context, comments),
                      //     child: const Text('Ver todos'),
                      //   ),
                      // ),
                      // const SizedBox(height: 16),

                      // Comentarios
                      const Text(
                        'Comentarios',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      ...comments.map((comment) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              backgroundImage:
                                  (comment.avatarUrl != null &&
                                          comment.avatarUrl!.isNotEmpty &&
                                          comment.avatarUrl!.startsWith('http'))
                                      ? NetworkImage(comment.avatarUrl!)
                                      : const AssetImage(
                                            'assets/icons/avatar.png',
                                          )
                                          as ImageProvider,
                              child:
                                  (comment.avatarUrl == null ||
                                          comment.avatarUrl!.isEmpty)
                                      ? Text(
                                        comment.userName.isNotEmpty
                                            ? comment.userName[0]
                                            : '?',
                                      )
                                      : null,
                            ),
                            contentPadding: const EdgeInsets.all(10),
                            title: Row(
                              children: [
                                Text(
                                  comment.userName.length > 15
                                      ? '${comment.userName.substring(0, 15)}...'
                                      : comment.userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(comment.createdAt.getRelativeTime()),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(comment.content),
                                const SizedBox(height: 4),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                    ),
                                    Text(comment.rating.toStringAsFixed(1)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      // Positioned(
                      //   left: 0,
                      //   right: 0,
                      //   bottom: 0,
                      //   child: Container(
                      //     padding: const EdgeInsets.all(16),
                      //     decoration: const BoxDecoration(
                      //       color: Colors.white,
                      //       border: Border(
                      //         top: BorderSide(color: Colors.grey, width: 0.5),
                      //       ),
                      //     ),
                      //     child: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         const Text(
                      //           'Añadir comentario',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: 16,
                      //           ),
                      //         ),
                      //         const SizedBox(height: 10),
                      //         TextField(
                      //           controller: _commentController,
                      //           decoration: const InputDecoration(
                      //             labelText: 'Escribe tu comentario aquí',
                      //             border: OutlineInputBorder(),
                      //           ),
                      //         ),
                      //         const SizedBox(height: 10),
                      //         Row(
                      //           children: [
                      //             const Text('Rating:'),
                      //             Expanded(
                      //               child: Slider(
                      //                 value: _rating,
                      //                 onChanged: (value) {
                      //                   setState(() {
                      //                     _rating = value;
                      //                   });
                      //                 },
                      //                 min: 0,
                      //                 max: 5,
                      //                 divisions: 5,
                      //                 label: _rating.toString(),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //         ElevatedButton(
                      //           onPressed: () {
                      //             if (_commentController.text.isNotEmpty) {
                      //               _addComment(
                      //                 _commentController.text,
                      //                 _rating,
                      //               );
                      //             }
                      //           },
                      //           style: ElevatedButton.styleFrom(
                      //             backgroundColor: Colors.green,
                      //           ),
                      //           child: const Text('Enviar'),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      // Container(
                      //   padding: const EdgeInsets.all(16),
                      //   decoration: const BoxDecoration(
                      //     color: Colors.white,
                      //     border: Border(
                      //       top: BorderSide(color: Colors.grey, width: 0.5),
                      //     ),
                      //   ),
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       const Text(
                      //         'Añadir comentario',
                      //         style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 16,
                      //         ),
                      //       ),
                      //       const SizedBox(height: 10),
                      //       TextField(
                      //         controller: _commentController,
                      //         decoration: const InputDecoration(
                      //           labelText: 'Escribe tu comentario aquí',
                      //           border: OutlineInputBorder(),
                      //         ),
                      //       ),
                      //       const SizedBox(height: 10),
                      //       Row(
                      //         children: [
                      //           const Text('Rating:'),
                      //           Expanded(
                      //             child: Slider(
                      //               value: _rating,
                      //               onChanged: (value) {
                      //                 setState(() {
                      //                   _rating = value;
                      //                 });
                      //               },
                      //               min: 0,
                      //               max: 5,
                      //               divisions: 5,
                      //               label: _rating.toString(),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       ElevatedButton(
                      //         onPressed: () {
                      //           if (_commentController.text.isNotEmpty) {
                      //             _addComment(_commentController.text, _rating);
                      //           }
                      //         },
                      //         style: ElevatedButton.styleFrom(
                      //           backgroundColor: Colors.green,
                      //         ),
                      //         child: const Text('Enviar'),
                      //       ),
                      //     },
                      //   ),
                      // ),
                      // const Text(
                      //   'Añadir comentario',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 16,
                      //   ),
                      // ),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? CColors.darkContainer : Colors.white,
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
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Escribe tu comentario aquí',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey.shade400,
                            ),
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                if (_commentController.text.isNotEmpty) {
                                  _addComment(_commentController.text, _rating);
                                }
                              },
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text('Calificación:'),
                          // Slider(
                          //   value: _rating,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _rating = value;
                          //     });
                          //   },
                          //   min: 0,
                          //   max: 5,
                          //   divisions: 5,
                          //   label: _rating.toString(),
                          // ),
                          RatingBar.builder(
                            initialRating: _rating,
                            minRating: 0,
                            maxRating: 5,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: const EdgeInsets.symmetric(
                              horizontal: 1.0,
                            ),
                            itemBuilder:
                                (context, _) =>
                                    const Icon(Icons.star, color: Colors.amber),
                            onRatingUpdate: (value) {
                              setState(() {
                                _rating = value;
                              });
                            },
                          ),
                          // IconButton(
                          //   onPressed: () {
                          //     if (_commentController.text.isNotEmpty) {
                          //       _addComment(_commentController.text, _rating);
                          //     }
                          //   },
                          //   icon: Icon(Icons.send, color: Colors.green),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStat(IconData icon, String value) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: isDark ? Colors.white : Colors.black),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.grey.shade400 : Colors.black,
          ),
        ),
      ],
    );
  }

  // void _mostrarComentarios(BuildContext context, List<Comment> comments) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     isScrollControlled: true,
  //     builder: (context) {
  //       return FractionallySizedBox(

  //         heightFactor: 0.85,

  //         builder: (context, scrollController) {
  //           return Container(
  //             padding: const EdgeInsets.all(16),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text(
  //                   'Comentarios',
  //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                 ),
  //                 const SizedBox(height: 16),
  //                 SizedBox(
  //                   height: MediaQuery.of(context).size.height * 0.6,
  //                   child: Column(
  //                     children: [
  //                       Expanded(
  //                         child: ListView.builder(
  //                           controller: scrollController,
  //                           itemCount: comments.length,
  //                           itemBuilder: (context, index) {
  //                             final comment = comments[index];
  //                             return Container(
  //                               margin: const EdgeInsets.symmetric(vertical: 8),
  //                               child: ListTile(
  //                                 leading: CircleAvatar(
  //                                   backgroundColor: Colors.grey[300],
  //                                   child: Text(comment.userName[0]),
  //                                 ),
  //                                 contentPadding: const EdgeInsets.all(10),
  //                                 title: Row(
  //                                   children: [
  //                                     Text(
  //                                       comment.userName,
  //                                       style: const TextStyle(
  //                                         fontWeight: FontWeight.bold,
  //                                       ),
  //                                     ),
  //                                     const SizedBox(width: 8),
  //                                     Text(comment.createdAt.getRelativeTime()),
  //                                   ],
  //                                 ),
  //                                 subtitle: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(comment.content),
  //                                     const SizedBox(height: 4),
  //                                     Row(
  //                                       children: [
  //                                         const Icon(
  //                                           Icons.star,
  //                                           color: Colors.orange,
  //                                         ),
  //                                         Text(
  //                                           comment.rating.toStringAsFixed(1),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                   child: Column(
  //                     children: [
  //                       const Text(
  //                         'Añadir comentario',
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10),
  //                       TextField(
  //                         controller: _commentController,
  //                         decoration: const InputDecoration(
  //                           labelText: 'Escribe tu comentario aquí',
  //                           border: OutlineInputBorder(),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10),
  //                       Row(
  //                         children: [
  //                           const Text('Rating:'),
  //                           Slider(
  //                             value: _rating,
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 _rating = value;
  //                               });
  //                             },
  //                             min: 0,
  //                             max: 5,
  //                             divisions: 5,
  //                             label: _rating.toString(),
  //                           ),
  //                         ],
  //                       ),
  //                       ElevatedButton(
  //                         onPressed: () {
  //                           if (_commentController.text.isNotEmpty) {
  //                             _addComment(_commentController.text, _rating);
  //                           }
  //                         },
  //                         child: const Text('Enviar'),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
}
