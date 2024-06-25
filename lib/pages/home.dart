
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ma7aly/helpers/sql_helper.dart';
import 'package:ma7aly/pages/categories.dart';
import 'package:ma7aly/pages/customers.dart';
import 'package:ma7aly/pages/new_order.dart';
import 'package:ma7aly/pages/orders.dart';
import 'package:ma7aly/pages/products.dart';
import 'package:ma7aly/widgets/header_card.dart';
import 'package:ma7aly/widgets/grid_view_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    initHomePage();
    super.initState();
  }

  void initHomePage() async {
    await GetIt.I.get<SqlHelper>().registerForeignKey();
    await GetIt.I.get<SqlHelper>().createTables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Container(),
        appBar: AppBar(),
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      color: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "محلِى",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                          HeaderCard("Exchange Rate", "1 USD = 50 EGP"),
                          HeaderCard("Today's Sales", "1500 EGP")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  GridViewItems(
                    label: "All Sales",
                    color: Color(0xffe9ad62),
                    iconData: Icons.list_alt_outlined,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrdersPage()));
                    },
                  ),
                  GridViewItems(
                    label: "Products",
                    color: Color(0xffda8999),
                    iconData: Icons.inventory_2,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductsPage()));
                    },
                  ),
                  GridViewItems(
                    label: "Clients",
                    color: Color(0xff00c1fc),
                    iconData: Icons.group,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomersPage()));
                    },
                  ),
                  GridViewItems(
                    label: "New Sale",
                    color: Color(0xff64be61),
                    iconData: Icons.shopping_basket,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewOrderPage()));
                    },
                  ),
                  GridViewItems(
                    label: "Categories",
                    color: Colors.grey,
                    iconData: Icons.category,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoriesPage()));
                    },
                  ),
                ],
              ))
            ],
          ),
        ));
  }
}
