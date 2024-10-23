import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../misc/colors.dart';
import '../../widgets/app_largetext.dart';
import '../../widgets/app_text.dart';
import '../menupages/Listings_page.dart';

class UploadPage extends StatefulWidget {
  final String userId; // Accepting userId passed from other pages

  const UploadPage({required this.userId, super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _otherExperienceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _maxPeopleController = TextEditingController();
  final TextEditingController _gmapsLinkController = TextEditingController(); // Google Maps link controller

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
    final String url = 'https://beyondserver.onrender.com/upload-experience';

    List<String> base64Images = [];

    for (var image in _selectedImages) {
      if (image != null) {
        final bytes = File(image.path).readAsBytesSync();
        base64Images.add(base64Encode(bytes));
      }
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': widget.userId, // Passing userId here
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'type': _selectedExperienceType,
        'description': _detailsController.text,
        'location': _locationController.text,
        'maxPeople': int.parse(_maxPeopleController.text),
        'gmapsLink': _gmapsLinkController.text, // Google Maps link field
        'images': base64Images,
        if (_isOtherSelected) 'otherExperience': _otherExperienceController.text,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Experience uploaded successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ListingsPage(userId: '',)), // Ensure to import ListingsPage
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload experience.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.mainColor,
        title: AppLargeText(text: "Upload Experience", color: Colors.white, size: 20),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              controller: _gmapsLinkController,
              decoration: InputDecoration(
                labelText: 'Google Maps Link', // Input for Google Maps link
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
