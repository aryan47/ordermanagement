import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:order_management/screens/customers.dart';
import 'package:order_management/screens/dashboard.dart';
import 'package:order_management/screens/home.dart';
import 'package:order_management/screens/orders.dart';
import 'package:order_management/screens/products.dart';
import 'package:order_management/screens/settings.dart';
import 'package:order_management/service/mainService.dart';
import 'package:order_management/widgets/myCustomForms.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final content =
      await rootBundle.loadString("assets/configuration/config.json");

  final cred =
      await rootBundle.loadString("assets/configuration/credential.json");
  final db = await Db.create(jsonDecode(cred)["mongo"]["url"]);
  await db.open();

  runApp(MyInheritedWidget(
      child: MyApp(), appConfig: jsonDecode(content), db: db));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
      routes: {
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/dashboard': (context) => Dashboard(),
        '/product': (context) => Products(),
        '/orders': (context) => Orders(),
        '/settings': (context) => Settings(),
        '/customers': (context) => Customers(),
        '/payment': (context) => Dashboard(),
        '/forms': (context) => MyCustomForm()
      },
    );
  }
}
