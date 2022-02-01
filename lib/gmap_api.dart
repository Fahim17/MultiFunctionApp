import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:multifuncapp/location_api.dart';

class GMap extends StatefulWidget {
  List latlng;
  GMap({Key? key, required this.latlng}) : super(key: key);

  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  // late GoogleMapController myController;

  late CameraPosition position;
  final Set<Marker> markers = Set();
  late Location locationLive;

  // void _onMapCreated(GoogleMapController controller) {
  //   myController = controller;
  // }
  _setupLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await locationLive.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await locationLive.requestService();
      if (!_serviceEnabled) {}
    }

    _permissionGranted = await locationLive.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await locationLive.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {}
    }
  }

  @override
  void initState() {
    super.initState();
    //----------------------------------------------------------
    locationLive = Location();
    _setupLoc();
    locationLive.enableBackgroundMode(enable: true);
    locationLive.onLocationChanged.listen((LocationData currentLocation) {
      print('currentLocation: $currentLocation');
    });
    //----------------------------------------------------------
    LatLng cPosition = LatLng(widget.latlng[0], widget.latlng[1]);
    print('cPosition: $cPosition');
    position = CameraPosition(
      target: cPosition,
      zoom: 18,
    );

    markers.add(Marker(
      markerId: const MarkerId("12"),
      position: cPosition,
      infoWindow: InfoWindow(
        title: 'You',
        snippet: 'Coordinates: ${widget.latlng}',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  @override
  void dispose() {
    // myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Multi Function App"),
      ),
      body: GoogleMap(
        // onMapCreated: _onMapCreated,
        initialCameraPosition: position,
        zoomControlsEnabled: false,
        rotateGesturesEnabled: false,
        markers: markers,
      ),
      // body: Container(
      //   color: Colors.tealAccent,
      // ),
    );
  }
}
