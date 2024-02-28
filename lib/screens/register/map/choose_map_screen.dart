import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:geocoding/geocoding.dart';
import 'package:office_syndrome_v2/components/custom_textfield.dart';
import 'package:office_syndrome_v2/themes/colors.dart';

class ChooseMapScreen extends StatefulWidget {
  const ChooseMapScreen({super.key});

  @override
  State<ChooseMapScreen> createState() => _ChooseMapScreenState();
}

class _ChooseMapScreenState extends State<ChooseMapScreen> {
  // ดึงค่า map controller มาใช้
  Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();
  CameraPosition? _cameraPosition;
  late LatLng _defaultLatLng;
  late LatLng _draggedLatlng;
  String _draggedAddress = "";

  final _addressController = TextEditingController();
  final _localityController = TextEditingController();
  final _administrativeAreaController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    _defaultLatLng = LatLng(11, 104);
    _draggedLatlng = _defaultLatLng;
    _cameraPosition = CameraPosition(
      target: _defaultLatLng,
      zoom: 17.4746,
    );

    // map will redirect ot my current location when loaded
    _gotoUserCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _gotoUserCurrentPosition();
        },
        child: Icon(Icons.location_on),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _showBottomSheet();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        _getMap(),
        _getCustomPin(),
        _showDraggedAddress(),
      ],
    );
  }

  Widget _showDraggedAddress() {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Center(
          child: Text(
            _draggedAddress,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _getMap() {
    return GoogleMap(
      initialCameraPosition: _cameraPosition!,
      mapType: MapType.normal,
      onCameraIdle: () {
        // ฟังก์ชั่นนี้จะเริ่มทำงานเมื่อผู้ใช้หยุดการลากบนแผนที่

        _getAddress(_draggedLatlng);
      },
      onCameraMove: (cameraPosition) {
        // ฟังก์ชั่นนี้จะเริ่มทำงานเมื่อผู้ใช้ลากบนแผนที่
        // every time user drag this will get value
        _draggedLatlng = cameraPosition.target;
      },
      onMapCreated: (GoogleMapController controller) {
        // ฟังก์ชั่นนี้จะเริ่มทำงานเมื่อโหลดแผนที่จนเต็ม
        if (!_googleMapController.isCompleted) {
          // ตั้งค่าคอนโทรลเลอร์เป็น google map เมื่อ
          _googleMapController.complete(controller);
        }
      },
    );
  }

  Widget _getCustomPin() {
    return Center(
      child: Container(
        width: 100,
        child: Icon(Icons.location_on),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.add_location),
                title: Text('Add Location to Firestore'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  openDialog();
                  _addCurrentAddress();
                },
              ),
              // Add more options as needed
            ],
          ),
        );
      },
    );
  }

  void _addCurrentAddress() {
    // Handle the logic to save or use the current address as needed.
    print('Current Address: ${_draggedAddress}');

    // Add your logic here, e.g., save to storage or use the address in some way.
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("ที่อยู่"),
          content: Container(
            height: 300,
            width: 300,
            child: Column(
              children: [
                customTextField(
                  controller: _addressController,
                  hintText: "ที่อยู่",
                  prefixIcon: Icon(Icons.home),
                  obscureText: false,
                  validator: (p0) {},
                ),
                customTextField(
                  controller: _localityController,
                  hintText: "ที่อยู่",
                  prefixIcon: Icon(Icons.home),
                  obscureText: false,
                  validator: (p0) {},
                ),
                customTextField(
                  controller: _administrativeAreaController,
                  hintText: "ที่อยู่",
                  prefixIcon: Icon(Icons.home),
                  obscureText: false,
                  validator: (p0) {},
                ),
                customTextField(
                  controller: _countryController,
                  hintText: "ที่อยู่",
                  prefixIcon: Icon(Icons.home),
                  obscureText: false,
                  validator: (p0) {},
                ),
              ],
            ),
          ),
        ),
      );

  Future _getAddress(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark address = placemarks[0];
    String addresStr =
        "${address.street}, ตำบล ${address.subLocality}, อำเภอ ${address.locality}, ${address.administrativeArea} ${address.postalCode}, ${address.country}";

    setState(() {
      _draggedAddress = addresStr;
      _addressController.text = address.street!;
      _localityController.text = address.locality!;
      _administrativeAreaController.text = address.administrativeArea!;
      _countryController.text = address.country!;
    });
  }

  Future _gotoUserCurrentPosition() async {
    Position currentPosition = await _determineUserCurrentPosition();
    _gotoSpecificPosition(
        LatLng(currentPosition.latitude, currentPosition.longitude));
  }

  Future _gotoSpecificPosition(LatLng position) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 17.5)));
    // every time that we dragged pin , it will list down the address here
    await _getAddress(position);
  }

  Future _determineUserCurrentPosition() async {
    LocationPermission locationPermission;
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      print("user don't enable location permission");
    }

    locationPermission = await Geolocator.checkPermission();

    // ตรวจสอบว่าผู้ใช้ปฏิเสธตำแหน่งแล้วลองขออนุญาตอีกครั้ง

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        print("user denied permission forever");
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }
}
