import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ma7aly/helpers/sql_helper.dart';
import 'package:ma7aly/models/customer.dart';

class CustomersDropDown extends StatefulWidget {
  final int? selectId;
  final void Function(int?)? onChanged;

  const CustomersDropDown({required this.selectId, this.onChanged, super.key});

  @override
  State<CustomersDropDown> createState() => _CustomersDropDownState();
}

class _CustomersDropDownState extends State<CustomersDropDown> {
  List<Customer>? customersList;

  @override
  void initState() {
    getCustomers();
    super.initState();
  }

  void getCustomers() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      // ToDo: Get Customers by filter.
      // var catList = await sqlHelper.db?.rawQuery("""Select * from customers
      //             Where custName like '%${text!}%' Or custAddress like '%$text%'
      //             Or custPhoneNo like '%$text%' """);

      var custList = await sqlHelper.db?.query('customers');

      if (custList!.isNotEmpty) {
        customersList = [];
        for (var cust in custList) {
          customersList?.add(Customer.fromJson(cust));
        }
      } else {
        customersList = [];
      }
      setState(() {});
    } catch (e) {
      print('Error in get Customers $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return customersList == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : (customersList?.isEmpty ?? false)
            ? Center(
                child: Text('No Customers Found!'),
              )
            : Row(
                children: [
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      child: DropdownButton(
                          items: [
                            for (var customer in customersList!)
                              DropdownMenuItem(
                                  child: Text(customer.custName ?? 'No Name'),
                                  value: customer.custId),
                          ],
                          value: widget.selectId,
                          isExpanded: true,
                          underline: SizedBox(),
                          hint: Text('Select Customer'),
                          onChanged: widget.onChanged),
                    ),
                  ))
                ],
              );
  }
}
