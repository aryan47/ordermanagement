import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:order_management/service/loginService.dart';
import 'package:provider/provider.dart';

class Otp extends StatefulWidget {
  Otp({Key key}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final optCtrl = TextEditingController();
  var args;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // args = ModalRoute.of(context).settings.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 8.0, left: 8.0, top: 45.0, bottom: 15),
              child: TextField(
                  controller: optCtrl,
                  onChanged: null,
                  decoration: InputDecoration(
                      labelText: "Enter OTP",
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal))),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Waiting for OTP "),
                SizedBox(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                    height: 15,
                    width: 15)
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                  child: Text(
                    "Verify",
                    style: TextStyle(color: Colors.white),
                  ),
                  // color: Colors.blue,
                  onPressed: () {
                    print(optCtrl.text);
                    Navigator.pop(context, optCtrl.text);
                    // Provider.of<LoginService>(context, listen: false)
                    //     .initLogin("+91" + args.phoneNumber, optCtrl.text, context);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
