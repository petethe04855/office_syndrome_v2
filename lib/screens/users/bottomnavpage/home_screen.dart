import 'dart:io';

import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/app_router.dart';
import 'package:office_syndrome_v2/models/brand_category_model.dart';
import 'package:office_syndrome_v2/models/region_model.dart';
import 'package:office_syndrome_v2/screens/products/components/product_form.dart';
import 'package:office_syndrome_v2/screens/regions/region_form.dart';
import 'package:office_syndrome_v2/screens/register/components/register_image.dart';
import 'package:office_syndrome_v2/services/product_service.dart';
import 'package:office_syndrome_v2/services/region_service.dart';
import 'package:office_syndrome_v2/themes/colors.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  final RegionService _regionService = RegionService();
  late List<BrandCategory> _brands = [];
  late List<Region> _regions = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchRegion();
  }

  Future<void> _fetchData() async {
    try {
      List<BrandCategory> brands = await _productService.getBrands();

      setState(() {
        _brands = brands;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: primaryLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage(
                                  'assets/images/1701790858283.jpeg',
                                ),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text("ชื่ออหัวข้อ", style: TextStyle(fontSize: 24)),
                        ],
                      ),
                      Text("data--------------------------")
                    ],
                  ),
                ),
              ),
              Card(
                color: primaryLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRouter.productItem);
                          },
                          child: Text(
                            "แสดงทั้งหมด",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        height: 200,
                        child: _buildProductCards(),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: primaryLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRouter.region);
                          },
                          child: Text(
                            "แสดงทั้งหมด",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        height: 200,
                        child: _buildRegionList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCards() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: _brands.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: Card(
              child: Container(
                height: 200,
                width: 200,
                child: Column(
                  children: [
                    Text(_brands[index].brandName),
                    Text(_brands[index].categoryId),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductForm(
                    categoryId: _brands[index].categoryId,
                    brandsId: _brands[index].brandId,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _listItemHomeScreen(brands, categoryId) {
    return Container(
      height: 300,
      width: 200,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/images/noavartar.png'),
        ),
        title: Text(brands),
        subtitle: Text(categoryId),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildRegionList() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: _regions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: Card(
              child: Container(
                height: 200,
                width: 200,
                child: Column(
                  children: [
                    Text(_regions[index].locationId),
                    Text(_regions[index].regionName),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegionFormScreen(
                    locationId: _regions[index].locationId,
                    regionId: _regions[index].regionId,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
