
//library.dart

import 'package:flutter/material.dart';
import 'description.dart';
import 'database_helper.dart';
import 'modules/plant.dart';

class PlantLibraryScreen extends StatefulWidget {
  const PlantLibraryScreen({super.key});

  @override
  _PlantLibraryScreenState createState() => _PlantLibraryScreenState();
}

class _PlantLibraryScreenState extends State<PlantLibraryScreen> {
  List<Plant> _plants = [];
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<List<Plant>> _filteredPlants = ValueNotifier<List<Plant>>([]);

  @override
  void initState() {
    super.initState();
    _fetchPlants();
    _searchController.addListener(_filterPlants);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterPlants);
    _searchController.dispose();
    _filteredPlants.dispose();
    super.dispose();
  }

  void _fetchPlants() async {
    final dbHelper = DatabaseHelper();
    final plants = await dbHelper.plants();
    setState(() {
      _plants = plants;
    });
    _filteredPlants.value = plants;
  }

  void _filterPlants() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      _filteredPlants.value = _plants;
    } else {
      _filteredPlants.value = _plants
          .where((plant) => plant.name.toLowerCase().contains(query))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Library', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
            child: ValueListenableBuilder<List<Plant>>(
              valueListenable: _filteredPlants,
              builder: (context, filteredPlants, _) {
                return ListView.builder(
                  itemCount: filteredPlants.length,
                  itemBuilder: (context, index) {
                    final plant = filteredPlants[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(plant.imageUrl ?? ''),
                      ),
                      title: Text(plant.name),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlantDescriptionScreen(
                              name: plant.name,
                              imageUrl: plant.imageUrl ?? '',
                              type: plant.type,
                              origin: plant.origin ?? '',
                              planting: plant.planting ?? '',
                            ),
                          ),
                        );
                      },
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
