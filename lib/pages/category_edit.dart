import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ma7aly/helpers/sql_helper.dart';
import 'package:ma7aly/models/category.dart';
import 'package:ma7aly/widgets/app_elevated_button.dart';
import 'package:ma7aly/widgets/app_text_form_field.dart';
import 'package:sqflite/sqflite.dart';

class CategoryEdit extends StatefulWidget {
  final Category? category;

  const CategoryEdit({this.category, super.key});

  @override
  State<CategoryEdit> createState() => _CategoryEditState();
}

class _CategoryEditState extends State<CategoryEdit> {
  TextEditingController? nameTextController;
  TextEditingController? descriptionTextController;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameTextController =
        TextEditingController(text: widget.category?.name ?? '');
    descriptionTextController =
        TextEditingController(text: widget.category?.description ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.category == null ? 'Add New Category' : 'Edit Category'),
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
              AppElevatedButton(
                  label: widget.category == null
                      ? 'Save New Category'
                      : "Update Category",
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

        if (widget.category == null) {// Add New Category
          await sqlHelper.db!.insert(
              'categories',
              conflictAlgorithm: ConflictAlgorithm.replace,
              {
                'catName': nameTextController?.text,
                'catDescription': descriptionTextController?.text
              });
        } else {
          // Update edited category
          await sqlHelper.db!.update(
              'categories',
              {
                'catName': nameTextController?.text,
                'catDescription': descriptionTextController?.text
              },
              where: 'catId =?',
              whereArgs: [widget.category?.id]);
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Text(
            widget.category == null ? 'Category Added' : 'Category Updated',
            style: TextStyle(color: Colors.white),
          ),
        ));
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Error in Adding Category $e',
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
  }
}
