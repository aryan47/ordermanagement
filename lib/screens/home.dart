import 'package:flutter/material.dart';
import 'package:order_management/service/mainService.dart';
import 'package:order_management/widgets/widgetUtils.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  List bottomNavList = [];
  Map<String, dynamic> appConfig;
  var service;

  @override
  Widget build(BuildContext context) {
     service = MyInheritedWidget.of(context);

    return Scaffold(
      drawer: buildDrawer(service.buildDrawerList()),
      appBar: AppBar(
        title: Text(""),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar:
          buildBottomNavigationBar(service.buildBottomNavList(), _currentIndex),
    );
  }
}
