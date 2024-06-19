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
      price double,
      stockCount integer,
      image blob,
      categoryId integer
      ) """);
      batch.execute("""Create table If not exists customers(
      custId integer primary key,
      custName text,
      custAddress text,
      custPhoneNo text
      ) """);
      batch.execute("""Create table If not exists orders(
      Id integer primary key,
      invoiceNo text,
      orderDate text,
      discount double,
      customerId integer
      ) """);
      batch.execute("""Create table If not exists ordersProducts(
      Id integer primary key,
      orderId integer,
      productId integer,      
      productCount integer
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
