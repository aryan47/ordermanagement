import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginService {
  FirebaseAuth _firebaseAuth;
  Future<bool> isAlreadyAuthenticated() async {
    await Firebase.initializeApp();
    var user = FirebaseAuth.instance.currentUser;
    print("isAlreadyAuthenticated......................");
    print(user);
    return user != null;
  }

  void initLogin(String phone, context) async {
    await Firebase.initializeApp();

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone != null ? phone : '+917009224712',
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('!!!!!!!!!!!!!verification completed');
          await FirebaseAuth.instance.signInWithCredential(credential);
          Navigator.pushReplacementNamed(context, "/home");
          
        },
        verificationFailed: (FirebaseAuthException e) {
          print('!!!!!!!!!!!!!verification failed');
        },
        codeSent: (String verificationId, int resendToken) async {
          print('!!!!!!!!!!!!!code sent');
          String smsCode = '123456';

          // Create a PhoneAuthCredential with the code
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: smsCode);

          // Sign the user in (or link) with the credential
          await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
          Navigator.pushReplacementNamed(context, "/home");

        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('!!!!!!!!!!!!!auto retrieval timeout');
        },
      );
    } catch (e) {
      print('!!!!!!!!!!!!!error');
      print(e);
      // showSnackbar("Failed to Verify Phone Number: ${e}");
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
