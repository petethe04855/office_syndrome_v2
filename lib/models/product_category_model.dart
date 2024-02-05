class ProductCategory {
  final String productId;
  final String categoryName;
  final String categoryImage;
  final String
      categoryId; // เพิ่ม field categoryId เพื่อทำการเชื่อมโยงกับ Brand
  final String description;
  final String round;
  final String videoUrl;

  ProductCategory({
    required this.productId,
    required this.categoryName,
    required this.categoryImage,
    required this.categoryId,
    required this.description,
    required this.round,
    required this.videoUrl,
  });
}
