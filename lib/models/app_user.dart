class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    this.fullName,
    this.phone,
    this.photoUrl,
  });

  final String id;
  final String email;
  final String? fullName;
  final String? phone;
  final String? photoUrl;

  AppUser copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? photoUrl,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
    };
  }

  factory AppUser.fromMap(String id, Map<String, dynamic> map) {
    return AppUser(
      id: id,
      email: (map['email'] as String?) ?? '',
      fullName: map['fullName'] as String?,
      phone: map['phone'] as String?,
      photoUrl: map['photoUrl'] as String?,
    );
  }
}
