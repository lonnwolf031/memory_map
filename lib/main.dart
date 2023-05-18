import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:memory_map/createItemScreen.dart';
import 'package:memory_map/searchlocation.dart';
import 'package:memory_map/utilities.dart';
import 'sqliteservice.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MemoryMapApp());
}

enum MenuItem { selectLocation, info, settings }

class MemoryMapApp extends StatelessWidget {
  const MemoryMapApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory map',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MemoryMapHomePage(title: 'Memory map'),
    );
  }
}

class MemoryMapHomePage extends StatefulWidget {
  const MemoryMapHomePage({super.key, required this.title});

  final String title;

  @override
  State<MemoryMapHomePage> createState() => _MemoryMapHomePageState();
}

class _MemoryMapHomePageState extends State<MemoryMapHomePage> {

  MenuItem? selectedMenu;

  MapController mapController = MapController(
    initMapWithUserPosition: false,
    initPosition: GeoPoint(latitude:  4.9041, longitude: 52.3676),
    areaLimit: const BoundingBox.world(),
  );

  menuAction() {
    switch(selectedMenu) {
      case MenuItem.settings:
        break;
      case MenuItem.info:
        _showBasicDialog("Information", "${Utilities.appInfo}\n${Utilities.copyrightInfo}");
        break;
    }
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
          actions: <Widget>[
            PopupMenuButton<MenuItem>(
              initialValue: selectedMenu,
              // Callback that sets the selected popup menu item.
              onSelected: (MenuItem item) {
                setState(() {
                  selectedMenu = item;
                });
                menuAction();
                if(selectedMenu == MenuItem.selectLocation) {
                  _handleLocationSelection(context);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
                PopupMenuItem<MenuItem>(
                  value: MenuItem.selectLocation,
                  child: Row(
                    children: const <Widget>[
                      Icon(Icons.search, color: Colors.black),
                      Text(' Find location'),
                    ],
                  ),
                ),
                PopupMenuItem<MenuItem>(
                  value: MenuItem.settings,
                  child:  Row(
                    children: const <Widget>[
                      Icon(Icons.settings, color: Colors.black),
                      Text(' Settings'),
                    ],
                  ),
                ),
                PopupMenuItem<MenuItem>(
                  value: MenuItem.info,
                  child: Row(
                      children: const <Widget>[
                      Icon(Icons.info, color: Colors.black),
                      Text(' Info'),
                    ],
            ),
                ),
              ],
            ),
            ],
      ),
      body: Stack(
        children: <Widget>[
          OSMFlutter(
            controller: mapController,
            trackMyPosition: true,
            onGeoPointClicked: (p) =>  _handleMarkerClicked(p),
            initZoom: 15,
            stepZoom: 1.0,
            userLocationMarker: UserLocationMaker(
              personMarker: const MarkerIcon(
                icon: Icon(
                  Icons.location_history_rounded,
                  color: Colors.black,
                  size: 48,
                ),
              ),
              directionArrowMarker: const MarkerIcon(
                icon: Icon(
                  Icons.double_arrow,
                  size: 48,
                ),
              ),
            ),
            markerOption: MarkerOption(
                defaultMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.person_pin_circle,
                    color: Colors.blue,
                    size: 56,
                  ),
                )
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add your onPressed code here!
          GeoPoint geoPoint = await mapController.myLocation();
          await mapController.goToLocation(geoPoint);
          //await mapController.currentLocation();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.location_searching),
      ),
    );
  }

  Future<void> _handleMarkerClicked(GeoPoint point) async {
    // Declaring and Initializing OverlayState
    // and OverlayEntry objects
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("Save new location?"),
            children: <Widget>[
              Text(point.latitude.toString()),
              ElevatedButton(
                  child: const Text('Search'),
                  onPressed: () {
                    setState(() {

                    });
                    _createNewItem(context, point);
                  },
              ),
            ],
          );
        });
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog( // <-- SEE HERE
          title: const Text('Cancel booking'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure want to cancel?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _createNewItem(BuildContext context, GeoPoint point) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateItemScreen(location: point)),
    );
  }

  Future<void> _handleLocationSelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectLocationScreen(controller: mapController)),
    );

    var location = Utilities.castOrNull<SearchInfo>(result);
    if(location != null) {
      // do something
      await mapController.changeLocation(location.point!);
    }
  }

  Future<void> _showBasicDialog(String title, String text) async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(title),
            children: <Widget>[
              Text(text)
            ],
          );
        });
  }

}

