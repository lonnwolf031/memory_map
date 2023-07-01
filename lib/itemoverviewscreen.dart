import 'package:flutter/material.dart';
import 'package:memory_map/data/locationdata.dart';
import 'data/sqliteservice.dart';
import 'data/tagdata.dart';

enum SortItem {city, country, tag}

class ItemOverviewScreen extends StatefulWidget {

  const ItemOverviewScreen({super.key});

  @override
  State<ItemOverviewScreen> createState() => _CreateOverviewState();
}

class _CreateOverviewState extends State<ItemOverviewScreen> {

  List<Location>? locations;
  List<Tag>? tags;

  SortItem? selectedMenu;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var newlocations = await SqliteService.getLocationItems();
    setState(() {
      locations = newlocations;
    });
    //tags = await SqliteService.getTagItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Overview"),
          actions: <Widget>[
            PopupMenuButton<SortItem>(
              initialValue: selectedMenu,
              // Callback that sets the selected popup menu item.
              onSelected: (SortItem item) {
                setState(() {
                  selectedMenu = item;
                });
                if(selectedMenu == SortItem.country) {
                  setState(() {

                  });
                }
                else if (selectedMenu == SortItem.city) {
                  setState(() {

                  });
                }
                else if(selectedMenu == SortItem.tag) {
                    setState(() {

                    });
                }},
              itemBuilder: (BuildContext context) => <PopupMenuEntry<SortItem>>[
                const PopupMenuItem<SortItem>(
                  value: SortItem.city,
                  child: Row(
                    children: <Widget>[
                      Text('City'),
                    ],
                  ),
                ),
                const PopupMenuItem<SortItem>(
                  value: SortItem.country,
                  child: Row(
                    children: <Widget>[
                      Text('Country'),
                    ],
                  ),
                ),
                const PopupMenuItem<SortItem>(
                  value: SortItem.tag,
                  child:  Row(
                    children: <Widget>[
                      Text('Tag'),
                    ],
                  ),
                ),
              ],
            ),
          ],
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