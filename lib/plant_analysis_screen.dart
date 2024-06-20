//plant_analysis_screen.dart
import 'package:flutter/material.dart';
import 'modules/plant.dart';
import 'modules/current_values.dart';
import 'notification_service.dart';

class PlantAnalysisScreen extends StatefulWidget {
  final Plant plant;
  final CurrentValue currentValue;

  const PlantAnalysisScreen({required this.plant, required this.currentValue, super.key});

  @override
  _PlantAnalysisScreenState createState() => _PlantAnalysisScreenState();
}

class _PlantAnalysisScreenState extends State<PlantAnalysisScreen> {
  late String recommendation;
  late String nextWateringDay;
  late String lastWateringDay;

  @override
  void initState() {
    super.initState();
    _generateRecommendations();
    _scheduleWateringNotification();
  }

  void _generateRecommendations() {
    String lightRecommendation = widget.currentValue.light! > widget.plant.light!
        ? "Reduce light exposure."
        : "Increase light exposure.";
    String waterRecommendation = widget.currentValue.water! > widget.plant.water!
        ? "Reduce watering."
        : "Increase watering.";
    String tempRecommendation = widget.currentValue.temp! > widget.plant.temp!
        ? "Reduce temperature."
        : "Increase temperature.";

    recommendation = "Light: $lightRecommendation\nWater: $waterRecommendation\nTemperature: $tempRecommendation";
  }

  void _scheduleWateringNotification() {
    final DateTime now = DateTime.now();
    final DateTime lastWatering = widget.currentValue.lastWateringDay;
    final DateTime nextWatering = lastWatering.add(Duration(days: widget.plant.wateringFrequency));

    lastWateringDay = lastWatering.toLocal().toString().split(' ')[0];
    nextWateringDay = nextWatering.toLocal().toString().split(' ')[0];

    NotificationService().scheduleNotification(
      id: 0,
      title: 'Watering Reminder',
      body: 'It is time to water your plant: ${widget.plant.name}',
      scheduledDate: nextWatering,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Analysis for ${widget.plant.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recommendations:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(recommendation),
            SizedBox(height: 20),
            Text('Last Watering Day:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(lastWateringDay),
            SizedBox(height: 20),
            Text('Next Watering Day:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(nextWateringDay),
          ],
        ),
      ),
    );
  }
}

