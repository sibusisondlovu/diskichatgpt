class Venue {
  final String? city;
  final int? id;
  final String? name;

  Venue({this.city, this.id, this.name});

  factory Venue.fromMap(Map<String, dynamic> map) {
    return Venue(
      city: map['city'],
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'id': id,
      'name': name,
    };
  }
}