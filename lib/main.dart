import 'package:flutter/material.dart';
import 'package:ma7aly/helpers/sql_helper.dart';
import 'package:ma7aly/pages/home.dart';
import 'package:ma7aly/helpers/design_helper.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var sqlHelper = SqlHelper();
  await sqlHelper.initDatabase();
  if (sqlHelper.db != null) {
    GetIt.I.registerSingleton<SqlHelper>(sqlHelper);
  }
  runApp(const MyApp());
}

var designHelper = DesignHelper();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'محلي',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xff0156da), foregroundColor: Colors.white),
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: Colors.white,
          cardColor: Colors.blue.shade100,
          errorColor: Colors.red,
          primarySwatch: designHelper.getMaterialColor(Color(0xff0058da)),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
