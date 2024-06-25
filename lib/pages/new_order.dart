import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ma7aly/models/order.dart';
import 'package:ma7aly/models/order_products.dart';
import 'package:ma7aly/models/product.dart';
import 'package:get_it/get_it.dart';
import 'package:ma7aly/helpers/sql_helper.dart';
import 'package:ma7aly/widgets/app_elevated_button.dart';
import 'package:ma7aly/widgets/app_text_form_field.dart';
import 'package:ma7aly/widgets/cust_drop_down.dart';
import 'package:sqflite/sqflite.dart';

class NewOrderPage extends StatefulWidget {
  final Order? order;

  const NewOrderPage({this.order, super.key});

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  List<Product>? productsList;
  List<OrderProducts>? selectedOrderItems;
  String? orderInvoiceNo;
  int? selectedCustomerId;
  TextEditingController? discountTextController;

  void getProducts() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var proList = await sqlHelper.db?.rawQuery('''Select proId,
      proName,
      proDescription,
      price,
      stockCount,
      image,
      categoryId, catName 
      From products Inner Join categories on categoryId = catId''');
      if (proList!.isNotEmpty) {
        productsList = [];
        for (var pro in proList) {
          productsList?.add(Product.fromJson(pro));
        }
      } else {
        productsList = [];
      }

      print("The Data >>>>> ${productsList}");
    } catch (e) {
      print('Error in get Products $e');
    }
    setState(() {});
  }

  void initPage() {
    getProducts();
    orderInvoiceNo = widget.order == null
        ? '#No${DateTime.now().millisecondsSinceEpoch}'
        : widget.order?.invoiceNo;
    setState(() {});
  }

  OrderProducts? getOrderItem(int proId) {
    for (var orderItem in selectedOrderItems ?? []) {
      if (orderItem.productId == proId) {
        return orderItem;
      }
    }
    return null;
  }

  @override
  void initState() {
    initPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order == null ? 'Add New Order' : 'Update Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order No. : ${orderInvoiceNo}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // ToDo: Filter the customers drop down list by text value.
                      // TextField(
                      //   decoration: InputDecoration(
                      //     prefixIcon: Icon(Icons.search),
                      //     enabledBorder: OutlineInputBorder(),
                      //     border: OutlineInputBorder(),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //           color: Theme.of(context).primaryColor),
                      //     ),
                      //     labelText: 'Filter Customers',
                      //   ),
                      //   onChanged: (text) async {
                      //     if (text == '') {
                      //       CustomersDropDown(
                      //         selectId: selectedCustomerId,
                      //         onChanged: (value) {
                      //           selectedCustomerId = value;
                      //           setState(() {});
                      //         },
                      //       );
                      //       return;
                      //     }
                      //     CustomersDropDown(
                      //       selectId: selectedCustomerId,
                      //       onChanged: (value) {
                      //         selectedCustomerId = value;
                      //         setState(() {});
                      //       },
                      //     );
                      //     setState(() {});
                      //   },
                      // ),

                      CustomersDropDown(
                        selectId: selectedCustomerId,
                        onChanged: (value) {
                          selectedCustomerId = value;
                          setState(() {});
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return StatefulBuilder(
                                          builder: (context, setStateEx) {
                                        return Dialog(
                                          child:
                                              (productsList?.isEmpty ?? false)
                                                  ? const Center(
                                                      child:
                                                          Text('No Data Found'),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: ListView(
                                                              children: [
                                                                for (var product
                                                                    in productsList!)
                                                                  ListTile(
                                                                    subtitle: getOrderItem(product.proId!) !=
                                                                            null
                                                                        ? Row(
                                                                            children: [
                                                                              IconButton(
                                                                                  onPressed: () {
                                                                                    if (getOrderItem(product.proId!)!.productCount == 0) return;
                                                                                    getOrderItem(product.proId!)!.productCount = getOrderItem(product.proId!)!.productCount! - 1;

                                                                                    setStateEx(() {});
                                                                                  },
                                                                                  icon: const Icon(Icons.remove)),
                                                                              Text('${getOrderItem(product.proId!)?.productCount}'),
                                                                              IconButton(
                                                                                  onPressed: () {
                                                                                    if (getOrderItem(product.proId!)!.productCount == getOrderItem(product.proId!)!.product!.stockCount) return;
                                                                                    getOrderItem(product.proId!)!.productCount = getOrderItem(product.proId!)!.productCount! + 1;
                                                                                    setStateEx(() {});
                                                                                  },
                                                                                  icon: const Icon(Icons.add)),
                                                                            ],
                                                                          )
                                                                        : SizedBox(),
                                                                    leading: Image.network(
                                                                        product.proImage ??
                                                                            ''),
                                                                    title: Text(
                                                                        product.proName ??
                                                                            'No Name'),
                                                                    trailing:
                                                                        IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              if (getOrderItem(product.proId!) != null) {
                                                                                onRemoveOrderItem(product.proId!);
                                                                              } else {
                                                                                onAddOrderItem(product);
                                                                              }
                                                                              setStateEx(() {});
                                                                            },
                                                                            icon: getOrderItem(product.proId!) == null
                                                                                ? const Icon(Icons.add)
                                                                                : const Icon(Icons.delete)),
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                          AppElevatedButton(
                                                            label: 'Back',
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                        );
                                      });
                                      // )
                                      // )
                                    });
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.black,
                              )),
                          const Text(
                            'Add Product',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      const Text(
                        'Order Items',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      for (var orderItem in selectedOrderItems ?? [])
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading:
                                Image.network(orderItem.product.proImage ?? ''),
                            title: Text(
                                "${orderItem.product.proName ?? 'No Name'},${orderItem.productCount}X"),
                            trailing: Text(
                                '${orderItem.productCount * orderItem.product.price}'),
                          ),
                        ),
                      // ToDo TextField for discount

                      AppTextFormField(
                        labelText: 'Discount',
                        controller: discountTextController,
                        inputType: TextInputType.number,
                        inputFormater: [FilteringTextInputFormatter.digitsOnly],
                      ),

                      Text(
                        'Total Order Price: ${calculateTotal}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppElevatedButton(
                label: 'Add Order',
                onPressed: () async {
                  await onSaveOrder();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSaveOrder() async {
    try {
      if (selectedOrderItems == null ||
          (selectedOrderItems?.isEmpty ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "No Items to Save! Please Choose the Items First.",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        return;
      }

      var sqlHelper = GetIt.I.get<SqlHelper>();
      var orderId = await sqlHelper.db!
          .insert('orders', conflictAlgorithm: ConflictAlgorithm.replace, {
        'invoiceNo': orderInvoiceNo,
        'orderDate': DateTime.now().toString(),
        'orderTotal': calculateTotal,
        'discount': double.parse(discountTextController?.text ?? '0.0'),
        'customerId': selectedCustomerId
      });

      var batch = sqlHelper.db!.batch();
      for (var orderItem in selectedOrderItems!) {
        batch.insert('ordersProducts', {
          "orderId": orderId,
          'productId': orderItem.productId,
          'productCount': orderItem.productCount
        });
      }
      var insertResult = await batch.commit();
      print('Select order Items : ###### ${insertResult}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Order Saved Successfully.",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Error in Saveing Order : ${e}",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  double? get calculateTotal {
    var totalPrice = 0.0;
    for (var orderItem in selectedOrderItems ?? []) {
      totalPrice = totalPrice +
          (orderItem?.productCount ?? 0) * (orderItem?.product?.price ?? 0);
    }
    return totalPrice;
  }

  void onRemoveOrderItem(int productId) {
    for (var i = 0; i < (selectedOrderItems?.length ?? 0); i++) {
      if (selectedOrderItems![i].productId == productId) {
        selectedOrderItems!.removeAt(i);
      }
    }
  }

  void onAddOrderItem(Product product) {
    var orderItem = OrderProducts();
    orderItem.product = product;
    orderItem.productCount = 1; // getOrderItem(product.proId!)!.productCount;
    orderItem.productId = product.proId;
    selectedOrderItems ??= [];
    selectedOrderItems!.add(orderItem);
    setState(() {});
  }
}
