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
  // List<Category>? categoriesList;
  List<Category>? categories;
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
        for (var cat in catList) {
          categories ??= [];
          categories?.add(Category.fromJson(cat));
        }
      } else {
        categories = [];
      }
      setState(() {});

      print("The Data >>>>> ${categories}");
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
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => CategoryEdit()));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: categories == null
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: PaginatedDataTable(
                    rowsPerPage: 10,
                    // headingTextStyle: TextStyle(color: Colors.white, fontSize: 14),
                    headingRowColor: MaterialStatePropertyAll(
                        Theme.of(context).primaryColor),
                    // border: TableBorder.all(color: Colors.black),
                    // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                    // showBottomBorder: true,
                    showCheckboxColumn: true,
                    columns: [
                      DataColumn(label: Text('Category ID')),
                      DataColumn(label: Text('Category Name')),
                      DataColumn(label: Text('Category Description')),
                      DataColumn(label: Text('Actions')),
                    ],

                    source: DataSource(categories!),
                  ),
                )),
    );
  }
}

class DataSource extends DataTableSource {
  List<Category>? categories;
  DataSource(this.categories);

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
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
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
