import 'package:flutter/material.dart';
import 'package:foody/features/Comment/models/models.dart';
import 'package:foody/features/Comment/service/comment_service.dart';

class CommentController extends ChangeNotifier {
  final CommentService _commentService = CommentService();
  List<Comment> _comments = [];

  List<Comment> get comments => _comments;

  Future<void> loadComments(String recipeId) async {
    _comments = await _commentService.fetchComments(recipeId);
    notifyListeners();
  }

  Future<void> addComment(Comment comment) async {
    await _commentService.addComment(comment);
    _comments.add(comment);
    notifyListeners();
  }

  Future<void> deleteComment(String commentId) async {
    await _commentService.deleteComment(commentId);
    _comments.removeWhere((comment) => comment.id == commentId);
    notifyListeners();
  }
}
