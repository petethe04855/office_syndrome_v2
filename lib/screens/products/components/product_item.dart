// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/models/product_category_model.dart';
import 'package:office_syndrome_v2/screens/products/components/product_video.dart';
import 'package:office_syndrome_v2/services/product_service.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({super.key});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  final ProductService _productService = ProductService();
  late List<ProductCategory> _productsAllCategory = [];
  final _searchController = TextEditingController();
  // Toggle between ListView and GridView
  bool _isGridView = true;

  String _searchQuery = '';

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
      List<ProductCategory> getAll = await _productService.getAllProducts();

      // If successful, update the state with the received data
      setState(() {
        _productsAllCategory = getAll;
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
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
              height: 20,
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
    List<ProductCategory> filteredRegions = _productsAllCategory
        .where((location) =>
            location.categoryName.toLowerCase().contains(_searchQuery))
        .toList();

    return ListView.builder(
      itemCount: filteredRegions.length,
      itemBuilder: (context, index) {
        ProductCategory AllProduct = filteredRegions[index];
        return Card(child: _listItem(AllProduct));
      },
    );
  }

  Widget _gridView() {
    List<ProductCategory> filteredRegions = _productsAllCategory
        .where((location) =>
            location.categoryName.toLowerCase().contains(_searchQuery))
        .toList();
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // จำนวนคอลัมน์
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        mainAxisExtent: 200,
      ),
      itemCount: filteredRegions.length,
      itemBuilder: (context, index) {
        ProductCategory AllProduct = filteredRegions[index];
        return Card(child: _listItem(AllProduct));
      },
    );
  }

  // ListTile แสดงวิดีโอ
  Widget _listItem(ProductCategory AllProduct) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/images/noavartar.png'),
      ),
      title: Text(AllProduct.categoryName),
      subtitle: Text(""),
      trailing: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductVideo(
                  productCategory: AllProduct,
                ),
              ),
            );
          },
          icon: Icon(Icons.chevron_right)),
    );
  }
}
