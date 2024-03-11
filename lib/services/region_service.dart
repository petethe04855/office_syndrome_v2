import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:office_syndrome_v2/models/location_model.dart';
import 'package:office_syndrome_v2/models/region_model.dart';

class RegionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<LocationsModel>> getAllRegion() async {
    QuerySnapshot regionSnapshot =
        await _firestore.collection('regionLocation').where('locaName').get();

    List<LocationsModel> locationsList = regionSnapshot.docs.map((doc) {
      return LocationsModel(
        locationId: doc.id,
        locaName: doc['locaName'],
        locaDes: doc['locaDes'],
        locaImage: doc['locaImage'],
        phone: doc['phone'],
        locaLatitude: doc['locaLatitude'],
        locaLongitude: doc['locaLongitude'],
      );
    }).toList();

    return locationsList;
  }

  Future<List<LocationsModel>> getProductsCategory() async {
    QuerySnapshot productSnapshot =
        await _firestore.collection('regionLocation').where('locaName').get();

    List<LocationsModel> productsCategory = productSnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return LocationsModel(
        locationId: data['locationId'],
        locaName: data['locaName'],
        locaDes: data['locaDes'],
        locaImage: data['locaImage'],
        phone: data['phone'],
        locaLatitude: data['locaLatitude'],
        locaLongitude: data['locaLongitude'],
      );
    }).toList();

    return productsCategory;
  }

  // เพิ่มข้อมูล เข้าใน regionLocation

  Future<void> addToRegionLocation(
    currentUser,
    String regionId,
    String regionName,
    String name,
    String phone,
    String address,
    LatLng draggedLatlng,
    File? _imageFile,
  ) async {
    try {
      // Firestore collection references

      CollectionReference regionLocationCollection =
          FirebaseFirestore.instance.collection('regionLocation');

      final imageFile = _imageFile;
      final imageName = currentUser;
      final imageRef = FirebaseStorage.instance
          .ref()
          .child('map/รูปสถานที่กายภาพ/$regionName/$imageName.jpg');

      await imageRef.putFile(imageFile!);

      final imageUrl = await imageRef.getDownloadURL();

      // Check if the regionId exists in the 'regionLocation' collection
      var locationDoc = await regionLocationCollection.doc(regionId).get();
      if (!locationDoc.exists) {
        // If not exists, add the document to 'regionLocation'
        await regionLocationCollection.doc().set({
          'locationId': regionId,
          'phone': phone,
          'locaName': name,
          'locaDes': address,
          'locaLatitude': draggedLatlng.latitude,
          'locaLongitude': draggedLatlng.longitude,
          'uidUpLoad': currentUser,
          'locaImage': imageUrl,

          // Add other fields as needed
        });
        print('add data to regionLocation collection successfully');
      } else {
        print('regionId already exists in Firestore regionLocation collection');
      }
    } catch (e) {
      print('Error sending data to Firestore: $e');
    }
  }

  // ดึงข้อมูลจาก region id

  Future<List<Region>> getRegionsId() async {
    QuerySnapshot regionSnapshot = await _firestore.collection('region').get();

    List<Region> regionList = regionSnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Region(
        locationId: doc.id,
        regionName: data['regionName'],
        regionId: data['regionId'],
      );
    }).toList();

    return regionList;
  }

  List<LocationsModel> getFilteredRegion(
      String regionId, List<LocationsModel> allLocations) {
    return allLocations.where((region) {
      return region.locationId == regionId;
    }).toList();
  }
}
