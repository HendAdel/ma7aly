import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ma7aly/helpers/sql_helper.dart';
import 'package:ma7aly/models/category.dart';

class CategoriesDropDown extends StatefulWidget {
  final int? selectId;
  final void Function(int?)? onChanged;

  const CategoriesDropDown({required this.selectId, this.onChanged, super.key});

  @override
  State<CategoriesDropDown> createState() => _CategoriesDropDownState();
}

class _CategoriesDropDownState extends State<CategoriesDropDown> {
  List<Category>? categoriesList;

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  void getCategories() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var catList = await sqlHelper.db?.query('categories');
      if (catList!.isNotEmpty) {
        categoriesList = [];
        for (var cat in catList) {
          categoriesList?.add(Category.fromJson(cat));
        }
      } else {
        categoriesList = [];
      }
      setState(() {});
    } catch (e) {
      print('Error in get Categories $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return categoriesList == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : (categoriesList?.isEmpty ?? false)
            ? Center(
                child: Text('No Categories Found!'),
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
                            for (var category in categoriesList!)
                              DropdownMenuItem(
                                child: Text(category.name ?? 'No Name'),
                                value: category.id,
                              ),
                          ],
                          value: widget.selectId,
                          isExpanded: true,
                          underline: SizedBox(),
                          hint: Text('Select Category'),
                          onChanged: widget.onChanged),
                    ),
                  ))
                ],
              );
  }
}
