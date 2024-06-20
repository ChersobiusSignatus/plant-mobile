
//sample_data.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';
import 'modules/plant.dart';
import 'modules/current_values.dart';

Future<void> insertSampleData() async {
  final prefs = await SharedPreferences.getInstance();
  final dbHelper = DatabaseHelper();

  final isSampleDataInserted = prefs.getBool('isSampleDataInserted') ?? false;
  if (isSampleDataInserted) {
    return;
  }

  final db = await dbHelper.database;
  await db.delete('plants_info');
  await db.delete('current_values');

  List<Plant> plants = [
    Plant(
      name: "Aloe Vera",
      type: "beginner friendly",
      light: 40000.0,
      water: 10.0,
      temp: 24.0,
      origin: "Arabian Peninsula",
      planting: "Plant the seedlings about 2.54 cm deeper than they were growing in their pots.",
      imageUrl: "https://upload.wikimedia.org/wikipedia/commons/e/e3/Aloe_vera_flower.jpg",
      wateringFrequency: 7,
    ),
    Plant(
      name: "Azalea",
      type: "intermediate",
      light: 20000.0,
      water: 20.0,
      temp: 15.0,
      origin: "Asia, Europe, North America",
      planting: "Plant the seedlings about 2.54 cm deeper than they were growing in their pots.",
      imageUrl: "https://upload.wikimedia.org/wikipedia/commons/2/29/Rhododendron_2.jpg",
      wateringFrequency: 4,
    ),
    Plant(
      name: "Jade Plant",
      type: "beginner friendly",
      light: 30000.0,
      water: 5.0,
      temp: 21.0,
      origin: "South Africa, Mozambique",
      planting: "Plant the seedlings about 2.54 cm deeper than they were growing in their pots.",
      imageUrl: "https://upload.wikimedia.org/wikipedia/commons/e/e1/Crassula_ovata_Jade_plant.jpg",
      wateringFrequency: 10,
    ),
    Plant(
      name: "African Violet",
      type: "medium",
      light: 15000.0,
      water: 15.0,
      temp: 20.0,
      origin: "Tanzania, Kenya",
      planting: "Plant the seedlings about 2.54 cm deeper than they were growing in their pots.",
      imageUrl: "https://upload.wikimedia.org/wikipedia/commons/8/82/Flower_dpp.jpg",
      wateringFrequency: 5,
    ),
    Plant(
      name: "Ficus",
      type: "medium",
      light: 25000.0,
      water: 15.0,
      temp: 22.0,
      origin: "Tropics worldwide",
      planting: "Plant the seedlings about 2.54 cm deeper than they were growing in their pots.",
      imageUrl: "https://upload.wikimedia.org/wikipedia/commons/5/54/Ficus_elastica_AuCap.jpg",
      wateringFrequency: 7,
    ),
    Plant(
      name: "Cactus",
      type: "beginner friendly",
      light: 50000.0,
      water: 5.0,
      temp: 25.0,
      origin: "Americas",
      planting: "Plant the seedlings about 2.54 cm deeper than they were growing in their pots.",
      imageUrl: "https://upload.wikimedia.org/wikipedia/commons/9/91/Echinocactus_grusonii_1.jpg",
      wateringFrequency: 14,
    ),
    Plant(
      name: "Succulent",
      type: "beginner friendly",
      light: 35000.0,
      water: 10.0,
      temp: 24.0,
      origin: "Various, predominantly arid regions worldwide",
      planting: "Plant the seedlings about 2.54 cm deeper than they were growing in their pots.",
      imageUrl: "https://upload.wikimedia.org/wikipedia/commons/7/7c/Various_succulent_plants_at_Thailand.jpg",
      wateringFrequency: 10,
    ),
    Plant(
      name: "Begonia",
      type: "medium",
      light: 20000.0,
      water: 20.0,
      temp: 20.0,
      origin: "Tropical and subtropical regions worldwide",
      planting: "Plant the seedlings about 2.54 cm deeper than they were growing in their pots.",
      imageUrl: "https://upload.wikimedia.org/wikipedia/commons/e/e9/Begonia_Cultivar_2009-6-29-2.jpg",
      wateringFrequency: 4,
    ),
  ];

  List<int> plantIds = [];
  for (var plant in plants) {
    int plantId = await dbHelper.insertPlant(plant);
    plantIds.add(plantId);
  }

  List<CurrentValue> currentValues = [
    CurrentValue(
      plantId: plantIds[0],
      light: 60000.0,
      water: 5.0,
      temp: 24.0,
      lastWateringDay: DateTime.now().subtract(Duration(days: 1)),
    ),
    CurrentValue(
      plantId: plantIds[1],
      light: 22000.0,
      water: 15.0,
      temp: 18.0,
      lastWateringDay: DateTime.now().subtract(Duration(days: 2)),
    ),
    CurrentValue(
      plantId: plantIds[3],
      light: 14000.0,
      water: 12.0,
      temp: 19.0,
      lastWateringDay: DateTime.now().subtract(Duration(days: 3)),
    ),
    CurrentValue(
      plantId: plantIds[5],
      light: 52000.0,
      water: 7.0,
      temp: 26.0,
      lastWateringDay: DateTime.now().subtract(Duration(days: 4)),
    ),
  ];

  for (var currentValue in currentValues) {
    await dbHelper.insertCurrentValue(currentValue);
  }

  await prefs.setBool('isSampleDataInserted', true);

  await dbHelper.closeDatabase();
}

