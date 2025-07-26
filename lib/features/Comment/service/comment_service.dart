import 'package:foody/data/repositories/mongodb_helper.dart';
import 'package:foody/features/Comment/models/models.dart';
import 'package:foody/features/profile/controllers/profile_controllers.dart';
import 'package:uuid/uuid.dart';

class CommentService {
  final ProfileController _profileController =
      ProfileController(); // Instancia del controlador de perfil

  Future<void> addComment(Comment comment) async {
    try {
      final collection = MongoDBHelper.db.collection('comments');
      final commentMap = comment.toMap();

      // Ensure unique ID
      if (commentMap['_id'] == null || commentMap['_id'].isEmpty) {
        commentMap['_id'] = const Uuid().v4();
      }

      // Ensure the comment is tied to a recipe
      if (commentMap['recipeId'] == null || commentMap['recipeId'].isEmpty) {
        throw Exception('El comentario debe estar asociado a una receta.');
      }

      await collection.insert(commentMap);
      print('Comentario agregado con éxito.');
    } catch (e) {
      print('Error al agregar el comentario: $e');
      rethrow;
    }
  }

  Future<List<Comment>> fetchComments(String recipeId) async {
    try {
      final collection = MongoDBHelper.db.collection('comments');
      final comments = await collection.find({'recipeId': recipeId}).toList();
      return comments.map((data) => Comment.fromMap(data)).toList();
    } catch (e) {
      print('Error al obtener comentarios: $e');
      rethrow;
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      final collection = MongoDBHelper.db.collection('comments');
      await collection.remove({'_id': commentId});
      print('Comentario eliminado con éxito.');
    } catch (e) {
      print('Error al eliminar el comentario: $e');
      rethrow;
    }
  }

  Future<double> calculateAverageRating(String recipeId) async {
    try {
      final collection = MongoDBHelper.db.collection('comments');
      final comments = await collection.find({'recipeId': recipeId}).toList();
      if (comments.isEmpty) return 0.0;

      final totalRating = comments.fold<double>(
        0.0,
        (sum, comment) => sum + (comment['rating'] as double),
      );
      return totalRating / comments.length;
    } catch (e) {
      print('Error al calcular el promedio de rating: $e');
      rethrow;
    }
  }
}
