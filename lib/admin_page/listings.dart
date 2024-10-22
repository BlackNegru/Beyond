import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminListingsPage extends StatefulWidget {
  @override
  _ListingsPageState createState() => _ListingsPageState();
}

class _ListingsPageState extends State<AdminListingsPage> {
  List<dynamic> experiences = [];

  @override
  void initState() {
    super.initState();
    fetchExperiences();
  }

  Future<void> fetchExperiences() async {
    final response = await http.get(Uri.parse('http://192.168.0.105:5000/experiences'));

    if (response.statusCode == 200) {
      setState(() {
        experiences = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load experiences');
    }
  }

  Future<void> deleteExperience(String expId) async {
    final response = await http.delete(Uri.parse('http://<your-server-url>/delete-experience/$expId'));

    if (response.statusCode == 200) {
      setState(() {
        experiences.removeWhere((exp) => exp['expId'] == expId);
      });
    } else {
      throw Exception('Failed to delete experience');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listings Page'),
      ),
      body: experiences.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: experiences.length,
        itemBuilder: (context, index) {
          final experience = experiences[index];

          return ListTile(
            title: Text(experience['name']),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                deleteExperience(experience['expId']);
              },
            ),
          );
        },
      ),
    );
  }
}
