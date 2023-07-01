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

  var _isLoading = false;

  String getLocationTitle(SearchInfo info) {
    if(info.address == null) {
      return info.point.toString();
    } else if(info.address!.street != null) {
      return info.address!.street!;
    } else if (info.address!.name != null) {
      return info.address!.name!;
    } else {
      return info.address!.city!;
    }
  }

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
          Stack (
            children: [
            if (_isLoading) const Center(child: CircularProgressIndicator())
          ]),
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
              onPressed: () async {
                setState(() =>  _isLoading = true );//show loader
                await findLocation(_searchController.text);
                setState(() => _isLoading = false );
              },
            ),
            ListView.separated(
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                onTap: () async {
                  setState(() => _isLoading = true );//show loader
                  await returnPoint(_suggestions[index]);
                  setState(() => _isLoading = false);//hide loader
                },
                  leading: const Icon(Icons.location_pin),
                  title: Text(getLocationTitle(_suggestions[index])),
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