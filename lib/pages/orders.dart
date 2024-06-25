import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ma7aly/helpers/sql_helper.dart';
import 'package:ma7aly/models/order.dart';
import 'package:ma7aly/widgets/ma7aly_table.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order>? ordersList;

  void getOrders() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var orders = await sqlHelper.db!.rawQuery('''Select 
      ordId, invoiceNo, orderDate, orderTotal, discount,
      customerId, custName, custPhoneNo
      From orders Inner Join customers on customerId = custId''');

      if (orders.isNotEmpty) {
        ordersList = [];
        for (var order in orders) {
          ordersList?.add(Order.fromJson(order));
        }
      } else {
        ordersList = [];
      }
    } catch (e) {
      ordersList = [];
      print('Error in get Orders!????????????? : ${e}');
    }
    setState(() {});
  }

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Sales"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Ma7alyTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Invoice No')),
                DataColumn(label: Text('Ord. Date')),
                DataColumn(label: Text('Ord. Total')),
                DataColumn(label: Text('Ord. Discount')),
                DataColumn(label: Text('Cust. Name')),
                DataColumn(label: Text('Cust. Phone')),
                DataColumn(label: Text('Actions')),
              ],
              source: DataSource(
                  orders: ordersList,
                  onShow: (order) async {},
                  onDelete: (Order) async {
                    await onDeleteOrder(Order);
                  })),
        ),
      ),
    );
  }

  Future<void> onDeleteOrder(Order order) async {
    try {
      var dialogResult = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Order'),
              content:
                  const Text('Are you sure you want to delete this Order?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          });
      if (dialogResult ?? false) {
        var sqlHelper = GetIt.I.get<SqlHelper>();
        await sqlHelper.db!
            .delete('orders', where: 'ordId=?', whereArgs: [order.ordId]);
        getOrders();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Error on Deleteing Order:  ${e}',
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
  }
}

class DataSource extends DataTableSource {
  List<Order>? orders;
  void Function(Order)? onShow;
  void Function(Order)? onDelete;

  DataSource(
      {required this.orders, required this.onShow, required this.onDelete});
  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(' ${orders?[index].ordId}')),
      DataCell(Text(' ${orders?[index].invoiceNo}')),
      DataCell(Text(' ${orders?[index].orderDate}')),
      DataCell(Text(' ${orders?[index].orderTotal}')),
      DataCell(Text(' ${orders?[index].discount}')),
      DataCell(Text(' ${orders?[index].customerName}')),
      DataCell(Text(' ${orders?[index].customerPhone}')),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              onShow!(orders![index]);
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              onDelete!(orders![index]);
            },
            icon: const Icon(Icons.delete),
            color: Colors.red,
          )
        ],
      ))
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => orders?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
