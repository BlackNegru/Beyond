import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('https://beyondserver.onrender.com/users'));

    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> deleteUser(String userId) async {
    final response = await http.delete(Uri.parse('https://beyondserver.onrender.com/delete-user/$userId'));

    if (response.statusCode == 200) {
      setState(() {
        users.removeWhere((user) => user['userId'] == userId);
      });
    } else {
      throw Exception('Failed to delete user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
      ),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];

          return ListTile(
            title: Text(user['name']),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                deleteUser(user['userId']);
              },
            ),
          );
        },
      ),
    );
  }
}
