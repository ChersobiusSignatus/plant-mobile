
//modules/plant.dart
class Plant {
  final int? id;
  final String name;
  final String type;
  final double? light;
  final double? water;
  final double? temp;
  final String? origin;
  final String? planting;
  final String? imageUrl;
  final int wateringFrequency;

  Plant({
    this.id,
    required this.name,
    required this.type,
    this.light,
    this.water,
    this.temp,
    this.origin,
    this.planting,
    this.imageUrl,
    required this.wateringFrequency,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'light': light,
      'water': water,
      'temp': temp,
      'origin': origin,
      'planting': planting,
      'image_url': imageUrl,
      'watering_frequency': wateringFrequency,
    };
  }

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      light: map['light'],
      water: map['water'],
      temp: map['temp'],
      origin: map['origin'],
      planting: map['planting'],
      imageUrl: map['image_url'],
      wateringFrequency: map['watering_frequency'],
    );
  }

  @override
  String toString() {
    return 'Plant{id: $id, name: $name, type: $type, light: $light, water: $water, temp: $temp, origin: $origin, planting: $planting, image_url: $imageUrl, watering_frequency: $wateringFrequency}';
  }
}
