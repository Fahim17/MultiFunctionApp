import 'package:location/location.dart';

class locApi {
  static Location location = Location();

  static late bool _serviceEnabled;
  static late PermissionStatus _permissionGranted;
  static late LocationData _locationData;

  static bool _isSetup = false;

  static void _setup() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    _isSetup = true;
  }

  static List currentlocation() {
    if (!_isSetup) _setup();
    List latLng = [];

    if (_isSetup) {
      latLng.add(_locationData.latitude);
      latLng.add(_locationData.longitude);
    }
    return latLng;
  }
}
