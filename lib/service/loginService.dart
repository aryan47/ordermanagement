import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:order_management/screens/login.dart';
import 'package:order_management/screens/models/usersModel.dart';
import 'package:order_management/screens/otp.dart';
import 'package:order_management/service/appConfigService.dart';
import 'package:order_management/service/handlerService.dart';
import 'package:order_management/widgets/widgetUtils.dart';
import 'package:provider/provider.dart';

class LoginService {
  FirebaseAuth _firebaseAuth;
  var db;
  var currentUser;

  Future<bool> isAlreadyAuthenticated() async {
    var user = FirebaseAuth.instance.currentUser;
    print("isAlreadyAuthenticated......................");
    // createUser(user, db);
    print(user);
    return user != null;
  }

  dynamic createUser(db) async {
    var user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> model = {};

    var data = await db
        .collection("users")
        .find(where.eq("phoneNumber", user.phoneNumber))
        .toList();

    if (data == null || data.length == 0) {
      var customer = await db
          .collection("customers")
          .find(where.eq("phone_no", user.phoneNumber))
          .toList();
      if (customer != null && customer.length != 0) {
        model["belongs_to_customer"] = customer[0];
      } else {
        // create customer and add reference to the user collection
        Map<String, dynamic> cust = {};
        cust["dt_join"] = new DateTime.now();
        cust["phone_no"] = user.phoneNumber;
        cust["is_active"] = true;
        await db.collection("customers").save(cust);
        var custData = await db
            .collection("customers")
            .find(where.eq("phone_no", user.phoneNumber))
            .toList();

        model["belongs_to_customer"] =
            getShortForm()["getCustomerShortForm"](custData[0]);
      }

      model["phoneNumber"] = user.phoneNumber;
      model["uid"] = user.uid;
      model["role"] = "K_USER";
      var data = await db.collection("users").save(model);

      print(data);
    }
    return user;
  }

  dynamic getCurrentUser(db) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print(user);
      var data = await db
          .collection("users")
          .find(where.eq("phoneNumber", user.phoneNumber))
          .toList();
      return data;
    }
    return null;
  }

  Future<void> initLogin(String phone, context) async {
    await Firebase.initializeApp();
    showLoaderDialog(context);
    db = Provider.of<AppConfigService>(context, listen: false).db;

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone != null ? phone : '+917009224712',
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('!!!!!!!!!!!!!verification completed');
          var status =
              await FirebaseAuth.instance.signInWithCredential(credential);
          if (status.user != null) {
            await createUser(db);
            Navigator.pushReplacementNamed(context, "/auth");
          } else {
            print("wrong otp===========================");
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print('!!!!!!!!!!!!!verification failed');
          print(e);
          Navigator.pushReplacementNamed(context, "/auth");
        },
        codeSent: (String verificationId, int resendToken) async {
          print('!!!!!!!!!!!!!code sent');
          String smsCode = await showMyDialog(context);
          // String smsCode = await Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => Otp()),
          // );

          if (smsCode != null) {
            // Create a PhoneAuthCredential with the code
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verificationId, smsCode: smsCode);

            // Sign the user in (or link) with the credential
            await FirebaseAuth.instance
                .signInWithCredential(phoneAuthCredential);
            await createUser(db);
            // Used to close the showLoaderDialog
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, "/auth");
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('!!!!!!!!!!!!!auto retrieval timeout');
        },
      );
      // createUser(db);
    } catch (e) {
      print('!!!!!!!!!!!!!error');
      print(e);
      // showSnackbar("Failed to Verify Phone Number: ${e}");
    }
  }

  void signOut(context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => Login()),
        (Route<dynamic> route) => false);
  }
}
