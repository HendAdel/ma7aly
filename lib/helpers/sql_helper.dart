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
        print(db.hashCode);
        // print(sqliteVersion); // should print 3.39.3
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
}
