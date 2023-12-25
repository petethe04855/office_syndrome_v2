// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:office_syndrome_v2/screens/products/components/product_form.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({super.key});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  int _listProductItem = 10;

  // Toggle between ListView and GridView
  bool _isGridView = true;

  // สร้างฟังก์ชันสลับระหว่าง ListView และ GridView
  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProductItem'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
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
      itemCount: _listProductItem,
      itemBuilder: (context, index) {
        return OpenContainer(
          transitionType: ContainerTransitionType.fade,
          // transitionDuration กำหนดควาามเร็ว animation
          transitionDuration: Duration(milliseconds: 600),
          closedBuilder: (context, action) {
            return _listItem();
          },
          openBuilder: (context, index) {
            return ProductForm();
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
      itemCount: _listProductItem,
      itemBuilder: (context, index) {
        return Card(
          child: OpenContainer(
            transitionType: ContainerTransitionType.fade,
            // transitionDuration กำหนดควาามเร็ว animation
            transitionDuration: Duration(milliseconds: 600),
            closedBuilder: (context, action) {
              return _listItem();
            },
            openBuilder: (context, index) {
              return ProductForm();
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
      subtitle: Text("subtitle"),
      title: Text("title"),
      trailing: Icon(Icons.chevron_right),
    );
  }
}
