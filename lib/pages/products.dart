import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ma7aly/helpers/sql_helper.dart';
import 'package:ma7aly/widgets/ma7aly_table.dart';
import 'package:ma7aly/models/product.dart';
import 'package:ma7aly/pages/product_edit.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product>? productsList;

  @override
  void initState() {
    getProducts();
    super.initState();
  }

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
      setState(() {});

      print("The Data >>>>> ${productsList}");
    } catch (e) {
      print('Error in get Products $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
              onPressed: () async {
                var result = await Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => ProductEdit()));
                if (result ?? false) {
                  getProducts();
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
                  getProducts();
                  return;
                }
                var sqlHelper = await GetIt.I.get<SqlHelper>();
                var searchResult = await sqlHelper.db!.rawQuery("""Select proId,
      proName,
      proDescription,
      price,
      stockCount,
      image,
      categoryId, catName 
      From products Inner Join categories on categoryId = catId
                  Where proName like '%$text%' Or proDescription like '%$text%'
                  Or price like '%$text%' Or catName like '%$text%'
                  Or stockCount like '%$text%' """);
                if (searchResult.isNotEmpty) {
                  productsList = [];
                  for (var pro in searchResult) {
                    productsList?.add(Product.fromJson(pro));
                  }
                } else {
                  productsList = [];
                }
                setState(() {});
              },
            ),
            const SizedBox(
              height: 20,
            ),
            productsList == null
                ? const CircularProgressIndicator()
                : Expanded(
                    child: SingleChildScrollView(
                      child: Ma7alyTable(
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Description')),
                          DataColumn(label: Text('Price')),
                          DataColumn(label: Text('Stock')),
                          DataColumn(label: Text('Image')),
                          DataColumn(label: Text('Categoy')),
                          DataColumn(label: Text('Actions')),
                        ],
                        source: DataSource(
                            products: productsList!,
                            onUpdate: (Product) async {
                              var updateResult = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => ProductEdit(
                                            product: Product,
                                          )));
                              if (updateResult ?? false) {
                                getProducts();
                              }
                            },
                            onDelete: (Product) async {
                              await onDeletePro(Product);
                            }),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> onDeletePro(Product product) async {
    try {
      var dialogResult = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Product'),
              content:
                  const Text('Are you sure you want to delete this product?'),
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
            .delete('products', where: 'proId=?', whereArgs: [product.proId]);
        getProducts();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Error on Deleteing Product ${product.proName}',
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
  }
}

class DataSource extends DataTableSource {
  List<Product>? products;
  void Function(Product)? onUpdate;
  void Function(Product)? onDelete;

  DataSource(
      {required this.products, required this.onUpdate, required this.onDelete});
  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(' ${products?[index].proId}')),
      DataCell(Text(' ${products?[index].proName}')),
      DataCell(Text(' ${products?[index].proDescription}')),
      DataCell(Text(' ${products?[index].price}')),
      DataCell(Text(' ${products?[index].stockCount}')),
      DataCell(Text(' ${products?[index].proImage}')),
      DataCell(Text(' ${products?[index].catName}')),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              onUpdate!(products![index]);
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              onDelete!(products![index]);
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
  int get rowCount => products?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
