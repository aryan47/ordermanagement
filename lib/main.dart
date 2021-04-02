import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:order_management/screens/customers.dart';
import 'package:order_management/screens/dashboard.dart';
import 'package:order_management/screens/authmgr.dart';
import 'package:order_management/screens/login_profile.dart';
import 'package:order_management/screens/orders.dart';
import 'package:order_management/screens/otp.dart';
import 'package:order_management/screens/products.dart';
import 'package:order_management/screens/settings.dart';
import 'package:order_management/service/appConfigService.dart';
import 'package:order_management/service/loginService.dart';
import 'package:order_management/widgets/myCustomForms.dart';
import 'package:provider/provider.dart';

// import 'service/login_store.dart';
import 'service/appConfigService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintSizeEnabled= false;
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoginService>(
          create: (_) => LoginService(),
        ),
        Provider<AppConfigService>(
          create: (_) => AppConfigService(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthMgr(),
        routes: {
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/auth': (context) => AuthMgr(),
          '/login-profile': (context) => LoginProfile(),
          '/otp': (context) => Otp(),
          '/dashboard': (context) => Dashboard(),
          '/products': (context) => Products(),
          '/orders': (context) => Orders(),
          '/settings': (context) => Settings(),
          '/customers': (context) => Customers(),
          '/payment': (context) => Dashboard(),
          '/forms': (context) => MyCustomForm()
        },
      ),
    );
  }
}
