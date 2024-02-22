import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/models/location_model.dart';
import 'package:office_syndrome_v2/screens/regions/region_map_screen.dart';
import 'package:office_syndrome_v2/services/region_service.dart';

class RegionFormScreen extends StatefulWidget {
  final String regionId;
  final String locationId;

  const RegionFormScreen({
    required this.regionId,
    required this.locationId,
    Key? key,
  }) : super(key: key);

  @override
  State<RegionFormScreen> createState() => _RegionFormScreenState();
}

class _RegionFormScreenState extends State<RegionFormScreen> {
  final RegionService _locationsService = RegionService();
  late List<LocationsModel> _locationsModel = [];

  @override
  void initState() {
    _getAllRegions();
    super.initState();
  }

  Future<void> _getAllRegions() async {
    try {
      // Attempt to get all products using the _productService
      List<LocationsModel> getAll =
          await _locationsService.getProductsCategory();

      _locationsModel =
          _locationsService.getFilteredRegion(widget.regionId, getAll);
      setState(() {});
    } catch (e) {
      // If an error occurs during the fetch operation, print the error message
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("widget.regionId ${widget.regionId}");
    print("_locationsModel ${_locationsModel.length}");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Region Form'),
      ),
      body: ListView.builder(
        itemCount: _locationsModel.length,
        itemBuilder: (context, index) {
          LocationsModel locations = _locationsModel[index];

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(locations.locaImage),
              ),
              title: Text(locations.locaName),
              // Add other widgets or navigate to product_video as needed
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegionMapScreen(
                      regionData: locations,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
