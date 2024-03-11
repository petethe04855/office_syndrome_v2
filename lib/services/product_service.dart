import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:office_syndrome_v2/models/brand_category_model.dart';
import 'package:office_syndrome_v2/models/product_category_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        description: doc['description'],
        round: doc['round'],
        videoUrl: doc['video_url'],
        isApprove: doc['isApprove'],
      ));
    });

    return productList;
  }

  Future<List<ProductCategory>> getProductsCategory() async {
    QuerySnapshot productSnapshot = await _firestore
        .collection('ProductCategory')
        .where('categoryName')
        .get();

    List<ProductCategory> productsCategory = productSnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return ProductCategory(
        categoryId: data['categoryId'],
        categoryName: data['categoryName'],
        categoryImage: data['categoryImage'],
        description: data['description'],
        round: data['round'],
        videoUrl: data['video_url'],
        isApprove: data['isApprove'],
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

  Future<void> addToProductCategory(
    currentUser,
    String categoryId,
    String categoryName,
    String name,
    String description,
    String round,
    File? _imageFile,
    File? _videoFile,
  ) async {
    try {
      CollectionReference productCategory =
          FirebaseFirestore.instance.collection('ProductCategory');

      final imageUrl = await _uploadImage(currentUser, _imageFile);
      final videoUrl = _videoFile != null
          ? await _uploadVideo(currentUser, _videoFile)
          : null;
      print("_videoFile ${_videoFile}");

      var locationDoc = await productCategory.doc(categoryId).get();

      if (!locationDoc.exists) {
        await productCategory.add({
          'categoryId': categoryId,
          'categoryImage': imageUrl,
          'categoryName': name,
          'description': description,
          'round': round,
          'video_url': videoUrl,
          'uidUpLoad': currentUser,
        });
        print('add data to ProductCategory collection successfully');
      } else {
        print('data already exists in ProductCategorys collection');
      }
    } catch (e) {
      print('Error sending data to Firestore: $e');
    }
  }

  Future<String> _uploadImage(currentUser, File? _imageFile) async {
    final imageFile = _imageFile;
    final imageName = currentUser;
    final imageRef =
        FirebaseStorage.instance.ref().child('imagesVideo/$imageName.jpg');

    await imageRef.putFile(imageFile!);

    final imageUrl = await imageRef.getDownloadURL();

    return imageUrl;
  }

  Future<String?> _uploadVideo(String currentUser, File? videoFile) async {
    if (videoFile == null) {
      return null; // Handle case where no video is selected
    }

    try {
      // Create a reference to the video file in Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('videos_test/${videoFile.path.split('/').last}');

      // Upload the video file to Firebase Storage
      final uploadTask = storageRef.putFile(videoFile);
      await uploadTask.whenComplete(() {});

      // Get the download URL of the uploaded video
      final downloadUrl = await storageRef.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading video: $e');
      return null;
    }
  }

  List<ProductCategory> getFilteredProducts(
      String brandId, List<ProductCategory> allProducts) {
    return allProducts.where((product) {
      return product.categoryId == brandId;
    }).toList();
  }
}
