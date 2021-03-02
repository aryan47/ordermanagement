import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:order_management/screens/login.dart';
import 'package:order_management/screens/models/usersModel.dart';
import 'package:order_management/screens/otp.dart';
import 'package:order_management/service/DBService.dart';
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
    db = Provider.of<DBService>(context, listen: false).db;

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone != null ? phone : '+917009224712',
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('!!!!!!!!!!!!!verification completed');
          await FirebaseAuth.instance.signInWithCredential(credential);
          Navigator.pushReplacementNamed(context, "/products");
          createUser(db);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('!!!!!!!!!!!!!verification failed');
          print(e);
          Navigator.pushReplacementNamed(context, "/auth");
        },
        codeSent: (String verificationId, int resendToken) async {
          print('!!!!!!!!!!!!!code sent');
          String smsCode = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Otp()),
          );

          // Create a PhoneAuthCredential with the code
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: smsCode);

          // Sign the user in (or link) with the credential
          await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
          Navigator.pushReplacementNamed(context, "/auth");
          createUser(db);
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
