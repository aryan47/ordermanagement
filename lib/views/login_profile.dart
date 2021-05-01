import 'package:flutter/material.dart';
import 'package:order_management/controllers/appConfigService.dart';
import 'package:order_management/controllers/handlerService.dart';
import 'package:order_management/controllers/loginService.dart';
import 'package:provider/provider.dart';

class LoginProfile extends StatefulWidget {
  LoginProfile({Key? key}) : super(key: key);
  @override
  _LoginProfileState createState() => _LoginProfileState();
}

class _LoginProfileState extends State<LoginProfile> {
  final userCtrl = TextEditingController();
  late var _loginSrv;

  @override
  Widget build(BuildContext context) {
    _loginSrv = Provider.of<LoginService>(context, listen: false);
    return Container(
      child: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: 30),
            Center(
                child: CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 70),
            )),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: userCtrl,
                onChanged: null,
                decoration: InputDecoration(
                    labelText: "Your Name",
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  if (userCtrl.text.toString().length == 0) {
                    final snackBar =
                        SnackBar(content: Text('Please enter your name !'));

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    var customer = await Provider.of<AppConfigService>(context,
                            listen: false)
                        .saveForm('customers', {"name": userCtrl.text},
                            _loginSrv.currentUser["belongs_to_customer"]["id"]);

                    await Provider.of<AppConfigService>(context, listen: false)
                        .saveForm(
                            'users',
                            getShortForm()["getCustomerShortForm"]!(customer),
                            _loginSrv.currentUser["_id"].id.hexString,
                            "belongs_to_customer");
                    Navigator.pushReplacementNamed(context, "/auth");
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 9, 105, 163),
                  ),
                  child: Center(
                    child: Text(
                      "Lets Go !",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
