import 'package:flutter/material.dart';
import 'package:memory_map/data/locationdata.dart';
import 'data/sqliteservice.dart';
import 'data/tagdata.dart';

class ItemOverviewScreen extends StatefulWidget {

  const ItemOverviewScreen({super.key});

  @override
  State<ItemOverviewScreen> createState() => _CreateOverviewState();
}

class _CreateOverviewState extends State<ItemOverviewScreen> {

  late List<Location> locations;
  late List<Tag> tags;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    locations = await SqliteService.getLocationItems();
    tags = await SqliteService.getTagItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Create location memory'),
    ),
    body: SingleChildScrollView(
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: locations.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            //color: Colors.amber[colorCodes[index]],
            child: Center(
                child: Text('Entry ${locations[index].title}')
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      ),
    );
  }
}