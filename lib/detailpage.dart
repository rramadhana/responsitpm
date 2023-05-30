import 'dart:convert';
import 'homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detail ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class AgentDetailPage extends StatefulWidget {
  final String uuid;

  const AgentDetailPage({required this.uuid, Key? key}) : super(key: key);

  @override
  _AgentDetailPageState createState() => _AgentDetailPageState();
}

class _AgentDetailPageState extends State<AgentDetailPage> {
  late Future<Map<String, dynamic>> _agentDetail;

  @override
  void initState() {
    super.initState();
    _agentDetail = _fetchAgentDetail();
  }

  Future<Map<String, dynamic>> _fetchAgentDetail() async {
    final response = await http.get(Uri.parse('https://valorant-api.com/v1/agents/${widget.uuid}'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to fetch agent detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _agentDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('failed fetch API data agen'),
            );
          } else {
            final agent = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agent['displayName'],
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Image.network(
                    agent['displayIcon'],
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 16.0),
                  Text('Nama Lengkap: ${agent['fullDisplayName']}'),
                  SizedBox(height: 8.0),
                  Text('Deskripsi: ${agent['description']}'),
                  SizedBox(height: 8.0),
                  Text('Jenis Agen: ${agent['role']['displayName']}'),
                  SizedBox(height: 8.0),
                  Text('Skill Utama: ${agent['abilities'][0]['displayName']}'),
                  SizedBox(height: 8.0),
                  Text('Skill Kedua: ${agent['abilities'][1]['displayName']}'),
                  SizedBox(height: 8.0),
                  Text('Ultimate: ${agent['abilities'][2]['displayName']}'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}