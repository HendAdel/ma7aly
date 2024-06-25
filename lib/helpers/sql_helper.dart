import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SqlHelper {
  Database? db;
  initDatabase() async {
    try {
      if (kIsWeb) {
        // Use the ffi web factory in web apps (flutter or dart)
        var factory = databaseFactoryFfiWeb;
        db = await factory.openDatabase('ma7aly.db');
        print("==================> Db Created");
        var sqliteVersion =
            (await db!.rawQuery('select sqlite_version()')).first.values.first;
        // print(db.hashCode);
        print(sqliteVersion); // should print 3.39.3
      } else {
        db = await openDatabase(
          'ma7aly.db',
          version: 1,
          onCreate: (db, version) => print("===================> Db Created."),
        );
      }
    } catch (e) {
      print('Error in Creating database!  : ${e}');
    }
  }

  Future<void> registerForeignKey() async {
    await db!.rawQuery("""Pragma foreign_keys = ON""");
    var pragmaResult = await db!.rawQuery("""Pragma foreign_keys""");
    print(pragmaResult);
  }

  Future<bool> createTables() async {
    try {
      var batch = db!.batch();

      batch.execute("""Create table If not exists categories(
      catId integer primary key,
      catName text,
      catDescription text
      ) """);
      batch.execute("""Create table If not exists products(
      proId integer primary key,
      proName text,
      proDescription text,
      price real,
      stockCount integer,
      image text,
      categoryId integer,
      foreign key(categoryId) references categories(catId) ON Delete restrict) """);
      batch.execute("""Create table If not exists customers(
      custId integer primary key,
      custName text,
      custAddress text,
      custPhoneNo text
      ) """);
      batch.execute("""Create table If not exists orders(
      ordId integer primary key,
      invoiceNo text,
      orderDate text,
      orderTotal real,
      discount real,
      customerId integer,
      foreign key(customerId) references customers(custId) ON Delete restrict

      ) """);
      batch.execute("""Create table If not exists ordersProducts(
      Id integer primary key,
      orderId integer,
      productId integer,      
      productCount integer,
      foreign key(orderId) references orders(ordId) ON Delete restrict,
      foreign key(productId) references products(proId) ON Delete restrict

      ) """);

      var createTablesResult = await batch.commit();
      print("Tables created successfully: $createTablesResult");
      return true;
    } catch (e) {
      print("Error in creating tables: $e");
      return false;
    }
  }
}
