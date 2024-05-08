class Lodging {
  final int id;
  final String name;
  final String description;
  final String image;
  final int backroom;
  final DateTime startRange;
  final DateTime endRange;
  final Location location;

  Lodging({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.backroom,
    required this.startRange,
    required this.endRange,
    required this.location,
  });

  factory Lodging.fromJson(Map<String, dynamic> json) {
    return Lodging(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      backroom: json['backroom'] ?? 0,
      startRange: json['startRange'] != null
          ? DateTime.parse(json['startRange'])
          : DateTime.now(),
      endRange: json['endRange'] != null
          ? DateTime.parse(json['endRange'])
          : DateTime.now(),
      location: Location.fromJson(json['location'] ?? ''),
    );
  }
}

class Location {
  final int id;
  final String streep;
  final Country country;
  final int postal;

  Location({
    required this.id,
    required this.streep,
    required this.country,
    required this.postal,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? 0,
      streep: json['streep'] ?? '',
      country: Country.fromJson(json['country'] ?? ''),
      postal: json['postal'] ?? 0,
    );
  }
}

class Country {
  final int id;
  final String name;

  Country({
    required this.id,
    required this.name,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
