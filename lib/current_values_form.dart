
//current_values_form.dart

import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'modules/current_values.dart';
import 'modules/plant.dart';

class CurrentValuesForm extends StatefulWidget {
  final Plant? plant;
  final List<CurrentValue> currentValues;
  final VoidCallback onSave;

  const CurrentValuesForm({required this.plant, required this.currentValues, required this.onSave, super.key});

  @override
  _CurrentValuesFormState createState() => _CurrentValuesFormState();
}

class _CurrentValuesFormState extends State<CurrentValuesForm> {
  final _formKey = GlobalKey<FormState>();
  final _lightController = TextEditingController();
  final _waterController = TextEditingController();
  final _tempController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.currentValues.isNotEmpty) {
      _lightController.text = widget.currentValues[0].light?.toString() ?? '';
      _waterController.text = widget.currentValues[0].water?.toString() ?? '';
      _tempController.text = widget.currentValues[0].temp?.toString() ?? '';
    }
  }

  void _saveCurrentValues() async {
    if (_formKey.currentState!.validate()) {
      final dbHelper = DatabaseHelper();
      final currentValue = CurrentValue(
        plantId: widget.plant!.id!,
        light: double.tryParse(_lightController.text),
        water: double.tryParse(_waterController.text),
        temp: double.tryParse(_tempController.text),
        lastWateringDay: DateTime.now(),
      );
      await dbHelper.insertCurrentValue(currentValue);
      widget.onSave();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data saved for ${widget.plant!.name}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.plant != null
        ? SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Current',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _lightController,
                decoration: const InputDecoration(labelText: 'Light'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value for light';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _waterController,
                decoration: const InputDecoration(labelText: 'Water'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value for water';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tempController,
                decoration: const InputDecoration(labelText: 'Temperature'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value for temperature';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveCurrentValues,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        : const Center(child: CircularProgressIndicator());
  }
}
