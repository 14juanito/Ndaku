class Property {
  const Property({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.type,
    required this.commune,
    required this.city,
    required this.country,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.surfaceM2,
    this.rooms,
    this.bathrooms,
    this.images = const [],
    this.isAvailable = true,
  });

  final String id;
  final String ownerId;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String type;
  final String commune;
  final String city;
  final String country;
  final String address;
  final double latitude;
  final double longitude;
  final double? surfaceM2;
  final int? rooms;
  final int? bathrooms;
  final List<String> images;
  final bool isAvailable;

  Property copyWith({
    String? id,
    String? ownerId,
    String? title,
    String? description,
    double? price,
    String? currency,
    String? type,
    String? commune,
    String? city,
    String? country,
    String? address,
    double? latitude,
    double? longitude,
    double? surfaceM2,
    int? rooms,
    int? bathrooms,
    List<String>? images,
    bool? isAvailable,
  }) {
    return Property(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      type: type ?? this.type,
      commune: commune ?? this.commune,
      city: city ?? this.city,
      country: country ?? this.country,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      surfaceM2: surfaceM2 ?? this.surfaceM2,
      rooms: rooms ?? this.rooms,
      bathrooms: bathrooms ?? this.bathrooms,
      images: images ?? this.images,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'title': title,
      'description': description,
      'price': price,
      'currency': currency,
      'type': type,
      'commune': commune,
      'city': city,
      'country': country,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'surfaceM2': surfaceM2,
      'rooms': rooms,
      'bathrooms': bathrooms,
      'images': images,
      'isAvailable': isAvailable,
    };
  }

  factory Property.fromMap(String id, Map<String, dynamic> map) {
    return Property(
      id: id,
      ownerId: (map['ownerId'] as String?) ?? '',
      title: (map['title'] as String?) ?? '',
      description: (map['description'] as String?) ?? '',
      price: ((map['price'] as num?) ?? 0).toDouble(),
      currency: (map['currency'] as String?) ?? 'USD',
      type: (map['type'] as String?) ?? 'Maison',
      commune: (map['commune'] as String?) ?? '',
      city: (map['city'] as String?) ?? 'Kinshasa',
      country: (map['country'] as String?) ?? 'RDC',
      address: (map['address'] as String?) ?? '',
      latitude: ((map['latitude'] as num?) ?? 0).toDouble(),
      longitude: ((map['longitude'] as num?) ?? 0).toDouble(),
      surfaceM2: (map['surfaceM2'] as num?)?.toDouble(),
      rooms: map['rooms'] as int?,
      bathrooms: map['bathrooms'] as int?,
      images: (map['images'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      isAvailable: (map['isAvailable'] as bool?) ?? true,
    );
  }
}
