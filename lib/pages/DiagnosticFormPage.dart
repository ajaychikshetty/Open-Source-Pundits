import 'package:flutter/material.dart';

import '../utils/DiagnosticService.dart';
import '../widgets/CustomBottomNavBar.dart';

class DiagnosticFormPage extends StatefulWidget {
  const DiagnosticFormPage({super.key});

  @override
  State<DiagnosticFormPage> createState() => _DiagnosticFormPageState();
}

class _DiagnosticFormPageState extends State<DiagnosticFormPage> {
  // Controllers for form inputs
  final TextEditingController breedController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController symptomsController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // State for loading and response
  String? diagnosticSummary;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
      appBar: AppBar(

        title: const Text("Diagnostic Form"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breed Input
                TextFormField(
                  controller: breedController,
                  decoration: const InputDecoration(
                    labelText: "Breed",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the breed";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Age Input
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Age (in years)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the age";
                    }
                    if (double.tryParse(value) == null) {
                      return "Please enter a valid number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Weight Input
                TextFormField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Weight (in kg)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the weight";
                    }
                    if (double.tryParse(value) == null) {
                      return "Please enter a valid number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Symptoms Input
                TextFormField(
                  controller: symptomsController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Symptoms",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please describe the symptoms";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Submit Button
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                        diagnosticSummary = null;
                      });

                      // Call the service to generate a diagnostic summary
                      final response = await DiagnosticService.generateDiagnosticSummary(
                        breed: breedController.text,
                        age: ageController.text,
                        weight: weightController.text,
                        symptoms: symptomsController.text,
                      );

                      setState(() {
                        isLoading = false;
                        diagnosticSummary = response;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Generate Diagnostic Summary",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 24),

                // Display Diagnostic Summary
                if (diagnosticSummary != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      diagnosticSummary!,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    breedController.dispose();
    ageController.dispose();
    weightController.dispose();
    symptomsController.dispose();
    super.dispose();
  }
}
