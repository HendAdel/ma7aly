import 'package:ma7aly/models/product.dart';

class OrderProducts {
  int? id;
  int? ordId;
  int? productCount;
  int? productId;
  Product? product;

  OrderProducts();

  OrderProducts.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    ordId = json['ordId'];
    productCount = json['productCount'];
    productId = json['productId'];
    product = Product.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'ordId': ordId,
      'productCount': productCount,
      'productId': productId
    };
  }
}
