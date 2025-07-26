class SubscriptionModel {
  final String userId;
  final String subscriberId;
  final DateTime subscribedAt;
  final String status; // "SUSCRITO" o "FREE"

  SubscriptionModel({
    required this.userId,
    required this.subscriberId,
    required this.subscribedAt,
    this.status = "FREE",
  });

  factory SubscriptionModel.fromMap(Map<String, dynamic> json) {
    return SubscriptionModel(
      userId: json['userId'],
      subscriberId: json['subscriberId'],
      subscribedAt: DateTime.parse(json['subscribedAt']),
      status: json['status'] ?? "FREE",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'subscriberId': subscriberId,
      'subscribedAt': subscribedAt.toIso8601String(),
      'status': status,
    };
  }
}
