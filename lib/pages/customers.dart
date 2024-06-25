import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:ma7aly/helpers/sql_helper.dart';
import 'package:ma7aly/models/customer.dart';
import 'package:ma7aly/pages/customer_edit.dart';
import 'package:ma7aly/widgets/ma7aly_table.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  List<Customer>? customersList;

  @override
  void initState() {
    getCustomers();
    super.initState();
  }

  void getCustomers() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var custList = await sqlHelper.db?.query('customers');
      if (custList!.isNotEmpty) {
        customersList = [];
        for (var customer in custList) {
          customersList?.add(Customer.fromJson(customer));
        }
      } else {
        customersList = [];
      }
      setState(() {});

      print("The Data >>>>> ${customersList}");
    } catch (e) {
      print('Error in get customers $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customers"),
        actions: [
          IconButton(
              onPressed: () async {
                var updateResult = await Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => CustomerEdit()));
                if (updateResult ?? false) {
                  getCustomers();
                }
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  labelText: 'Search',
                ),
                onChanged: (text) async {
                  if (text == '') {
                    getCustomers();
                    return;
                  }
                  var sqlHelper = await GetIt.I.get<SqlHelper>();
                  var searchResult =
                      await sqlHelper.db!.rawQuery("""Select * from customers
                  Where custName like '%$text%' Or custAddress like '%$text%' 
                  Or custPhoneNo like '%$text%' """);
                  if (searchResult.isNotEmpty) {
                    customersList = [];
                    for (var cat in searchResult) {
                      customersList?.add(Customer.fromJson(cat));
                    }
                  } else {
                    customersList = [];
                  }
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 20,
              ),
              customersList == null
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Ma7alyTable(
                          columns: const [
                            DataColumn(label: Text('customer ID')),
                            DataColumn(label: Text('customer Name')),
                            DataColumn(label: Text('customer Address')),
                            DataColumn(label: Text('customer Phone')),
                            DataColumn(label: Text('Actions')),
                          ],
                          source: DataSource(
                              customers: customersList!,
                              onUpdate: (Customer) async {
                                var updateResult = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => CustomerEdit(
                                              customer: Customer,
                                            )));
                                if (updateResult ?? false) {
                                  getCustomers();
                                }
                              },
                              onDelete: (Customer) async {
                                await onDeleteCust(Customer);
                              }),
                        ),
                      ),
                    ),
            ],
          )),
    );
  }

  Future<void> onDeleteCust(Customer customer) async {
    try {
      var dialogResult = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Customer'),
              content:
                  const Text('Are you sure you want to delete this Customer?'),
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
        await sqlHelper.db!.delete('customers',
            where: 'custId=?', whereArgs: [customer.custId]);
        getCustomers();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Error on Deleteing Customer ${customer.custName}',
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
  }
}

class DataSource extends DataTableSource {
  List<Customer>? customers;
  void Function(Customer)? onUpdate;
  void Function(Customer)? onDelete;

  DataSource(
      {required this.customers,
      required this.onUpdate,
      required this.onDelete});
  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(' ${customers?[index].custId}')),
      DataCell(Text(' ${customers?[index].custName}')),
      DataCell(Text(' ${customers?[index].custAddress}')),
      DataCell(Text(' ${customers?[index].custPhoneNo}')),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              onUpdate!(customers![index]);
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              onDelete!(customers![index]);
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
  int get rowCount => customers?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
