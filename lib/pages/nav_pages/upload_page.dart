import 'dart:io'; // For handling file-based image uploads
import 'package:flutter/material.dart'; // Main Flutter package for UI components
import 'package:image_picker/image_picker.dart'; // For picking images from the gallery

import '../../misc/colors.dart'; // Custom colors used in the app
import '../../widgets/app_largetext.dart'; // Custom large text widget
import '../../widgets/app_text.dart'; // Custom text widget

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _otherExperienceController = TextEditingController();
  final TextEditingController _surroundingInfoController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _maxPeopleController = TextEditingController();

  // Variables for handling image picking and dropdown selection
  XFile? _selectedImage;
  String _selectedExperienceType = 'Hiking';
  bool _isOtherSelected = false;

  // Experience types list
  final List<String> _experienceTypes = [
    'Hiking',
    'Snorkeling',
    'Snowboarding',
    'Diving',
    'Ballooning',
    'Other'
  ];

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: AppLargeText(text: "Upload Experience", color: Colors.white, size: 32),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    File(_selectedImage!.path),
                    fit: BoxFit.cover,
                  ),
                )
                    : Center(
                  child: Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Experience Name and Price Section
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Experience Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),

            // Experience Type Dropdown and "Other" Option
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedExperienceType,
                      decoration: InputDecoration(
                        labelText: 'Select Experience Type',
                        border: OutlineInputBorder(),
                      ),
                      items: _experienceTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedExperienceType = newValue!;
                          _isOtherSelected = _selectedExperienceType == 'Other';
                        });
                      },
                    ),
                    if (_isOtherSelected)
                      SizedBox(height: 15),
                    if (_isOtherSelected)
                      TextField(
                        controller: _otherExperienceController,
                        decoration: InputDecoration(
                          labelText: 'Other Experience',
                          border: OutlineInputBorder(),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Location and Max People Section
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    TextField(
                      controller: _stateController,
                      decoration: InputDecoration(
                        labelText: 'State',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _countryController,
                      decoration: InputDecoration(
                        labelText: 'Country',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _maxPeopleController,
                      decoration: InputDecoration(
                        labelText: 'Max Number of People',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),

            // Description and Surrounding Info Section
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    TextField(
                      controller: _detailsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _surroundingInfoController,
                      decoration: InputDecoration(
                        labelText: 'Surrounding Information',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                // Handle form submission logic here
                String name = _nameController.text;
                String details = _detailsController.text;
                String price = _priceController.text;
                String experienceType = _selectedExperienceType;
                String surroundingInfo = _surroundingInfoController.text;
                String state = _stateController.text;
                String country = _countryController.text;
                String maxPeople = _maxPeopleController.text;
                String otherExperience = _otherExperienceController.text;

                // For debugging purposes
                print('Name: $name');
                print('Price: $price');
                print('Experience Type: $experienceType');
                print('Details: $details');
                print('Surrounding Info: $surroundingInfo');
                print('State: $state');
                print('Country: $country');
                print('Max People: $maxPeople');
                if (_selectedImage != null) {
                  print('Selected Image Path: ${_selectedImage!.path}');
                }
                if (_isOtherSelected) {
                  print('Other Experience: $otherExperience');
                }
              },
              child: Center(
                child: AppLargeText(
                  text: 'Submit',
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
