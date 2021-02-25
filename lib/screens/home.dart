import 'package:flutter/material.dart';
import 'package:order_management/screens/login.dart';
import 'package:order_management/service/DBService.dart';
import 'package:order_management/service/loginService.dart';
import 'package:order_management/widgets/widgetUtils.dart';
import 'package:provider/provider.dart';

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

  // @override
  // void initState() {
  //   super.initState();
  //   Provider.of<LoginService>(context, listen: false)
  //       .isAlreadyAuthenticated()
  //       .then((result) {
  //     if (result) {
  //       Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(builder: (_) => Home()),
  //           (Route<dynamic> route) => false);
  //     } else {
  //       // Navigator.of(context).pushAndRemoveUntil(
  //       //     MaterialPageRoute(builder: (_) => OtpPage()),
  //       //     (Route<dynamic> route) => false);
  //     }
  //   });
  // }
  // @override
  // void didChangeDependencies() async{
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   srv = Provider.of<DBService>(context, listen: false);
  //   await srv.initDB();
  // }

  @override
  Widget build(BuildContext context) {
    srv = Provider.of<DBService>(context, listen: false);

    return FutureBuilder<dynamic>(
        future: srv.initDB(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            return Container();
          }
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
            bottomNavigationBar: buildBottomNavigationBar(
                srv.buildBottomNavList(),
                srv.buildBottomNavRoutes(_currentIndex, context)),
          );
        });
  }
}
