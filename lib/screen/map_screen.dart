import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // ini
  late GoogleMapController _googleMapController;
  final CameraPosition _initialCameraPosition =
      const CameraPosition(target: LatLng(31.515483, 34.439996), zoom: 16);
  Set<Marker> _markes = <Marker>{};
  Set<Circle> _circle = <Circle>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Map'),
        actions: [
          IconButton(
              onPressed: () async {
                var respones = await Permission.location.request();
                if (respones.isGranted) {
                  print('Granted');
                } else if (respones.isDenied) {
                  print('Denied');
                }
              },
              icon: Icon(
                Icons.location_on,
                color: Colors.white,
              ))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _googleMapController = controller;
          });
        },
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        markers: _markes,
        circles: _circle,
        onLongPress: (LatLng position) {
          addNewCircles(position);
        },
        onTap: (LatLng position) {
          addNewMarker(position);
          _googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
                CameraPosition(target: position, zoom: 16)),
          );
        },
      ),
    );
  }

  void addNewCircles(LatLng position) {
    var newCircle = Circle(
        circleId: CircleId('circal_${_circle.length}'),
        visible: true,
        radius: 10,
        strokeWidth: 2,
        strokeColor: Colors.red,
        center: position,
        fillColor: Colors.redAccent);
    setState(() {
      _circle.add(newCircle);
    });
  }

  void addNewMarker(LatLng position) {
    var newMarker = Marker(
      markerId: MarkerId('marker_${_markes.length}'),
      visible: true,
      position: position,
    );
    setState(() {
      _markes.add(newMarker);
    });
  }
}
