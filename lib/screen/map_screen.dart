import 'package:app_map/helpers/location_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

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
        fit: StackFit.expand,
        children: [
          position == null
              ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ))
              : buildMap(),
          buildFloatingSearchBar(),

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

  Widget buildFloatingSearchBar() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            /*child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color);
              }).toList(),
            ),*/
          ),
        );
      },
    );
  }
}
