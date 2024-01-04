import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/models/product_model.dart';
import 'package:office_syndrome_v2/services/product_service.dart';
import 'package:office_syndrome_v2/utils/utility.dart';

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
  late List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // Fetch products from your service or repository
    List<Product> products = await ProductService().getProducts();

    // Filter products based on brandsId and categoryId
    _products =
        _getFilteredProducts(widget.brandsId, widget.categoryId, products);

    // Set the state to trigger a rebuild with the filtered products
    setState(() {});
  }

  List<Product> _getFilteredProducts(
      String brandId, String categoryId, List<Product> allProducts) {
    return allProducts.where((product) {
      return product.categoryId == brandId && product.productId == categoryId;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          Product product = _products[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/noavartar.png'),
            ),
            subtitle: Text(product.categoryId),
            title: Text(product.name),
            trailing: Icon(Icons.chevron_right),
          );
        },
      ),
    );
  }

  Widget _ListView() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return OpenContainer(
          transitionType: ContainerTransitionType.fade,
          // transitionDuration กำหนดควาามเร็ว animation
          transitionDuration: Duration(milliseconds: 600),
          closedBuilder: (context, action) {
            return _listItem();
          },
          openBuilder: (context, action) {
            return Container();
          },
        );
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
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          child: OpenContainer(
            transitionType: ContainerTransitionType.fade,
            // transitionDuration กำหนดควาามเร็ว animation
            transitionDuration: Duration(milliseconds: 600),
            closedBuilder: (context, action) {
              return _listItem();
            },
            openBuilder: (context, action) {
              return Container();
            },
          ),
        );
      },
    );
  }

// ListTile แสดงวิดีโอ
  Widget _listItem() {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/images/noavartar.png'),
      ),
      subtitle: Text("brands[widget.index].brandId"),
      title: Text("brands[widget.index].brandName"),
      trailing: Icon(Icons.chevron_right),
    );
  }
}
