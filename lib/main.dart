import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

// Fetch Data

Future<users> fetchusers() async {
  final response = await http.get(
      Uri.parse("https://jsonplaceholder.typicode.com/users/2"));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return users.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Users');
  }
}

// Album -> To convert the json data to Obj and display to user
class users {

  final String username;
  final String name;
  final int id;
  final String email;

  users({
    required this.name,
    required this.username,
    required this.id,
    required this.email,
  });

  factory users.fromJson(Map<String, dynamic> json) {
    return users(
        name: json['name'],
        username: json['username'],
        id: json['id'],
        email: json['email']
    );
  }
}

// Display the data and update th data

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<users> _futureusers;

  @override
  void initState() {

    super.initState();
    _futureusers = fetchusers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fetching Data from Internet",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Update Data"),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
              child: FutureBuilder<users>(
                future: _futureusers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(snapshot.data!.name),
                          Text(snapshot.data!.username),
                          // Text(snapshot.data!.id),
                          Text(snapshot.data!.email),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                  }
                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              )),
        ),
      ),
    );
  }
}