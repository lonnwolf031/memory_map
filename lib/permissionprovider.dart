import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart'
as location_package;

class LatLng {
  double lat;
  double long;
  LatLng(this.lat, this.long);
}

enum AppPermissions {
  granted,
  denied,
  restricted,
  permanentlyDenied,
}

class AppPermissionProvider with ChangeNotifier {
  // Start with default permission status i.e denied
  PermissionStatus _locationStatus = PermissionStatus.denied;

  // Create a LatLng type that'll be user location
  LatLng? _locationCenter;
  // Initiate location from location package
  final location_package.Location _location = location_package.Location();
  location_package.LocationData? _locationData;

  // Getter
  get location => _location;
  get locationStatus => _locationStatus;
  get locationCenter => _locationCenter as LatLng;

  Future<PermissionStatus> getLocationStatus() async {
    // Request for permission
    final status = await Permission.location.request();
    // change the location status
    _locationStatus = status;
    // notiy listeners
    notifyListeners();
    print(_locationStatus);
    return status;
  }

  Future<void> getLocation() async {
    // Call Location status function here
    final status = await getLocationStatus();
    print("I am insdie get location");
    // if permission is granted or limited call function
    if (status == PermissionStatus.granted ||
        status == PermissionStatus.limited) {
      try {
        // assign location data that's returned by Location package
        _locationData = await _location.getLocation();
        // Check for null values
        final lat = _locationData != null
            ? _locationData!.latitude as double
            : "Not available";
        final lon = _locationData != null
            ? _locationData!.longitude as double
            : "Not available";

        if(_locationData != null &&
          _locationData!.latitude != null ) {
          _locationCenter = LatLng(_locationData!.latitude!, _locationData!.longitude!);
        }
      } catch (e) {
        // in case of error location will be null
        _locationCenter = null;
        rethrow;
      }
    }
// Notify listeners
    notifyListeners();
  }
}
