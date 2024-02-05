// ignore_for_file: prefer_const_constructors

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
      body: _isGridView ? _gridView() : _ListView(),
    );
  }

  // ListView Widget -----------------------------------------
  Widget _ListView() {
    return ListView.builder(
      itemCount: _productsAllCategory.length,
      itemBuilder: (context, index) {
        ProductCategory AllProduct = _productsAllCategory[index];
        return Card(child: _listItem(AllProduct));
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
      itemCount: _productsAllCategory.length,
      itemBuilder: (context, index) {
        ProductCategory AllProduct = _productsAllCategory[index];
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
                ));
          },
          icon: Icon(Icons.chevron_right)),
    );
  }
}
