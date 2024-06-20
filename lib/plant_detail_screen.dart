// plant_detail_screen.dart

import 'package:flutter/material.dart';

class PlantDetailScreen extends StatelessWidget {
  final String section;
  final List<Map<String, dynamic>> details;

  const PlantDetailScreen({required this.section, required this.details, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              section,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: details.map<Widget>((detail) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(detail['icon']),
                    const SizedBox(width: 10),
                    Text(
                      detail['text'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
