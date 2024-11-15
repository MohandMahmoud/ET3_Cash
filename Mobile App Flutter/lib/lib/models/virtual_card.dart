class VirtualCard {
  final int id; // Assuming there is an ID for the virtual card
  final String cardName;
  final double limit;
  final DateTime createdAt;

  VirtualCard({
    required this.id,
    required this.cardName,
    required this.limit,
    required this.createdAt,
  });

  factory VirtualCard.fromJson(Map<String, dynamic> json) {
    return VirtualCard(
      id: json['id'],
      cardName: json['card_name'],
      limit: double.parse(json['limit']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_name': cardName,
      'limit': limit,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
