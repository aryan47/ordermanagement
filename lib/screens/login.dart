import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:order_management/service/loginService.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final phoneCtrl = TextEditingController();
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
                  controller: phoneCtrl,
                  onChanged: null,
                  decoration: InputDecoration(
                      labelText: "Mobile Number",
                      prefixText: "+91",
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal))),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                  child: Text(
                    "GET OTP",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    print(phoneCtrl.text);
                    Provider.of<LoginService>(context, listen: false)
                        .initLogin("+91"+phoneCtrl.text, context);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
