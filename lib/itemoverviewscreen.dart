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

  List<Location>? locations;
  List<Tag>? tags;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    locations = await SqliteService.getLocationItems();
    //tags = await SqliteService.getTagItems();
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
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: (locations != null) ? locations!.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 50,
            //color: Colors.amber[colorCodes[index]],
            child: Center(
                child: Text('Entry ${(locations != null) ? locations![index].title : ''}')
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      ),
    );
  }
}