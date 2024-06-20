// plant_care_screen.dart
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'modules/current_values.dart';
import 'modules/plant.dart';
import 'current_values_form.dart';
import 'plant_detail_screen.dart';
import 'plant_analysis_screen.dart';

class PlantCareScreen extends StatefulWidget {
  final String name;
  final String imageUrl;

  const PlantCareScreen({required this.name, required this.imageUrl, super.key});

  @override
  _PlantCareScreenState createState() => _PlantCareScreenState();
}

class _PlantCareScreenState extends State<PlantCareScreen> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

  List<CurrentValue> _currentValues = [];
  Plant? _plant;

  @override
  void initState() {
    super.initState();
    _fetchPlantData();
  }

  void _fetchPlantData() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.database; // Ensure database is open
    final plant = await dbHelper.plants().then((plants) => plants.firstWhere((plant) => plant.name == widget.name));
    final currentValues = await dbHelper.currentValues(plant.id!);

    setState(() {
      _plant = plant;
      _currentValues = currentValues;
    });
  }

  void _openAnalysis() {
    if (_plant != null && _currentValues.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlantAnalysisScreen(
            plant: _plant!,
            currentValue: _currentValues[0],
          ),
        ),
      );
    } else {
      _showNoDataDialog();
    }
  }

  void _showNoDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Data"),
          content: const Text("I don't have enough data to provide analysis right now."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.name, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.imageUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder<int>(
            valueListenable: _currentPageNotifier,
            builder: (context, currentPage, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  2,
                      (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentPage == index ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: 2,
              onPageChanged: (int page) {
                _currentPageNotifier.value = page;
              },
              itemBuilder: (context, index) {
                return index == 0
                    ? CurrentValuesForm(
                  plant: _plant,
                  currentValues: _currentValues,
                  onSave: _fetchPlantData,
                )
                    : PlantDetailScreen(
                  section: 'Recommended',
                  details: [
                    {'icon': Icons.wb_sunny, 'text': 'Light: ${_plant?.light ?? 'no data'}'},
                    {'icon': Icons.opacity, 'text': 'Water: ${_plant?.water ?? 'no data'}'},
                    {'icon': Icons.thermostat, 'text': 'Temperature: ${_plant?.temp ?? 'no data'}'},
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _openAnalysis,
            child: const Text('Analyze'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

