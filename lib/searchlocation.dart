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

  var _suggestions = <SearchInfo>[];

  Future<void> findLocation(String query) async {
      List<SearchInfo> suggestions = await addressSuggestion(query);
      _suggestions = suggestions;
  }

  Future<void> returnPoint(SearchInfo info) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context, info);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a location'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search address',
                  hintText: 'Enter address',
                ),
              ),
            ),
            ElevatedButton(
              child: const Text('Search'),
              onPressed: () {
                setState(() {
                  findLocation(_searchController.text);
                });
              },
            ),
            ListView.separated(
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                onTap: () async {
                  await returnPoint(_suggestions[index]);
                },
                  leading: const Icon(Icons.location_pin),
                  title: Text('Item ${_suggestions[index].address!.street.toString()}'),
                  subtitle: Text('${_suggestions[index].address}'),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            ),
          ],
        ),
      ),
    );
  }
}