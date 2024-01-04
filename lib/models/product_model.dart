class Product {
  final String productId;
  final String
      categoryId; // เพิ่ม field categoryId เพื่อทำการเชื่อมโยงกับ Brand
  final name;

  Product({
    required this.name,
    required this.productId,
    required this.categoryId,
  });
}
