import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:naseem_sa/Bars/app_bar.dart';
import 'package:naseem_sa/Bars/bottom_bar.dart';
import 'package:naseem_sa/Screens/regions_screen.dart';

class AdministrartiveRegionScreen extends StatefulWidget {
  const AdministrartiveRegionScreen({Key? key});

  @override
  _AdministrartiveRegionScreenState createState() => _AdministrartiveRegionScreenState();
}

class _AdministrartiveRegionScreenState extends State<AdministrartiveRegionScreen> {
  List<dynamic> regions = [];

  @override
  void initState() {
    super.initState();
    fetchImageData();
  }

  Future<void> fetchImageData() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8000/api/administrative_regions'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          regions = jsonData;
          print(regions);
        });
      } else {
        throw Exception('Failed to fetch image data');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyAppBar(pageName: 'Tourist Places'),
      ),
      body: ListView.builder(
        itemCount: regions.length,
        itemBuilder: (BuildContext context, int index) {
          final region = regions[index];
          final String name = region['name'] ?? '';
          // final String photoUrl = "http://10.0.2.2:8000/" + region['photo'];
          final int id = region['id'];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegionScreen(administrativeRegionID: id),
                ),
              );
            },
            // leading: Image.network(
            //   photoUrl,
            //   width: 50,
            //   height: 50,
            //   fit: BoxFit.cover,
            // ),
            title: Text(name),
          );
        },
      ),
      bottomNavigationBar: const BottomBar(pageIndex: 2),
    );
  }
}
