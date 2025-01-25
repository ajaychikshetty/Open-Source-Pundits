import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../const/AppColors.dart';

import 'package:http/http.dart' as http;

class EditPetScreen extends StatefulWidget {
  final Map<String, dynamic> petData;

  const EditPetScreen({Key? key, required this.petData}) : super(key: key);

  @override
  _EditPetScreenState createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _breedController;
  late TextEditingController _weightController;
  late TextEditingController _diseaseHistoryController;
  late String _status;
  late String _petImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.petData['name'] ?? '');
    _ageController =
        TextEditingController(text: widget.petData['age']?.toString() ?? '');
    _breedController =
        TextEditingController(text: widget.petData['breed'] ?? '');
    _weightController =
        TextEditingController(text: widget.petData['weight']?.toString() ?? '');
    _diseaseHistoryController = TextEditingController(
        text: (widget.petData['disease_history'] as List?)?.join(', ') ?? '');
    _status = widget.petData['status'] ?? 'healthy';
    _petImage = widget.petData['pet_image'] ?? '';
  }
void _updatePet() async {
  const String apiUrl = "http://192.168.235.140:5000/update_pet";
  
  final updatedPet = {
    'pet_id':widget.petData['_id'],
    'name': _nameController.text,
    'age': int.tryParse(_ageController.text) ?? 0,
    'breed': _breedController.text,
    'weight': double.tryParse(_weightController.text) ?? 0,
    'disease_history': _diseaseHistoryController.text,
    'status': _status,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(updatedPet),
    );

    if (response.statusCode == 200) {
      // Successfully updated
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pet updated successfully')),
      );
        Navigator.pushNamedAndRemoveUntil(context, "/MyHomePage", (Route<dynamic> route) => false);
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update pet: ${response.body}')),
      );
    }
  } catch (e) {
    // Handle network or other errors
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Pet Details',
          style: GoogleFonts.spaceMono(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image display
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  _petImage,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Rest of the form fields remain the same as in previous version
            _buildTextField('Name', _nameController),
            _buildTextField('Age', _ageController,
                keyboardType: TextInputType.number),
            _buildTextField('Breed', _breedController),
            _buildTextField('Weight', _weightController,
                keyboardType: TextInputType.number),
            _buildTextField('Disease History', _diseaseHistoryController,
                hint: 'Comma-separated list of diseases'),

            // Status Dropdown
            Text(
              'Status',
              style: GoogleFonts.poppins(
                color: AppColors.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: _status,
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  _status = newValue!;
                });
              },
              items: <String>['healthy', 'sick', 'recovering']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _updatePet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentColor,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Update Pet',
                  style: GoogleFonts.poppins(
                    color: AppColors.backgroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reused _buildTextField method from previous version
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    String hint = '',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.primaryColor.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
