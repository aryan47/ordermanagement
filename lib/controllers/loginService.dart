import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:order_management/views/login.dart';
import 'package:order_management/models/usersModel.dart';
import 'package:order_management/views/otp.dart';
import 'package:order_management/controllers/appConfigService.dart';
import 'package:order_management/controllers/handlerService.dart';
import 'package:order_management/widgets/widgetUtils.dart';
import 'package:provider/provider.dart';

class LoginService {
  FirebaseAuth? _firebaseAuth;
  var db;
  var currentUser;

  Future<bool> isAlreadyAuthenticated() async {
    var user = FirebaseAuth.instance.currentUser;
    print("isAlreadyAuthenticated......................");
    return user != null;
  }

  dynamic createUser(db) async {
    var user = FirebaseAuth.instance.currentUser!;
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
        return user;
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
            getShortForm()["getCustomerShortForm"]!(custData[0]);
      }

      model["phoneNumber"] = user.phoneNumber;
      model["uid"] = user.uid;
      model["role"] = "K_USER";
      await db.collection("users").save(model);
      return user;
    }
  }

  dynamic? getCurrentUser(db) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
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
            // used to remove login screen on back navigation
            Navigator.of(context).pop();
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
        codeSent: (String verificationId, int? resendToken) async {
          print('!!!!!!!!!!!!!code sent');
          String? smsCode = await showMyDialog(context);
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
            try {
              await FirebaseAuth.instance
                  .signInWithCredential(phoneAuthCredential);
            } on FirebaseAuthException catch (e) {
              Navigator.of(context).pop();
              final snackBar =
                  SnackBar(content: Text('Please enter valid OTP'));

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return;
            } catch (e) {
              Navigator.of(context).pop();
              final snackBar =
                  SnackBar(content: Text('Please enter valid OTP'));

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return;
              // Navigator.pushReplacementNamed(context, "/auth");
            }
            await createUser(db);
            // Used to close the showLoaderDialog
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, "/auth");
          } else {
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
