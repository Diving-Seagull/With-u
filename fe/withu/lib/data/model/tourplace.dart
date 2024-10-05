class TourPlace {
  final int id;
  final String name;
  final String address;
  final String description;
  final double latitude;
  final double longitude;
  final String category;

  TourPlace(
      {required this.id,
      required this.name,
      required this.address,
      required this.description,
      required this.latitude,
      required this.longitude,
      required this.category});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'category': category
    };
  }

  factory TourPlace.fromJson(Map<String, dynamic> json) {
    return TourPlace(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        description: json['description'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        category: json['category']);
  }
}
