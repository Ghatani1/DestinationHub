import 'package:destination/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Direction extends StatefulWidget {
  const Direction({super.key});

  @override
  State<Direction> createState() => _DirectionState();
}

class _DirectionState extends State<Direction> {
  GoogleMapController? mapController;

  Set<Marker> markers = {};

  LatLng mylocation = LatLng(27.7047139, 85.3295421);
  // final LatLng mylocation = const LatLng(45.521563, -122.677433);
  @override
  void initState() {
    super.initState();
    markers.add(Marker(
      markerId: MarkerId(mylocation.toString()),
      position: mylocation,
      infoWindow:
          InfoWindow(title: 'Gopal Dai ko chatamari', snippet: 'Chatamari'),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimary,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            "DestiNation",
            style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
          ),
        ),
        body: GoogleMap(
          zoomGesturesEnabled: true,
          initialCameraPosition: CameraPosition(
            target: mylocation,
            zoom: 10,
          ),
          markers: markers,
          mapType: MapType.normal,
          onMapCreated: (controller) {
            setState(() {
              mapController = controller;
            });
          },
        ));
  }
}
