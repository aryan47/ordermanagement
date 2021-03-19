import 'package:flutter/material.dart';
import 'package:order_management/screens/home.dart';
import 'package:order_management/screens/login.dart';
import 'package:order_management/service/appConfigService.dart';
import 'package:order_management/service/loginService.dart';
import 'package:order_management/widgets/widgetUtils.dart';
import 'package:provider/provider.dart';

class AuthMgr extends StatefulWidget {
  AuthMgr({Key key}) : super(key: key);

  @override
  _AuthMgrState createState() => _AuthMgrState();
}

class _AuthMgrState extends State<AuthMgr> {
  List bottomNavList = [];
  int _currentIndex = 0;
  Map<String, dynamic> appConfig;
  bool authChecked = false;
  var _dbSrv;
  var _loginSrv;

  void checkAuth() {
    if (authChecked == true) return;
    _loginSrv.isAlreadyAuthenticated().then((result) {
      authChecked = true;
      if (result == true) {
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => Login()),
            (Route<dynamic> route) => false);
      }
    });
  }

  dynamic extractCurrentUser() {
    _loginSrv.getCurrentUser(_dbSrv.db).then((user) {
      _loginSrv.currentUser = user != null ? user[0] : user;
      print(_loginSrv.currentUser);
      return user;
    });
  }

  Future initialize() async {
    _loginSrv = Provider.of<LoginService>(context, listen: false);
    _dbSrv = Provider.of<appConfigService>(context, listen: false);
    var data = await _dbSrv.initDB();
    checkAuth();
    extractCurrentUser();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: initialize(),
        builder: (context, snapshot) {
          if ((snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting)) {
            return Container();
          }
          print("home build method called==========================");
          return Scaffold(
            drawer: buildDrawer(_dbSrv.buildDrawerList(context)),
            appBar: AppBar(
              title: Text("Product Management"),
            ),
            body: Home(),
            bottomNavigationBar: buildBottomNavigationBar(
                _dbSrv.buildBottomNavList(),
                _dbSrv.buildBottomNavRoutes(_currentIndex, context)),
          );
        });
  }
}
