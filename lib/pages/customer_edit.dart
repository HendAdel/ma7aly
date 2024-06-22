import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ma7aly/helpers/sql_helper.dart';
import 'package:ma7aly/models/customer.dart';
import 'package:ma7aly/widgets/app_elevated_button.dart';
import 'package:ma7aly/widgets/app_text_form_field.dart';
import 'package:sqflite/sqflite.dart';

class CustomerEdit extends StatefulWidget {
  final Customer? customer;

  const CustomerEdit({this.customer, super.key});

  @override
  State<CustomerEdit> createState() => _CustomerEditState();
}

class _CustomerEditState extends State<CustomerEdit> {
  TextEditingController? nameTextController;
  TextEditingController? addressTextController;
  TextEditingController? phoneTextController;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameTextController =
        TextEditingController(text: widget.customer?.custName ?? '');
    addressTextController =
        TextEditingController(text: widget.customer?.custAddress ?? '');
    phoneTextController =
        TextEditingController(text: widget.customer?.custPhoneNo ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.customer == null ? 'Add New Customer' : 'Edit Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              AppTextFormField(
                labelText: 'Name',
                controller: nameTextController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              AppTextFormField(
                  labelText: 'Address',
                  controller: addressTextController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Address is required';
                    }
                    return null;
                  }),
              const SizedBox(
                height: 20,
              ),
              AppTextFormField(
                labelText: 'Phone',
                controller: phoneTextController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              AppElevatedButton(
                  label: widget.customer == null
                      ? 'Save New Customer'
                      : "Update Customer",
                  onPressed: () async {
                    await onSave();
                  })
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSave() async {
    try {
      if (formKey.currentState!.validate()) {
        var sqlHelper = GetIt.I.get<SqlHelper>();
        if (widget.customer == null) {
          // Add new Customer
          await sqlHelper.db!.insert(
              'customers',
              conflictAlgorithm: ConflictAlgorithm.replace,
              {
                'custName': nameTextController?.text,
                'custAddress': addressTextController?.text,
                'custPhoneNo': phoneTextController?.text
              });
        } else {
          // Update edited Customer
          await sqlHelper.db!.update(
              'customers',
              {
                'custName': nameTextController?.text,
                'custAddress': addressTextController?.text,
                'custPhoneNo': phoneTextController?.text
              },
              where: 'custId =?',
              whereArgs: [widget.customer?.custId]);
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Text(
            widget.customer == null ? 'Customer Added' : 'Customer Updated',
            style: TextStyle(color: Colors.white),
          ),
        ));
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Error in Adding Customer $e',
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
  }
}
