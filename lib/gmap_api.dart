import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  // void _onMapCreated(GoogleMapController controller) {
  //   myController = controller;
  // }

  @override
  void initState() {
    super.initState();
    LatLng cPosition = LatLng(widget.latlng[0], widget.latlng[1]);

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
