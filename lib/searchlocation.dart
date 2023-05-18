import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class SelectLocationScreen extends StatefulWidget {

  const SelectLocationScreen({super.key, required this.controller});

  final MapController controller;

  @override
  State<SelectLocationScreen> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocationScreen> {

  final TextEditingController _searchController = TextEditingController();

  Future<void> findLocation(String query) async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                  hintText: 'Enter Your Name',
                ),
              ),
            ),
            ElevatedButton(
              child: Text('Sign In'),
              onPressed: (){
                findLocation(_searchController.text);
              },
            )
          ],
        ),
      ),
    );
  }
}