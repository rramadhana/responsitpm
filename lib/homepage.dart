import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:responsitpm/detailpage.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> agentsData = [];

  @override
  void initState() {
    super.initState();
    fetchAgentsData();
  }

  Future<void> fetchAgentsData() async {
    final response =
    await http.get(Uri.parse('https://valorant-api.com/v1/agents'));
    if (response.statusCode == 200) {
      setState(() {
        agentsData = json.decode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  void navigateToDetailPage(dynamic agentsData) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.logout),
            color: Colors.black,
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ),
        body: agentsData.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: agentsData.length,
          itemBuilder: (BuildContext context, int index) {
            final agent = agentsData[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(agent['displayIcon']),
              ),
              title: Text(agent['displayName']),
              onTap: () {
                navigateToDetailPage(agent);
              },
            );
          },
        ),
      ),
    );
  }
}