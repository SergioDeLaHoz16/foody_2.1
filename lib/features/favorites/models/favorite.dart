class Favorite {
  final String id;
  final String userEmail;
  final String recipeId;
  final DateTime createdAt;

  Favorite({
    required this.id,
    required this.userEmail,
    required this.recipeId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userEmail': userEmail,
      'recipeId': recipeId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['_id'] as String,
      userEmail: map['userEmail'] as String,
      recipeId: map['recipeId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
