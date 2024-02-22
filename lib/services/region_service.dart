import 'package:cloud_firestore/cloud_firestore.dart';
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
