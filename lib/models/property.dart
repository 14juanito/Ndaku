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
    this.subtitle,
    this.listingLabel,
    this.priceSuffix,
    this.rating,
    this.surfaceM2,
    this.rooms,
    this.bathrooms,
    this.builtYear,
    this.livingRooms,
    this.parkingSpots,
    this.agentName,
    this.agentRole,
    this.agentAvatar,
    this.reviewCount,
    this.reviewAuthor,
    this.reviewAvatar,
    this.reviewText,
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
  final String? subtitle;
  final String? listingLabel;
  final String? priceSuffix;
  final double? rating;
  final double? surfaceM2;
  final int? rooms;
  final int? bathrooms;
  final int? builtYear;
  final int? livingRooms;
  final int? parkingSpots;
  final String? agentName;
  final String? agentRole;
  final String? agentAvatar;
  final int? reviewCount;
  final String? reviewAuthor;
  final String? reviewAvatar;
  final String? reviewText;
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
    String? subtitle,
    String? listingLabel,
    String? priceSuffix,
    double? rating,
    double? surfaceM2,
    int? rooms,
    int? bathrooms,
    int? builtYear,
    int? livingRooms,
    int? parkingSpots,
    String? agentName,
    String? agentRole,
    String? agentAvatar,
    int? reviewCount,
    String? reviewAuthor,
    String? reviewAvatar,
    String? reviewText,
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
      subtitle: subtitle ?? this.subtitle,
      listingLabel: listingLabel ?? this.listingLabel,
      priceSuffix: priceSuffix ?? this.priceSuffix,
      rating: rating ?? this.rating,
      surfaceM2: surfaceM2 ?? this.surfaceM2,
      rooms: rooms ?? this.rooms,
      bathrooms: bathrooms ?? this.bathrooms,
      builtYear: builtYear ?? this.builtYear,
      livingRooms: livingRooms ?? this.livingRooms,
      parkingSpots: parkingSpots ?? this.parkingSpots,
      agentName: agentName ?? this.agentName,
      agentRole: agentRole ?? this.agentRole,
      agentAvatar: agentAvatar ?? this.agentAvatar,
      reviewCount: reviewCount ?? this.reviewCount,
      reviewAuthor: reviewAuthor ?? this.reviewAuthor,
      reviewAvatar: reviewAvatar ?? this.reviewAvatar,
      reviewText: reviewText ?? this.reviewText,
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
      'subtitle': subtitle,
      'listingLabel': listingLabel,
      'priceSuffix': priceSuffix,
      'rating': rating,
      'surfaceM2': surfaceM2,
      'rooms': rooms,
      'bathrooms': bathrooms,
      'builtYear': builtYear,
      'livingRooms': livingRooms,
      'parkingSpots': parkingSpots,
      'agentName': agentName,
      'agentRole': agentRole,
      'agentAvatar': agentAvatar,
      'reviewCount': reviewCount,
      'reviewAuthor': reviewAuthor,
      'reviewAvatar': reviewAvatar,
      'reviewText': reviewText,
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
      subtitle: map['subtitle'] as String?,
      listingLabel: map['listingLabel'] as String?,
      priceSuffix: map['priceSuffix'] as String?,
      rating: (map['rating'] as num?)?.toDouble(),
      surfaceM2: (map['surfaceM2'] as num?)?.toDouble(),
      rooms: (map['rooms'] as num?)?.toInt(),
      bathrooms: (map['bathrooms'] as num?)?.toInt(),
      builtYear: (map['builtYear'] as num?)?.toInt(),
      livingRooms: (map['livingRooms'] as num?)?.toInt(),
      parkingSpots: (map['parkingSpots'] as num?)?.toInt(),
      agentName: map['agentName'] as String?,
      agentRole: map['agentRole'] as String?,
      agentAvatar: map['agentAvatar'] as String?,
      reviewCount: (map['reviewCount'] as num?)?.toInt(),
      reviewAuthor: map['reviewAuthor'] as String?,
      reviewAvatar: map['reviewAvatar'] as String?,
      reviewText: map['reviewText'] as String?,
      images: (map['images'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      isAvailable: (map['isAvailable'] as bool?) ?? true,
    );
  }

  String get heroImage => images.isNotEmpty ? images.first : '';
}
