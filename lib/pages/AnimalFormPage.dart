import 'package:flutter/material.dart';
import 'package:xie_hackathon/widgets/CustomBottomNavBar.dart';

class AnimalFormPage extends StatefulWidget {
  const AnimalFormPage({Key? key}) : super(key: key);

  @override
  _AnimalFormPageState createState() => _AnimalFormPageState();
}

class _AnimalFormPageState extends State<AnimalFormPage> {
  // Animal dropdown options
  final List<String> animals = ['Cow', 'Buffalo', 'Goat', 'Sheep', 'Dog', 'Cat'];

  // Symptoms dropdown options
  final List<String> symptoms = [
    'Fever',
    'Loss of appetite',
    'Coughing',
    'Lethargy',
    'Vomiting',
    'Diarrhea',
    'Weight loss',
    'Skin issues'
  ];

  // Form state
  String? selectedAnimal;
  final List<String> selectedSymptoms = [];
  final _formKey = GlobalKey<FormState>();

  // Submit handler
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (selectedSymptoms.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one symptom.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Animal: $selectedAnimal\nSymptoms: ${selectedSymptoms.join(', ')}'),
          ),
        );

        // Add further logic here, e.g., send data to a server
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4),
      appBar: AppBar(
        title: const Text('Animal Health Form'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animal Dropdown
              DropdownButtonFormField<String>(
                value: selectedAnimal,
                decoration: const InputDecoration(
                  labelText: "Select Animal",
                  border: OutlineInputBorder(),
                ),
                items: animals.map((animal) {
                  return DropdownMenuItem(
                    value: animal,
                    child: Text(animal),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAnimal = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select an animal";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Symptoms Multi-Select Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Select Symptoms",
                  border: OutlineInputBorder(),
                ),
                items: symptoms.map((symptom) {
                  return DropdownMenuItem(
                    value: symptom,
                    child: Text(symptom),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null &&
                      !selectedSymptoms.contains(value) &&
                      selectedSymptoms.length < 3) {
                    setState(() {
                      selectedSymptoms.add(value);
                    });
                  } else if (selectedSymptoms.length >= 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You can select up to 3 symptoms only.'),
                      ),
                    );
                  }
                },
                validator: (value) {
                  if (selectedSymptoms.isEmpty) {
                    return "Please select at least one symptom";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Display Selected Symptoms with Remove Option
              Wrap(
                spacing: 8.0,
                children: selectedSymptoms.map((symptom) {
                  return Chip(
                    label: Text(symptom),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () {
                      setState(() {
                        selectedSymptoms.remove(symptom);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
