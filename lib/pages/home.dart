import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ma7aly/widgets/header_card.dart';
import 'package:ma7aly/widgets/grid_view_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                    onTap: () {},
                  ),
                  GridViewItems(
                    label: "Products",
                    color: Color(0xffda8999),
                    iconData: Icons.inventory_2,
                    onTap: () {},
                  ),
                  GridViewItems(
                    label: "Clients",
                    color: Color(0xff00c1fc),
                    iconData: Icons.group,
                    onTap: () {},
                  ),
                  GridViewItems(
                    label: "New Sale",
                    color: Color(0xff64be61),
                    iconData: Icons.shopping_basket,
                    onTap: () {},
                  ),
                  GridViewItems(
                    label: "Categories",
                    color: Colors.grey,
                    iconData: Icons.category,
                    onTap: () {},
                  ),
                ],
              ))
            ],
          ),
        ));
  }
}
