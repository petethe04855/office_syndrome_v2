import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/app_router.dart';
import 'package:office_syndrome_v2/models/brand_model.dart';
import 'package:office_syndrome_v2/models/product_model.dart';

import 'package:office_syndrome_v2/screens/products/components/product_form.dart';
import 'package:office_syndrome_v2/services/product_service.dart';
import 'package:office_syndrome_v2/themes/colors.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();

  late List<Product> _products = [];
  late List<Brand> _brands = [];

  int count = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
    print("count $count++");
  }

  Future<void> _fetchData() async {
    List<dynamic> data = await Future.wait(
        [_productService.getProducts(), _productService.getBrands()]);
    setState(() {
      _products = data[0] as List<Product>;
      _brands = data[1] as List<Brand>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                    // Container(
                    //   height: 200,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: ListView.builder(
                    //       shrinkWrap: true,
                    //       scrollDirection: Axis.horizontal,
                    //       itemCount: 10,
                    //       itemBuilder: (context, index) {
                    //         return Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: OpenContainer(
                    //             transitionType: ContainerTransitionType.fade,
                    //             transitionDuration: Duration(
                    //                 milliseconds:
                    //                     1000), // Increase the duration
                    //             closedBuilder: (context, action) {
                    //               return _listItemHomeScreen(

                    //               );
                    //             },
                    //             openBuilder: (context, action) {
                    //               return ProductForm();
                    //             },
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _listItemHomeScreen(id, name) {
  //   return Container(
  //     height: 300,
  //     width: 200,
  //     child: ListTile(
  //       leading: CircleAvatar(
  //         backgroundImage: AssetImage('assets/images/noavartar.png'),
  //       ),
  //       title: Text(id),
  //       subtitle: Text(name),
  //       trailing: Icon(Icons.chevron_right),
  //     ),
  //   );
  // }

  Widget _buildProductCards() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: _brands.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 200,
            width: 200,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/noavartar.png'),
              ),
              subtitle: Text(_brands[index].brandId),
              title: Text(_brands[index].categoryId),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductForm(
                      brandsId: _brands[index].brandId,
                      categoryId: _brands[index].categoryId,
                    ),
                  ),
                );
              },
            ),
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
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/images/noavartar.png'),
        ),
        title: Text(brands),
        subtitle: Text(categoryId),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }

  // Widget _listItemHomeScreen() {
  //   return Container(
  //     height: 300,
  //     width: 200,
  //     child: Column(
  //       children: productList.map((product) {
  //         return ListTile(
  //           leading: CircleAvatar(
  //             backgroundImage: AssetImage('assets/images/noavartar.png'),
  //           ),
  //           title: Text(product.),
  //           subtitle: Text(product.),
  //           trailing: Icon(Icons.chevron_right),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }
}
