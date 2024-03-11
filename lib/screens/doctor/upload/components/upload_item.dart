import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/models/product_category_model.dart';

class UploadItem extends StatelessWidget {
  final ProductCategory product;
  final VoidCallback? onTap;
  final bool? isGrid;
  const UploadItem({
    required this.product,
    this.onTap,
    this.isGrid,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UploadItem'),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
