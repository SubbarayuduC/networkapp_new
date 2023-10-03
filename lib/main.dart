import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}
// updateAlbum(){}
// Fetch Data

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse("https://jsonplaceholder.typicode.com/albums/1"));

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

// Http Request to update the data
Future<Album> updateAlbum(String title) async {
  final response =
  await http.put(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'title': title}));

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update album');
  }
}

// Album -> To convert the json data to Obj and display to user
class Album {
  final String name;
  final String username;
  final String password;
  final String email;

  Album({
    required this.name,
    required this.username,
    required this.password,
    required this.email
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json["name"],
      username: json['username'],
      password: json["password"],
        email: json["email"]
    );
  }
}

// Display the data and update th data

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _usernamecontroller = TextEditingController();
  TextEditingController _paswordcontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  late Future<Album> _futureAlbum;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Update Data"),
        ),
        body: Container(
            child: FutureBuilder<Album>(
              future: _futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(snapshot.data!.name),
                        Text(snapshot.data!.username),
                        Text(snapshot.data!.password),
                        Text(snapshot.data!.email),

                        TextField(
                          controller: _namecontroller,
                          decoration: InputDecoration(hintText: "Enter Name"),
                        ),
                        TextField(
                          controller: _usernamecontroller,
                          decoration: InputDecoration(hintText: "Enter User Name"),
                        ),
                        TextField(
                          controller: _paswordcontroller,
                          decoration: InputDecoration(hintText: "Enter Password"),
                        ),
                        TextField(
                          controller: _emailcontroller,
                          decoration: InputDecoration(hintText: "Enter Email Address"),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _futureAlbum = updateAlbum(_namecontroller.text);
                                _futureAlbum = updateAlbum(_usernamecontroller.text);
                                _futureAlbum = updateAlbum(_paswordcontroller.text);
                                _futureAlbum = updateAlbum(_paswordcontroller.text);
                              });
                            },
                            child: Text('Update Data'))
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
    );
  }
}