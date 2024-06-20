
//shelf_lib.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'plant_care_screen.dart';

class PlantShelfScreen extends StatefulWidget {
  const PlantShelfScreen({super.key});

  static List<Map<String, String>> _shelfPlants = [];

  static Future<void> addPlantToShelf(String name, String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    if (!_shelfPlants.any((plant) => plant['name'] == name)) {
      _shelfPlants.add({'name': name, 'image': imageUrl});
      await prefs.setString('shelfPlants', jsonEncode(_shelfPlants));
    }
  }

  static Future<void> removePlantFromShelf(int index) async {
    final prefs = await SharedPreferences.getInstance();
    _shelfPlants.removeAt(index);
    await prefs.setString('shelfPlants', jsonEncode(_shelfPlants));
  }

  static Future<void> loadShelfPlants() async {
    final prefs = await SharedPreferences.getInstance();
    final String? shelfPlantsString = prefs.getString('shelfPlants');
    if (shelfPlantsString != null) {
      final List<dynamic> jsonData = jsonDecode(shelfPlantsString);
      _shelfPlants = jsonData.map((plant) => Map<String, String>.from(plant)).toList();
    }
  }

  @override
  _PlantShelfScreenState createState() => _PlantShelfScreenState();
}

class _PlantShelfScreenState extends State<PlantShelfScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<List<Map<String, String>>> _filteredPlants =
  ValueNotifier<List<Map<String, String>>>(PlantShelfScreen._shelfPlants);

  @override
  void initState() {
    super.initState();
    PlantShelfScreen.loadShelfPlants().then((_) {
      _filteredPlants.value = PlantShelfScreen._shelfPlants;
    });
    _searchController.addListener(_filterPlants);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterPlants);
    _searchController.dispose();
    _filteredPlants.dispose();
    super.dispose();
  }

  void _filterPlants() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      _filteredPlants.value = PlantShelfScreen._shelfPlants;
    } else {
      _filteredPlants.value = PlantShelfScreen._shelfPlants
          .where((plant) => plant['name']!.toLowerCase().contains(query))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shelf', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<Map<String, String>>>(
              valueListenable: _filteredPlants,
              builder: (context, filteredPlants, _) {
                return ListView.builder(
                  itemCount: filteredPlants.length,
                  itemBuilder: (context, index) {
                    final plant = filteredPlants[index];
                    return Dismissible(
                      key: Key(plant['name']!),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete ${plant['name']}'),
                              content: const Text('Are you sure you want to delete plant from your shelf?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        PlantShelfScreen.removePlantFromShelf(index);
                        _filteredPlants.value = PlantShelfScreen._shelfPlants;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${plant['name']} removed from shelf!'),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(plant['image']!),
                        ),
                        title: Text(plant['name']!),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlantCareScreen(
                                name: plant['name']!,
                                imageUrl: plant['image']!,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
