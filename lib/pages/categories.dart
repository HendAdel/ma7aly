import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ma7aly/helpers/sql_helper.dart';
import 'package:ma7aly/models/category.dart';
import 'package:ma7aly/pages/category_edit.dart';
// import 'package:data_table_2/data_table_2.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
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

      print("The Data >>>>> ${categoriesList}");
    } catch (e) {
      print('Error in get Categories $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        actions: [
          IconButton(
              onPressed: () async {
                var result = await Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => CategoryEdit()));
                if (result ?? false) {
                  getCategories();
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
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                labelText: 'Search',
              ),
              onChanged: (text) async {
                if (text == '') {
                  getCategories();
                  return;
                }
                var sqlHelper = await GetIt.I.get<SqlHelper>();
                var searchResult =
                    await sqlHelper.db!.rawQuery("""Select * from categories
                  Where catName like '%$text%' Or catDescription like '%$text%' """);
                if (searchResult.isNotEmpty) {
                  categoriesList = [];
                  for (var cat in searchResult) {
                    categoriesList?.add(Category.fromJson(cat));
                  }
                } else {
                  categoriesList = [];
                }
                setState(() {});
              },
            ),
            const SizedBox(
              height: 20,
            ),
            categoriesList == null
                ? const CircularProgressIndicator()
                : Expanded(
                    child: SingleChildScrollView(
                      child: PaginatedDataTable(
                        showEmptyRows: false,
                        horizontalMargin: 20,
                        rowsPerPage: 10,
                        checkboxHorizontalMargin: 12,
                        columnSpacing: 20,
                        showFirstLastButtons: true,
                        // headingTextStyle: TextStyle(color: Colors.white, fontSize: 14),
                        headingRowColor: MaterialStatePropertyAll(
                            Theme.of(context).primaryColor),
                        // border: TableBorder.all(color: Colors.black),
                        // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                        // showBottomBorder: true,
                        showCheckboxColumn: true,
                        columns: const [
                          DataColumn(label: Text('Category ID')),
                          DataColumn(label: Text('Category Name')),
                          DataColumn(label: Text('Category Description')),
                          DataColumn(label: Text('Actions')),
                        ],

                        source: DataSource(
                            categories: categoriesList!,
                            onUpdate: (Category) async {
                              var updateResult = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => CategoryEdit(
                                            category: Category,
                                          )));
                              if (updateResult ?? false) {
                                getCategories();
                              }
                            },
                            onDelete: (Category) async {
                              await onDeleteCat(Category);
                            }),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> onDeleteCat(Category category) async {
    try {
      var dialogResult = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Category'),
              content:
                  const Text('Are you sure you want to delete this category?'),
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
            .delete('categories', where: 'catId=?', whereArgs: [category.id]);
        getCategories();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Error on Deleteing Category ${category.name}',
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
  }
}

class DataSource extends DataTableSource {
  List<Category>? categories;
  void Function(Category)? onUpdate;
  void Function(Category)? onDelete;

  DataSource(
      {required this.categories,
      required this.onUpdate,
      required this.onDelete});
  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(' ${categories?[index].id}')),
      DataCell(Text(' ${categories?[index].name}')),
      DataCell(Text(' ${categories?[index].description}')),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              onUpdate!(categories![index]);
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              onDelete!(categories![index]);
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
  int get rowCount => categories?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
