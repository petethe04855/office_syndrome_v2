import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:office_syndrome_v2/models/location_model.dart';

class RegionMapScreen extends StatefulWidget {
  final LocationsModel regionData;
  const RegionMapScreen({
    Key? key,
    required this.regionData,
  }) : super(key: key);

  @override
  State<RegionMapScreen> createState() => _RegionMapScreenState();
}

class _RegionMapScreenState extends State<RegionMapScreen> {
  bool? latitude;
  bool? longitude;
  // CameraPosition? _kLake;
  LocationData? _locationData;
  // LocationData? currentLocation;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Map<String, Marker> _markers = {};

  Future<LocationData> getCurrentLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
      }
      return await location.getLocation();
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LatLng currenntLocation =
        LatLng(widget.regionData.locaLatitude, widget.regionData.locaLongitude);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: currenntLocation, zoom: 14),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          addMarker("test", currenntLocation);
        },
        markers: _markers.values.toSet(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    //  currentLocation = await getCurrentLocation();
    _locationData = await getCurrentLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(
        LatLng(_locationData!.latitude!, _locationData!.longitude!)));
  }

  addMarker(String markerId, LatLng location) async {
    // var markerIcon = await BitmapDescriptor.fromAssetImage(
    //     const ImageConfiguration(), 'assets/images/facebook.png');

    var marker = Marker(
      markerId: MarkerId(markerId),
      position: location,
      infoWindow: InfoWindow(
        title: widget.regionData.locaName,
        snippet: widget.regionData.locaDes,
      ),
      // icon: markerIcon,
    );

    _markers[markerId] = marker;
    setState(() {});
  }
}
