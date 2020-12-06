import 'package:flutter/material.dart';
import 'package:order_management/service/mainService.dart';
import 'package:order_management/widgets/widgetUtils.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List bottomNavList = [];
  int _currentIndex = 0;
  Map<String, dynamic> appConfig;
  var srv;

  @override
  Widget build(BuildContext context) {
    srv = MyInheritedWidget.of(context);
    return Scaffold(
      drawer: buildDrawer(srv.buildDrawerList(context)),
      appBar: AppBar(
        title: Text("Product Management"),
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
      bottomNavigationBar: buildBottomNavigationBar(srv.buildBottomNavList(),
          srv.buildBottomNavRoutes(_currentIndex, context)),
    );
  }
}
