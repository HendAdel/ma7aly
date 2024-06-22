class Customer {
  int? custId;
  String? custName;
  String? custAddress;
  String? custPhoneNo;

  Customer();

  Customer.fromJson(Map<String, dynamic> json) {
    custId = json['custId'];
    custName = json['custName'];
    custAddress = json['custAddress'];
    custPhoneNo = json['custPhoneNo'];
  }

  Map<String, dynamic> toJson() {
    return {
      'custId': custId,
      'custName': custName,
      'custAddress': custAddress,
      'custPhoneNo': custPhoneNo
    };
  }
}
