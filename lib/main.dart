import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:order_management/screens/customers.dart';
import 'package:order_management/screens/dashboard.dart';
import 'package:order_management/screens/home.dart';
import 'package:order_management/screens/orders.dart';
import 'package:order_management/screens/products.dart';
import 'package:order_management/screens/settings.dart';
import 'package:order_management/service/mainService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final content =
      await rootBundle.loadString("assets/configuration/config.json");

  runApp(MyInheritedWidget(
    child: MyApp(),
    appConfig: jsonDecode(content),
  ));
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
        '/payment': (context) => Dashboard()
      },
    );
  }
}
