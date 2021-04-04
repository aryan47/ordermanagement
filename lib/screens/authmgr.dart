import 'package:flutter/material.dart';
import 'package:order_management/screens/home.dart';
import 'package:order_management/screens/login.dart';
import 'package:order_management/service/appConfigService.dart';
import 'package:order_management/service/loginService.dart';
import 'package:order_management/service/utilService.dart';
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

  dynamic extractCurrentUser() async {
    var user = await _loginSrv.getCurrentUser(_dbSrv.db);
    _loginSrv.currentUser = user != null ? user[0] : user;
    return _loginSrv.currentUser;
  }

  Future initialize() async {
    _loginSrv = Provider.of<LoginService>(context, listen: false);
    _dbSrv = Provider.of<AppConfigService>(context, listen: false);
    var data = await _dbSrv.initDB();
    checkAuth();
    // Get the current loggedin user
    await extractCurrentUser();
    var currentUser =
        _loginSrv.currentUser != null ? _loginSrv.currentUser["role"] : null;
    // Modify the configuration based on user privileges
    applyUserPrivileges(_dbSrv.appConfig, currentUser);
    
    // If user name is not present then send user to login-profile page
    if (_loginSrv.currentUser != null &&
        _loginSrv.currentUser["belongs_to_customer"]["name"] == null) {
      // get the name and save it
      Navigator.pushReplacementNamed(context, "/login-profile");
    }
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
          return Scaffold(
            drawer: buildDrawer(_dbSrv.buildDrawerList(context, _loginSrv)),
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
