class PropertyModel {
  final String ownerId;
  final String id;
  final String title;
  final String description;
  final double price;
  final List<String> imageBase64List; // multiple images support
  final String location;
  final String category;
  final List<String> amenities;

  PropertyModel({
   required this.ownerId,
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageBase64List,
    required this.location,
    required this.category,
    required this.amenities,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      ownerId: json['ownerId'],
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      imageBase64List: List<String>.from(json['imageBase64List']),
      location: json['location'],
      category: json['category'],
      amenities: List<String>.from(json['amenities'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {

    return {
      'ownerId': ownerId,
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageBase64List': imageBase64List,
      'location': location,
      'category': category,
      'amenities': amenities,
    };
  }
}
