class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String? photoURL;
  final double? weight;
  final double? height;
  final int credits;
  final DateTime? createdAt;
  final List<Map<String, dynamic>> purchasedPrograms;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.photoURL,
    this.weight,
    this.height,
    required this.credits,
    this.createdAt,
    this.purchasedPrograms = const [],
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      photoURL: map['photoURL'],
      weight: map['weight']?.toDouble(),
      height: map['height']?.toDouble(),
      credits: map['credits'] ?? 5000,
      createdAt: map['createdAt']?.toDate(),
      purchasedPrograms: List<Map<String, dynamic>>.from(map['purchasedPrograms'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'photoURL': photoURL,
      'weight': weight,
      'height': height,
      'credits': credits,
      'createdAt': createdAt,
      'purchasedPrograms': purchasedPrograms,
    };
  }

  String get fullName => '$firstName $lastName'.trim();
}