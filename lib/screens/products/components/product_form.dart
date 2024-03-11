import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/models/product_category_model.dart';
import 'package:office_syndrome_v2/screens/products/components/product_video.dart';
import 'package:office_syndrome_v2/services/product_service.dart';

class ProductForm extends StatefulWidget {
  final String brandsId;
  final String categoryId;

  const ProductForm({
    required this.brandsId,
    required this.categoryId,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final ProductService _productService = ProductService();

  late List<ProductCategory> _productsCategory = [];

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    try {
      List<ProductCategory> productsCategory =
          await _productService.getProductsCategory();

      _productsCategory = _productService.getFilteredProducts(
          widget.brandsId, productsCategory);

      setState(() {});
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Form'),
      ),
      body: ListView.builder(
        itemCount: _productsCategory.length,
        itemBuilder: (context, index) {
          ProductCategory product = _productsCategory[index];
          if (product.isApprove) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(product.categoryImage),
                ),
                title: Text(product.categoryName),
                // Add other widgets or navigate to product_video as needed
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductVideo(
                        productCategory: product,
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            // ถ้า videoAvailable เป็น false ให้ return Container() หรือสิ่งที่ไม่แสดงผล
            return Container();
          }
        },
      ),
    );
  }
}
