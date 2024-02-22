import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/models/location_model.dart';
import 'package:office_syndrome_v2/screens/regions/region_map_screen.dart';
import 'package:office_syndrome_v2/services/region_service.dart';

class RegionScreen extends StatefulWidget {
  const RegionScreen({super.key});

  @override
  State<RegionScreen> createState() => _RegionScreenState();
}

class _RegionScreenState extends State<RegionScreen> {
  final RegionService _regionService = RegionService();
  late List<LocationsModel> _regionsAll = [];
  final _searchController = TextEditingController();
  // Toggle between ListView and GridView
  bool _isGridView = true;

  String _searchQuery = '';

  Future<void> _getAllRegions() async {
    try {
      // Attempt to get all products using the _productService
      List<LocationsModel> getAll = await _regionService.getProductsCategory();

      // If successful, update the state with the received data
      setState(() {
        _regionsAll = getAll;
      });
    } catch (e) {
      // If an error occurs during the fetch operation, print the error message
      print("Error fetching data: $e");
    }
  }

  // สร้างฟังก์ชันสลับระหว่าง ListView และ GridView
  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllRegions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regions All'),
        actions: [
          IconButton(
            onPressed: _toggleView,
            icon: Icon(_isGridView ? Icons.list_outlined : Icons.grid_view,
                color: Colors.white),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            CupertinoSearchTextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase().trim();
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: _isGridView ? _gridView() : _ListView(),
            ),
          ],
        ),
      ),
    );
  }

  // ListView Widget -----------------------------------------
  Widget _ListView() {
    // Filter locations based on search query
    List<LocationsModel> filteredRegions = _regionsAll
        .where((location) =>
            location.locaName.toLowerCase().contains(_searchQuery))
        .toList();

    return ListView.builder(
      itemCount: filteredRegions.length,
      itemBuilder: (context, index) {
        LocationsModel regionsAll = filteredRegions[index];
        return Card(child: _listItem(regionsAll));
      },
    );
  }

  Widget _gridView() {
    // Filter locations based on search query
    List<LocationsModel> filteredRegions = _regionsAll
        .where((location) =>
            location.locaName.toLowerCase().contains(_searchQuery))
        .toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        mainAxisExtent: 200,
      ),
      itemCount: filteredRegions.length,
      itemBuilder: (context, index) {
        LocationsModel regionsAll = filteredRegions[index];
        return Card(child: _listItem(regionsAll));
      },
    );
  }

  // ListTile แสดงวิดีโอ
  Widget _listItem(LocationsModel AllRegion) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/images/noavartar.png'),
      ),
      title: Text(AllRegion.locaName, style: TextStyle(fontSize: 14)),
      subtitle: Text(""),
      trailing: IconButton(
          onPressed: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => ProductVideo(
            //         productCategory: AllProduct,
            //       ),
            //     ));
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegionMapScreen(regionData: AllRegion),
                ));
          },
          icon: Icon(Icons.chevron_right)),
    );
  }
}
