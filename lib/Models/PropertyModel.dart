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
  final double latitude; // Latitude for exact location
  final double longitude; // Longitude for exact location
  final String ownerPhoneNumber;

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
    required this.latitude,
    required this.longitude,
    required this.ownerPhoneNumber,
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
      latitude: json['latitude'] ?? 0.3476, // Default latitude for Kampala
      longitude: json['longitude'] ?? 32.5825, // Default longitude for Kampala
      ownerPhoneNumber: json['ownerPhoneNumber'] ?? '+256755656675',

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
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
