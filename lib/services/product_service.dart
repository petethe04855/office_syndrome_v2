import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:office_syndrome_v2/models/brand_category_model.dart';
import 'package:office_syndrome_v2/models/product_category_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getBrandIds() async {
    QuerySnapshot brandSnapshot =
        await _firestore.collection('BrandCategory').get();

    return brandSnapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<ProductCategory>> getAllProducts() async {
    QuerySnapshot productSnapshot =
        await _firestore.collection('ProductCategory').get();

    List<ProductCategory> productList = [];

    productSnapshot.docs.forEach((doc) {
      productList.add(ProductCategory(
        // Assuming ProductCategory has a constructor that takes document ID and data
        categoryId: doc.id,
        categoryName: doc['categoryName'],
        categoryImage: doc['categoryImage'],
        productId: doc['productId'],
        description: doc['description'],
        round: doc['round'],
        videoUrl: doc['video_url'],
      ));
    });

    return productList;
  }

  Future<List<String>> getProductIdsByBrandAndCategory(
      String categoryId, String productId) async {
    QuerySnapshot productSnapshot = await _firestore
        .collection('ProductCategory')
        .where('categoryId', isEqualTo: categoryId)
        .where('productId', isEqualTo: productId)
        .get();

    return productSnapshot.docs.map((doc) => doc.id).toList();
  }

  Future<Map<String, dynamic>> getProductDetails(String productId) async {
    DocumentSnapshot productDoc =
        await _firestore.collection('Products').doc(productId).get();

    return productDoc.data() as Map<String, dynamic>;
  }

  Future<List<ProductCategory>> getProductsCategory() async {
    QuerySnapshot productSnapshot =
        await _firestore.collection('ProductCategory').get();

    List<ProductCategory> productsCategory = productSnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return ProductCategory(
        categoryId: data['categoryId'],
        categoryName: data['categoryName'],
        categoryImage: data['categoryImage'],
        productId: data['productId'],
        description: data['description'],
        round: data['round'],
        videoUrl: data['video_url'],
      );
    }).toList();

    return productsCategory;
  }

  Future<List<BrandCategory>> getBrands() async {
    QuerySnapshot brandSnapshot =
        await _firestore.collection('BrandCategory').get();

    List<BrandCategory> brands = brandSnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return BrandCategory(
        brandId: doc.id,
        brandName: data['brandName'],
        categoryId: data['categoryId'],
      );
    }).toList();

    return brands;
  }

  List<ProductCategory> getFilteredProducts(
      String brandId, List<ProductCategory> allProducts) {
    return allProducts.where((product) {
      return product.categoryId == brandId;
    }).toList();
  }
}
