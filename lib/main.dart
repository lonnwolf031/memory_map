import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:memory_map/createitemscreen.dart';
import 'package:memory_map/itemoverviewscreen.dart';
import 'package:memory_map/searchlocation.dart';
import 'package:memory_map/utilities.dart';
import 'data/sqliteservice.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MemoryMapApp());
}

enum MenuItem { selectLocation, overview, info, settings }

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

class _MemoryMapHomePageState extends State<MemoryMapHomePage> with OSMMixinObserver{

  MenuItem? selectedMenu;
  late GlobalKey<ScaffoldState> scaffoldKey;
  Key mapGlobalkey = UniqueKey();
  GeoPoint? userLocation;

  MapController mapController = MapController(
    initMapWithUserPosition: false,
    initPosition: GeoPoint(latitude:  52.3676, longitude: 4.9041),
    areaLimit: const BoundingBox.world(),
  );


  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      await mapIsInitialized();
    }
    await loadMarkersFromDb();
  }

  Future<void> mapIsInitialized() async {
    await mapController.setZoom(zoomLevel: 12);
  }

  Future<void> loadMarkersFromDb() async {
    var items = await SqliteService.getLocationItems();
    for (var item in items) {
      var lat = double.tryParse(item.lat);
      var lon = double.tryParse(item.lon);
      if (lat != null && lon != null) {
        mapController.addMarker(GeoPoint(latitude: lat, longitude: lon ));
        mapController.changeLocation(GeoPoint(latitude: lat, longitude: lon  ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // TODO get user location
    mapController.addObserver(this);

    scaffoldKey = GlobalKey<ScaffoldState>();

    mapController.listenerMapLongTapping.addListener(() async {
      if (mapController.listenerMapLongTapping.value != null) {
        print(mapController.listenerMapLongTapping.value);
        await mapController.addMarker(
          mapController.listenerMapLongTapping.value!,
          markerIcon: MarkerIcon(
            iconWidget: SizedBox.fromSize(
              size: Size.square(32),
              child: const Stack(
                children: [
                  Icon(
                    Icons.store,
                    color: Colors.brown,
                    size: 32,
                  ),
                  Text(
                    "foo",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          //angle: pi / 3,
        );
      }
    });
  }

  void getItems() async {
    var outRes = await SqliteService.getLocationItems();
    for (var item in outRes) {
      print(item.id);
      print(item.title);
    }
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
                if(selectedMenu == MenuItem.selectLocation) {
                  _handleLocationSelection(context);
                }
                else if (selectedMenu == MenuItem.overview) {
                  _goToOverview(context);
                }
                else if(selectedMenu == MenuItem.settings) {
                  // temp
                  getItems();
                }
                else if (selectedMenu == MenuItem.info) {
                  _showBasicDialog("Information", "${Utilities.appInfo}\n${Utilities.copyrightInfo}");
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
                const PopupMenuItem<MenuItem>(
                  value: MenuItem.selectLocation,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.search, color: Colors.black),
                      Text(' Find location'),
                    ],
                  ),
                ),
                const PopupMenuItem<MenuItem>(
                  value: MenuItem.overview,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.feed_outlined, color: Colors.black),
                      Text(' Overview'),
                    ],
                  ),
                ),
                const PopupMenuItem<MenuItem>(
                  value: MenuItem.settings,
                  child:  Row(
                    children: <Widget>[
                      Icon(Icons.settings, color: Colors.black),
                      Text(' Settings'),
                    ],
                  ),
                ),
                const PopupMenuItem<MenuItem>(
                  value: MenuItem.info,
                  child: Row(
                      children: <Widget>[
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
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(point.latitude.toString()),
              ),

              Padding (
                padding: const EdgeInsets.all(15),
                child: ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () {
                    setState(() {

                    });
                    _createNewItem(context, point);
                  },
                ),
              ),
              Padding (
                padding: const EdgeInsets.all(15),
                child: ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        });
  }

  Future<void> _createNewItem(BuildContext context, GeoPoint point) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateItemScreen(location: point)),
    );
  }

  Future<void> _goToOverview(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ItemOverviewScreen()),
    );
  }

  Future<void> _handleLocationSelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectLocationScreen(controller: mapController)),
    );

    var location = Utilities.castOrNull<SearchInfo>(result);
    if(location != null) {
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

