class Comment {
  final String id;
  final String recipeId;
  final String userId;
  final String userName; // Nuevo campo
  final String content;
  final double rating;
  final DateTime createdAt;
  final String? avatarUrl;

  Comment({
    required this.id,
    required this.recipeId,
    required this.userId,
    required this.userName, // Nuevo campo
    required this.content,
    required this.rating,
    required this.createdAt,
    this.avatarUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'recipeId': recipeId,
      'userId': userId,
      'userName': userName, // Nuevo campo
      'content': content,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'avatarUrl': avatarUrl,
    };
  }

  
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['_id'] as String? ?? '',
      recipeId: map['recipeId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      userName: map['userName'] as String? ?? 'Anónimo',
      content: map['content'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      avatarUrl: map['avatarUrl'] as String?,
    );
  }
}