import 'package:flutter/material.dart';

import '../../misc/colors.dart';
import '../../widgets/app_largetext.dart';
import '../../widgets/app_text.dart';


class SearchPage extends StatefulWidget {
  final String userId;

  const SearchPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> searchResults = [];

  @override
  void initState() {
    super.initState();
    // Example search results; this should be replaced with actual search logic
    searchResults = [
      {"title": "Mountain Adventure", "description": "Explore the beautiful mountains."},
      {"title": "Beach Relaxation", "description": "Relax on pristine beaches."},
      {"title": "City Tour", "description": "Discover the city landmarks."},
    ];
  }

  void _performSearch(String query) {
    // Add actual search logic here
    setState(() {
      searchResults = searchResults.where((item) {
        return item['title']!.toLowerCase().contains(query.toLowerCase()) ||
            item['description']!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: AppLargeText(text: "Search", color: Colors.white, size: 32),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
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
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final result = searchResults[index];
                return SearchResultCard(
                  title: result['title']!,
                  description: result['description']!,
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
