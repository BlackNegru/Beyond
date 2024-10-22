import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../misc/colors.dart';
import '../../widgets/app_largetext.dart';
import '../../widgets/app_text.dart';
import '../detail_page.dart';

class SearchPage extends StatefulWidget {
  final String userId;

  const SearchPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _performSearch(String query) async {
    final String url = 'http://192.168.0.105:5000/search';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'query': query}),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          // Map the response to include only the necessary fields
          searchResults = jsonResponse.map((item) {
            return {
              "_id": item['_id'], // Store the ID for navigation
              "title": item['name'].toString(),
              "description": item['description'].toString(),
            };
          }).toList().cast<Map<String, dynamic>>();
        });
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('Caught error: $error');
    }
  }

  void _onSearchButtonPressed() {
    String query = _searchController.text;
    if (query.isNotEmpty) {
      _performSearch(query);
    }
  }

  void _navigateToDetailsPage(String experienceId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(experienceId: experienceId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.mainColor,
        title: AppLargeText(text: "Search", color: Colors.white, size: 32),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search...",
                      prefixIcon: Icon(Icons.search, color: AppColors.mainColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.mainColor, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (value) => _onSearchButtonPressed(),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _onSearchButtonPressed,
                  child: Text("Search"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textColor2,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final result = searchResults[index];
                return GestureDetector(
                  onTap: () => _navigateToDetailsPage(result["_id"]),
                  child: SearchResultCard(
                    title: result['title']!,
                    description: result['description']!,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchResultCard extends StatelessWidget {
  final String title;
  final String description;

  const SearchResultCard({
    required this.title,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        title: AppLargeText(text: title, color: Colors.black),
        subtitle: AppText(text: description, color: AppColors.textColor2),
      ),
    );
  }
}
