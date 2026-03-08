class Favorite {
  const Favorite({required this.propertyId, required this.addedAt});

  final String propertyId;
  final DateTime addedAt;

  Map<String, dynamic> toMap() {
    return {'propertyId': propertyId, 'addedAt': addedAt.toIso8601String()};
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    final rawDate = map['addedAt']?.toString();
    return Favorite(
      propertyId: (map['propertyId'] as String?) ?? '',
      addedAt: rawDate == null ? DateTime.now() : DateTime.parse(rawDate),
    );
  }
}
