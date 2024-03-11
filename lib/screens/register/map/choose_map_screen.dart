import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:office_syndrome_v2/app_router.dart';
import 'package:office_syndrome_v2/components/custom_textfield.dart';
import 'package:office_syndrome_v2/components/rounded_button.dart';
import 'package:office_syndrome_v2/models/region_model.dart';
import 'package:office_syndrome_v2/screens/register/components/register_image.dart';
import 'package:office_syndrome_v2/services/region_service.dart';

class ChooseMapScreen extends StatefulWidget {
  const ChooseMapScreen({super.key});

  @override
  State<ChooseMapScreen> createState() => _ChooseMapScreenState();
}

class _ChooseMapScreenState extends State<ChooseMapScreen> {
  RegionService _regionService = RegionService();

  final FirebaseAuth _authUser = FirebaseAuth.instance;

  // ดึงค่า map controller มาใช้
  Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();
  CameraPosition? _cameraPosition;
  late LatLng _defaultLatLng;
  late LatLng _draggedLatlng;
  String _draggedAddress = "";

  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _localityController = TextEditingController();
  final _administrativeAreaController = TextEditingController();
  final _countryController = TextEditingController();

  // countText ตัวแปรเก็บค่า TextEditingController ของ อำเภอ จังหวัด และ รหัสไปรษณีย์
  var countText;

  final _chooseMap = GlobalKey<FormState>();

  List<Region> _regions = [];

  String _selectedRegion = "";

  File? _imageFile;

  String? _imageName;

  String selectedRegionId = "";

  String selectedRegionName = "";

  Future<void> _fetchRegion() async {
    try {
      List<Region> regions = await _regionService.getRegionsId();

      setState(() {
        _regions = regions;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    _fetchRegion();
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
        _draggedLatlng = cameraPosition.target;
        print("_draggedLatlng ${_draggedLatlng}");
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

  // Pin icon ที่แสดงกลางแผนที่
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
                  _addCurrentAddress(_draggedLatlng);
                },
              ),
              // Add more options as needed
            ],
          ),
        );
      },
    );
  }

  void _addCurrentAddress(LatLng position) {
    // Handle the logic to save or use the current address as needed.

    print('Current Address: ${_draggedAddress}');

    // Add your logic here, e.g., save to storage or use the address in some way.
  }

  Widget customDropdown() {
    print("_authUser ${_authUser.currentUser!.uid}");
    List<String> _nameRegion =
        _regions.map((region) => region.regionName).toList();

    return DropdownButtonFormField<String>(
      hint: Text(_nameRegion.first),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        isDense: true,
      ),
      items: _regions.map((region) {
        return DropdownMenuItem<String>(
          key: Key(region.regionId),
          child: Text(region.regionName),
          value: region.regionId,
        );
      }).toList(),
      onChanged: (value) async {
        setState(() {
          _selectedRegion = value.toString();
          selectedRegionId = value.toString(); // Set selectedRegionId
          selectedRegionName = _regions
              .firstWhere((region) => region.regionId == value)
              .regionName; // Set selectedRegionName

          print('Selected regionId: $selectedRegionId');
          print('Selected regionName: $selectedRegionName');
        });
      },
    );
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("ที่อยู่"),
          content: Container(
            height: 550,
            width: 300,
            child: SingleChildScrollView(
              child: Form(
                key: _chooseMap,
                child: Column(
                  children: [
                    RegisterImage(
                      image: _imageName,
                      (file) {
                        setState(() {
                          _imageFile = file;
                        });
                      },
                    ),
                    customDropdown(),
                    customTextField(
                      controller: _nameController,
                      hintText: "ชื่อ",
                      prefixIcon: Icon(Icons.home),
                      obscureText: false,
                      validator: (p0) {},
                    ),
                    customTextField(
                      controller: _phoneController,
                      hintText: "เบอร์โทรศัพท์",
                      prefixIcon: Icon(Icons.phone_android),
                      obscureText: false,
                      validator: (p0) {},
                    ),
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
                    RoundedButton(
                      label: 'label',
                      onPressed: () async {
                        countText = "${_addressController.text}"
                            " ${_localityController.text}"
                            "${_administrativeAreaController.text}"
                            "${_countryController.text}";
                        _regionService.addToRegionLocation(
                          _authUser.currentUser!.uid,
                          selectedRegionId,
                          selectedRegionName,
                          _nameController.text,
                          _phoneController.text,
                          countText,
                          _draggedLatlng,
                          _imageFile,
                        );
                        print("countText ${countText}");
                        print("RoundedButton_draggedAddress ${_draggedLatlng}");
                        print("selectedRegionName ${selectedRegionName}");
                        print("selectedRegionId ${selectedRegionId}");
                        Navigator.pushNamed(
                            context, AppRouter.doctorVerifyScreen);
                      },
                      icon: null,
                    )
                  ],
                ),
              ),
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
