class ProgramModel {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final int price;
  final DateTime? purchaseDate;

  ProgramModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.price,
    this.purchaseDate,
  });

  factory ProgramModel.fromMap(Map<String, dynamic> map) {
    return ProgramModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'],
      price: map['price'] ?? 0,
      purchaseDate: map['purchaseDate']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'purchaseDate': purchaseDate,
    };
  }
}