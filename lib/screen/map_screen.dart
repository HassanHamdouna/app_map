import 'package:app_map/helpers/location_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static Position? position;
  static final CameraPosition positionUserCameraPosition = CameraPosition(
      zoom: 16,
      bearing: 0.0,
      tilt: 0.0,
      target: position !=null ? LatLng(position!.latitude, position!.longitude): LatLng(31.557739, 34.469606));

  Future<void> getMyCurrentLocation() async {
    await LocationHelper.determinePosition();
     position = await Geolocator.getLastKnownPosition().whenComplete(() {
      setState(() {});
    });
  }

  late GoogleMapController _googleMapController;

  Set<Marker> markes = <Marker>{};
  Set<Circle> circle = <Circle>{};


  @override
  void initState() {
    super.initState();
    getMyCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          position == null
              ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ))
              : buildMap(),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: FloatingActionButton(
          onPressed: _myCurrentLocation,
          backgroundColor: Colors.lightBlue,
          child: const Icon(Icons.place, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _myCurrentLocation() async {
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(positionUserCameraPosition));
  }

  Widget buildMap() {
    return GoogleMap(
      initialCameraPosition: positionUserCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        setState(() {
          _googleMapController = controller;
        });
      },
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      mapType: MapType.normal,
      markers: markes,
      circles: circle,
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
    );
  }

  void addNewCircles(LatLng position) {
    var newCircle = Circle(
        circleId: CircleId('circal_${circle.length}'),
        visible: true,
        radius: 10,
        strokeWidth: 2,
        strokeColor: Colors.red,
        center: position,
        fillColor: Colors.redAccent);
    setState(() {
      circle.add(newCircle);
    });
  }

  void addNewMarker(LatLng position) {
    var newMarker = Marker(
      markerId: MarkerId('marker_${markes.length}'),
      visible: true,
      position: position,
    );
    setState(() {
      markes.add(newMarker);
    });
  }
}
