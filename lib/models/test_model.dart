class TestModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String duration;
  final List<String> includes;
  final bool isCombo;

  TestModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.includes,
    this.isCombo = false,
  });

  // Convert to Map for easier storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'includes': includes,
      'isCombo': isCombo,
    };
  }

  // Create from Map
  factory TestModel.fromMap(Map<String, dynamic> map) {
    return TestModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      duration: map['duration'],
      includes: List<String>.from(map['includes']),
      isCombo: map['isCombo'] ?? false,
    );
  }
}