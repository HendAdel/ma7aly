class Order {
  int? ordId;
  String? invoiceNo;
  String? orderDate;
  double? orderTotal;
  double? discount;
  int? customerId;
  String? customerName;
  String? customerPhone;

  Order();

  Order.fromJson(Map<String, dynamic> json) {
    ordId = json['ordId'];
    invoiceNo = json['invoiceNo'];
    orderDate = json['orderDate'];
    orderTotal = json['orderTotal'];
    discount = json['discount'];
    customerId = json['customerId'];
    customerName = json['customerName'];
    customerPhone = json['customerPhone'];
  }

  Map<String, dynamic> toJson() {
    return {
      'ordId': ordId,
      'invoiceNo': invoiceNo,
      'orderDate': orderDate,
      'orderTotal': orderTotal,
      'discount': discount,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone
    };
  }
}
