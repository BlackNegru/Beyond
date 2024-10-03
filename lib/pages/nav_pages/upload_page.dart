import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../misc/colors.dart';
import '../../widgets/app_largetext.dart';
import '../../widgets/app_text.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final TextEditingController _emailController = TextEditingController(); // Email controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _otherExperienceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _maxPeopleController = TextEditingController();

  List<XFile?> _selectedImages = List.generate(4, (index) => null);
  String _selectedExperienceType = 'Hiking';
  bool _isOtherSelected = false;

  final List<String> _experienceTypes = [
    'Hiking',
    'Snorkeling',
    'Snowboarding',
    'Diving',
    'Ballooning',
    'Other'
  ];

  Future<void> _pickImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImages[index] = pickedImage;
      });
    }
  }

  Future<void> _uploadExperience() async {
    final String url = 'http://192.168.0.105:5000/upload-experience'; // Replace with your actual API endpoint

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['email'] = _emailController.text; // Get email from input
    request.fields['name'] = _nameController.text;
    request.fields['price'] = _priceController.text;
    request.fields['type'] = _selectedExperienceType;
    request.fields['description'] = _detailsController.text;
    request.fields['location'] = _locationController.text;
    request.fields['maxPeople'] = _maxPeopleController.text;

    if (_isOtherSelected) {
      request.fields['otherExperience'] = _otherExperienceController.text;
    }

    for (int i = 0; i < _selectedImages.length; i++) {
      if (_selectedImages[i] != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'images',
          _selectedImages[i]!.path,
        ));
      }
    }

    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Experience uploaded successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload experience.')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
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
            // Email Field for User Input
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            for (int i = 0; i < _selectedImages.length; i++) ...[
              GestureDetector(
                onTap: () => _pickImage(i),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _selectedImages[i] != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      File(_selectedImages[i]!.path),
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
            ],

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

            // Experience Type Dropdown
            DropdownButtonFormField<String>(
              value: _selectedExperienceType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedExperienceType = newValue!;
                  _isOtherSelected = _selectedExperienceType == 'Other';
                });
              },
              decoration: InputDecoration(
                labelText: 'Experience Type',
                border: OutlineInputBorder(),
              ),
              items: _experienceTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            SizedBox(height: 15),

            if (_isOtherSelected)
              TextField(
                controller: _otherExperienceController,
                decoration: InputDecoration(
                  labelText: 'Other Experience',
                  border: OutlineInputBorder(),
                ),
              ),

            SizedBox(height: 15),

            // Description Text Box
            TextField(
              controller: _detailsController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            SizedBox(height: 15),

            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15),

            TextField(
              controller: _maxPeopleController,
              decoration: InputDecoration(
                labelText: 'Max People',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: _uploadExperience,
              child: AppText(text: 'Upload', color: Colors.white),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                backgroundColor: AppColors.mainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
