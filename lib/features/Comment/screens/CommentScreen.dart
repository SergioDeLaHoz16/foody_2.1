import 'package:flutter/material.dart';
import 'package:foody/features/Comment/models/models.dart';
import 'package:foody/features/recipes/services/recipe_service.dart';
import 'package:foody/features/profile/controllers/profile_controllers.dart';

class CommentScreen extends StatefulWidget {
  final String recipeId;
  final List<Comment> comments;

  const CommentScreen({
    super.key,
    required this.recipeId,
    required this.comments,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  final RecipeService _recipeService = RecipeService();
  final ProfileController _profileController =
      ProfileController(); // Instancia del controlador de perfil
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comentarios')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.comments.length,
              itemBuilder: (context, index) {
                final comment = widget.comments[index];
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.userName, // Mostrar el nombre del usuario
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(comment.content),
                    ],
                  ),
                  subtitle: Text('Rating: ${comment.rating}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    labelText: 'Añadir comentario',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Rating:'),
                    Slider(
                      value: _rating,
                      onChanged: (value) {
                        setState(() {
                          _rating = value;
                        });
                      },
                      min: 0,
                      max: 5,
                      divisions: 5,
                      label: _rating.toString(),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    final userProfile = _profileController.userProfile;
                    final userName = userProfile?.fullName ?? 'Usuario Anónimo';
                    final userId = userProfile?.fullName ?? 'unknown_user';
                    final newComment = Comment(
                      id: '',
                      recipeId: widget.recipeId,
                      userId: userId,
                      userName: userName,
                      content: _commentController.text,
                      rating: _rating,
                      createdAt: DateTime.now(),
                    );

                    try {
                      await _recipeService.addCommentToRecipe(
                        widget.recipeId,
                        newComment,
                      );

                      setState(() {
                        widget.comments.add(newComment);
                        _commentController.clear();
                        _rating = 0.0;
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al agregar el comentario: $e'),
                        ),
                      );
                    }
                  },
                  child: const Text('Añadir'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
