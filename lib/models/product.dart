class Product {
  int? proId;
  String? proName;
  String? proDescription;
  double? price;
  int? stockCount;
  String? proImage;
  int? categoryId;
  String? catName;

  Product();

  Product.fromJson(Map<String, dynamic> json) {
    proId = json['proId'];
    proName = json['proName'];
    proDescription = json['proDescription'];
    price = json['price'];
    stockCount = json['stockCount'];
    proImage = json['image'];
    categoryId = json['categoryId'];
    catName = json['catName'];
  }

  Map<String, dynamic> toJson() {
    return {
      'proId': proId,
      'proName': proName,
      'proDescription': proDescription,
      'price': price,
      'stockCount': stockCount,
      'image': proImage,
      'categoryId': categoryId,
      'catName': catName
    };
  }
  
}
