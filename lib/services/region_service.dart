import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:office_syndrome_v2/models/location_model.dart';
import 'package:office_syndrome_v2/models/region_model.dart';

class RegionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Region>> getRegions() async {
    QuerySnapshot regionSnapshot = await _firestore.collection('region').get();

    List<Region> region = regionSnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Region(
        locationId: doc.id,
        regionName: data['regionName'],
        regionId: data['regionId'],
      );
    }).toList();

    return region;
  }

  Future<List<LocationsModel>> getAllRegion() async {
    QuerySnapshot regionSnapshot =
        await _firestore.collection('regionLocation').get();

    List<LocationsModel> locationsList = [];

    regionSnapshot.docs.forEach((doc) {
      locationsList.add(LocationsModel(
        locationId: doc.id,
        locaName: doc['locaName'],
        locaDes: doc['locaDes'],
        locaImage: doc['locaImage'],
        phone: doc['phone'],
        locaLatitude: doc['locaLatitude'],
        locaLongitude: doc['locaLongitude'],
      ));
    });

    return locationsList;
  }
}
