import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/models/location_model.dart';
import 'package:office_syndrome_v2/services/region_service.dart';

class RegionScreen extends StatefulWidget {
  const RegionScreen({super.key});

  @override
  State<RegionScreen> createState() => _RegionScreenState();
}

class _RegionScreenState extends State<RegionScreen> {
  final RegionService _regionService = RegionService();
  late List<LocationsModel> _regionsAll = [];
  // Toggle between ListView and GridView
  bool _isGridView = true;

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
    _getAllProducts();
  }

  Future<void> _getAllProducts() async {
    try {
      // Attempt to get all products using the _productService
      List<LocationsModel> getAll = await _regionService.getAllRegion();

      // If successful, update the state with the received data
      setState(() {
        _regionsAll = getAll;
      });
    } catch (e) {
      // If an error occurs during the fetch operation, print the error message
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProductItem'),
        actions: [
          IconButton(
            onPressed: _toggleView,
            icon: Icon(_isGridView ? Icons.list_outlined : Icons.grid_view,
                color: Colors.white),
          )
        ],
      ),
      body: _isGridView ? _gridView() : _ListView(),
    );
  }

  // ListView Widget -----------------------------------------
  Widget _ListView() {
    return ListView.builder(
      itemCount: _regionsAll.length,
      itemBuilder: (context, index) {
        LocationsModel regionsAll = _regionsAll[index];
        return Card(child: _listItem(regionsAll));
      },
    );
  }

  Widget _gridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // จำนวนคอลัมน์
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        mainAxisExtent: 200,
      ),
      itemCount: _regionsAll.length,
      itemBuilder: (context, index) {
        LocationsModel regionsAll = _regionsAll[index];
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
      title: Text(AllRegion.locaName),
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
          },
          icon: Icon(Icons.chevron_right)),
    );
  }
}
