import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:order_management/screens/customers.dart';
import 'package:order_management/screens/dashboard.dart';
import 'package:order_management/screens/home.dart';
import 'package:order_management/screens/orders.dart';
import 'package:order_management/screens/otp.dart';
import 'package:order_management/screens/products.dart';
import 'package:order_management/screens/settings.dart';
import 'package:order_management/service/DBService.dart';
import 'package:order_management/service/loginService.dart';
import 'package:order_management/widgets/myCustomForms.dart';
import 'package:provider/provider.dart';

// import 'service/login_store.dart';
import 'service/DBService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final content =
  //     await rootBundle.loadString("assets/configuration/config.json");

  // final cred =
  //     await rootBundle.loadString("assets/configuration/credential.json");
  // final db = await Db.create(jsonDecode(cred)["mongo"]["url"]);
  // await db.open();

//   await FirebaseAuth.instance.verifyPhoneNumber(
//   phoneNumber: '+917009224712',
//   verificationCompleted: (PhoneAuthCredential credential) {},
//   verificationFailed: (FirebaseAuthException e) {},
//   codeSent: (String verificationId, int resendToken) {},
//   codeAutoRetrievalTimeout: (String verificationId) {},
// );

    await Firebase.initializeApp();

  runApp(MyApp());
  // runApp(MyInheritedWidget(
  //     child: MyApp(), appConfig: jsonDecode(content), db: db));
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
        Provider<DBService>(
          create: (_) => DBService(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Home(),
        routes: {
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/home': (context) => Home(),
          '/otp': (context) => Otp(),
          '/dashboard': (context) => Dashboard(),
          '/product': (context) => Products(),
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
