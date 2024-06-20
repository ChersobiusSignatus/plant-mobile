
//current_values.dart

class CurrentValue {
  final int? id;
  final int plantId;
  final double? light;
  final double? water;
  final double? temp;
  final DateTime lastWateringDay;

  CurrentValue({
    this.id,
    required this.plantId,
    this.light,
    this.water,
    this.temp,
    required this.lastWateringDay,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plant_id': plantId,
      'light': light,
      'water': water,
      'temp': temp,
      'last_watering_day': lastWateringDay.toIso8601String(),
    };
  }

  factory CurrentValue.fromMap(Map<String, dynamic> map) {
    return CurrentValue(
      id: map['id'],
      plantId: map['plant_id'],
      light: map['light'],
      water: map['water'],
      temp: map['temp'],
      lastWateringDay: DateTime.parse(map['last_watering_day']),
    );
  }

  @override
  String toString() {
    return 'CurrentValue{id: $id, plant_id: $plantId, light: $light, water: $water, temp: $temp, last_watering_day: $lastWateringDay}';
  }
}
