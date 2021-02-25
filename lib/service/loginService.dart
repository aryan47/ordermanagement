import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<bool> isAlreadyAuthenticated() {}

  void initLogin(String phone) async {
    await Firebase.initializeApp();

    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone != null ? phone : '+917009224712',
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('!!!!!!!!!!!!!verification completed');
          await FirebaseAuth.instance.signInWithCredential(credential);
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
}
