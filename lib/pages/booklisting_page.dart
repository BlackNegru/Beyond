import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookListingsPage extends StatefulWidget {
  final String expId;        // Experience ID from Detail Page
  final String date;         // Selected date for the booking
  final int totalPeople;     // Total number of people for booking

  BookListingsPage({
    required this.expId,
    required this.date,
    required this.totalPeople,
  });

  @override
  _BookListingsPageState createState() => _BookListingsPageState();
}

class _BookListingsPageState extends State<BookListingsPage> {
  String experienceName = '';
  String experienceLocation = '';
  double experiencePrice = 0;
  double totalPrice = 0;
  String imageUrl = '';
  String userId = '';

  @override
  void initState() {
    super.initState();
    _getUserId();
    _fetchExperienceDetails(); // Fetch experience details on initialization
  }

  // Fetch userId from Shared Preferences
  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
  }

  // Fetch experience details from the API using expId
  Future<void> _fetchExperienceDetails() async {
    final response = await http.get(
      Uri.parse('http://192.168.0.105:5000/experience/${widget.expId}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        experienceName = data['name'];
        experienceLocation = data['location'];
        experiencePrice = data['price'].toDouble();
        totalPrice = widget.totalPeople * experiencePrice;
        imageUrl = data['images'].isNotEmpty ? data['images'][0] : '';
      });
    } else {
      print('Failed to fetch experience details');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load experience details')),
      );
    }
  }

  // Booking the experience
  Future<void> _bookExperience() async {
    // Log values before sending to the server
    print('Booking Experience:');
    print('User ID: $userId');
    print('Experience ID: ${widget.expId}');
    print('Total People: ${widget.totalPeople}');
    print('Total Price: $totalPrice');
    print('Date: ${widget.date}');

    final response = await http.post(
      Uri.parse('http://192.168.0.105:5000/book-experience'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'userId': userId,
        'expId': widget.expId,
        'totalPeople': widget.totalPeople,
        'totalPrice': totalPrice,
        'date': widget.date,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking Successful')),
      );
      Navigator.pop(context); // Navigate back to the previous page
    } else {
      print('Error: ${response.statusCode} - ${response.body}'); // Log the error response
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking Failed: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl.isNotEmpty
                ? Image.memory(base64Decode(imageUrl), height: 200, fit: BoxFit.cover, width: double.infinity)
                : Container(height: 200, color: Colors.grey, width: double.infinity),
            SizedBox(height: 20),
            Text('Name: $experienceName', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Location: $experienceLocation', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Price per person: \$$experiencePrice', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Total People: ${widget.totalPeople}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Total Price: \$$totalPrice', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _bookExperience,
              child: Text('Confirm Booking'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
