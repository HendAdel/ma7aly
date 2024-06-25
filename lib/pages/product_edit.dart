import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:ma7aly/helpers/sql_helper.dart';
import 'package:ma7aly/models/category.dart';
import 'package:ma7aly/models/product.dart';
import 'package:ma7aly/widgets/app_elevated_button.dart';
import 'package:ma7aly/widgets/app_text_form_field.dart';
import 'package:ma7aly/widgets/cat_drop_down.dart';
import 'package:sqflite/sqflite.dart';

class ProductEdit extends StatefulWidget {
  final Product? product;

  const ProductEdit({this.product, super.key});

  @override
  State<ProductEdit> createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  TextEditingController? nameTextController;
  TextEditingController? descriptionTextController;
  TextEditingController? priceTextController;
  TextEditingController? stockCountTextController;
  TextEditingController? imageTextController;
  int? selectedCategoryId;

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameTextController =
        TextEditingController(text: widget.product?.proName ?? '');
    descriptionTextController =
        TextEditingController(text: widget.product?.proDescription ?? '');
    priceTextController =
        TextEditingController(text: '${widget.product?.price ?? ''}');
    stockCountTextController =
        TextEditingController(text: '${widget.product?.stockCount ?? ''}');
    imageTextController =
        TextEditingController(text: widget.product?.proImage ?? '');
    selectedCategoryId = widget.product?.categoryId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.product == null ? 'Add New Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
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
                    labelText: 'Describtion',
                    controller: descriptionTextController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Describtion is required';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 20,
                ),
                AppTextFormField(
                  labelText: 'Price',
                  controller: priceTextController,
                  inputType: TextInputType.number,
                  inputFormater: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Price is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                AppTextFormField(
                    labelText: 'Stock Count',
                    controller: stockCountTextController,
                    inputType: TextInputType.number,
                    inputFormater: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Stock Count is required';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 20,
                ),
                AppTextFormField(
                  labelText: 'Image URL',
                  controller: imageTextController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Image URL is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CategoriesDropDown(
                  selectId: selectedCategoryId,
                  onChanged: (value) {
                    selectedCategoryId = value;
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                AppElevatedButton(
                    label: widget.product == null
                        ? 'Save New Product'
                        : "Update Product",
                    onPressed: () async {
                      await onSave();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onSave() async {
    try {
      if (formKey.currentState!.validate()) {
        var sqlHelper = GetIt.I.get<SqlHelper>();

        if (widget.product == null) {
          // Add New Product
          await sqlHelper.db!.insert(
              'products',
              conflictAlgorithm: ConflictAlgorithm.replace,
              {
                'proName': nameTextController?.text,
                'proDescription': descriptionTextController?.text,
                'price': double.parse(priceTextController?.text ?? '0.0'),
                'stockCount': int.parse(stockCountTextController?.text ?? '0'),
                'image': imageTextController?.text,
                'categoryId': selectedCategoryId
              });
        } else {
          // Update edited product
          await sqlHelper.db!.update(
              'products',
              {
                'proName': nameTextController?.text,
                'proDescription': descriptionTextController?.text,
                'price': double.parse(priceTextController?.text ?? '0.0'),
                'stockCount': int.parse(stockCountTextController?.text ?? '0'),
                'image': imageTextController?.text,
                'categoryId': selectedCategoryId
              },
              where: 'proId =?',
              whereArgs: [widget.product?.proId]);
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Text(
            widget.product == null ? 'Product Added' : 'Product Updated',
            style: TextStyle(color: Colors.white),
          ),
        ));
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('Error in adding product ======== $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Error in Adding Product $e',
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
  }
}
