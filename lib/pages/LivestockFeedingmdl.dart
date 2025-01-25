import 'package:flutter/material.dart';
import 'package:xie_hackathon/widgets/CustomBottomNavBar.dart';

import '../utils/livestockservice.dart';

class LivestockFeeding extends StatefulWidget {
  const LivestockFeeding({super.key});

  @override
  State<LivestockFeeding> createState() => _LivestockFeedingState();
}

class _LivestockFeedingState extends State<LivestockFeeding> {
  // Controllers for form fields
  final TextEditingController breedController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String? healthStatus;
  final List<String> healthStatusOptions = ['Healthy', 'Sick', 'Pregnant', 'Recovering'];

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // State to store the generated feeding schedule
  String? feedingSchedule;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
      appBar: AppBar(
        title: const Text("Livestock Feeding Form"),
        backgroundColor: Colors.green,
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

                // Health Status Dropdown
                DropdownButtonFormField<String>(
                  value: healthStatus,
                  decoration: const InputDecoration(
                    labelText: "Health Status",
                    border: OutlineInputBorder(),
                  ),
                  items: healthStatusOptions.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      healthStatus = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a health status";
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
                        feedingSchedule = null;
                      });

                      // Call the service to generate the feeding schedule
                      final response = await LivestockService.generateFeedingSchedule(
                        breed: breedController.text,
                        age: ageController.text,
                        weight: weightController.text,
                        healthStatus: healthStatus!,
                      );

                      setState(() {
                        isLoading = false;
                        feedingSchedule = response;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Generate Feeding Schedule",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 24),

                // Display Feeding Schedule
                if (feedingSchedule != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      feedingSchedule!,
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
    // Dispose controllers
    breedController.dispose();
    ageController.dispose();
    weightController.dispose();
    super.dispose();
  }
}
