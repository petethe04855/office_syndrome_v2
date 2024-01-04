import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:office_syndrome_v2/models/brand_model.dart';
import 'package:office_syndrome_v2/models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> getProducts() async {
    QuerySnapshot productSnapshot =
        await _firestore.collection('ProductCategory').get();

    List<Product> products = productSnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Product(
          categoryId: data['categoryId'],
          productId: data['productId'],
          name: data['name']);
    }).toList();

    return products;
  }

  Future<List<Brand>> getBrands() async {
    QuerySnapshot brandSnapshot =
        await _firestore.collection('BrandCategory').get();

    List<Brand> brands = brandSnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Brand(
        brandId: doc.id,
        categoryId: data['categoryId'],
      );
    }).toList();

    return brands;
  }
}
