import 'package:flutter/material.dart';
import 'package:order_management/service/appConfigService.dart';
import 'package:order_management/service/handlerService.dart';
import 'package:order_management/service/loginService.dart';
import 'package:provider/provider.dart';

class LoginProfile extends StatefulWidget {
  LoginProfile({Key key}) : super(key: key);
  @override
  _LoginProfileState createState() => _LoginProfileState();
}

class _LoginProfileState extends State<LoginProfile> {
  final userCtrl = TextEditingController();
  var _loginSrv;

  @override
  Widget build(BuildContext context) {
    _loginSrv = Provider.of<LoginService>(context, listen: false);
    return Container(
      child: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 8.0, left: 8.0, top: 45.0, bottom: 15),
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
              child: FlatButton(
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: () async {
                    print(userCtrl.text);
                    var customer = await Provider.of<AppConfigService>(context,
                            listen: false)
                        .saveForm('customers', {"name": userCtrl.text},
                            _loginSrv.currentUser["belongs_to_customer"]["id"]);

                    // customer["belongs_to_customer"] =
                    //     getShortForm()["getCustomerShortForm"](customer);

                    await Provider.of<AppConfigService>(context, listen: false)
                        .saveForm(
                            'users',
                            getShortForm()["getCustomerShortForm"](customer),
                            _loginSrv.currentUser["_id"].id.hexString,
                            "belongs_to_customer");
                    //                        var customer = await db
                    //     .collection("customers")
                    //     .find(where.eq("phone_no", user.phoneNumber))
                    //     .toList();
                    // if (customer != null && customer.length != 0) {
                    //   model["belongs_to_customer"] = customer[0];
                    // }
                    Navigator.pushReplacementNamed(context, "/auth");
                  }),
            )
          ],
        ),
      ),
    );
  }
}
