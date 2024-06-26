import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:naseem_sa/Bars/app_bar.dart';
import 'package:naseem_sa/Bars/bottom_bar.dart';
import 'package:naseem_sa/Screens/activities_screen.dart';
import 'package:naseem_sa/api/api.dart';

class LandmarkScreen extends StatefulWidget {
  final int regionID;

  const LandmarkScreen({
    Key? key,
    required this.regionID,
  }) : super(key: key);

  @override
  _LandmarkScreenState createState() => _LandmarkScreenState();
}

class _LandmarkScreenState extends State<LandmarkScreen> {
  List<dynamic> landmarks = [];

  @override
  void initState() {
    super.initState();
    fetchLandmarkDetails();
  }

  Future<void> fetchLandmarkDetails() async {
    try {
      final response = await http.get(Uri.parse(myUrl +
          'api/landmarks/${widget.regionID}')); // Replace with your API endpoint URL

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          landmarks = jsonData;
        });
      } else {
        throw Exception('Failed to fetch landmark details');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyAppBar(pageName: 'Landmarks'),
      ),
      body: ListView.builder(
        itemCount: landmarks.length,
        itemBuilder: (BuildContext context, int index) {
          final landmark = landmarks[index];
          final int id = landmark['id'] ?? '';
          final String name = landmark['name'] ?? '';
          final String description = landmark['description'] ?? '';
          final String photoUrl = myUrl + landmark['photo'];

          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActivityScreen(landmarkID: id),
                ),
              );
            },
            title: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Image.network(
                                photoUrl,
                                width: 350,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8.0,
                              left: 8.0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      (index + 1).toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomBar(pageIndex: 2),
    );
  }
}
