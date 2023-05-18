import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:memory_map/searchlocation.dart';
import 'package:memory_map/strings.dart';
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
        primarySwatch: Colors.blue,
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
    initPosition: GeoPoint(latitude: 14.599512, longitude: 120.984222),
    areaLimit: const BoundingBox.world(),
  );

  menuAction() {
    switch(selectedMenu) {
      case MenuItem.settings:
        break;
      case MenuItem.info:
        _showBasicDialog("Information", "${Strings.appInfo}\n${Strings.copyrightInfo}");
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
                  _navigateAndDisplaySelection(context);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
                const PopupMenuItem<MenuItem>(
                  value: MenuItem.selectLocation,
                  child: Text('Select location'),
                ),
                const PopupMenuItem<MenuItem>(
                  value: MenuItem.settings,
                  child: Text('Settings'),
                ),
                const PopupMenuItem<MenuItem>(
                  value: MenuItem.info,
                  child: Text('Information'),
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
            initZoom: 15,
            stepZoom: 1.0,
            userLocationMarker: UserLocationMaker(
              personMarker: const MarkerIcon(
                icon: Icon(
                  Icons.location_history_rounded,
                  color: Colors.red,
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
          await mapController.goToLocation(GeoPoint(latitude: 47.35387, longitude: 8.43609));
          //await mapController.currentLocation();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.navigation),
      ),
    );
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
                Text('Are you sure want to cancel booking?'),
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

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => SelectLocationScreen(controller: mapController)),
    );
  }

  Future<void> _showLocationPicker() async {
    List<SearchInfo> suggestions = await addressSuggestion("address");

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

  Future<void> _showSimpleDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog( // <-- SEE HERE
            title: const Text('Select Booking Type'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('General'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Silver'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Gold'),
              ),
            ],
          );
        });
  }
}

