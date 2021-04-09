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
        body: ListView(shrinkWrap: true, children: <Widget>[
          Container(
            height: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                image: DecorationImage(
                    image: AssetImage('assets/images/logo.jpg'),
                    fit: BoxFit.fill)),
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10))
                      ]),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[100]))),
                        child: TextField(
                          controller: phoneCtrl,
                          decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.phone, color: Colors.grey[400]),
                              border: InputBorder.none,
                              hintText: "Phone number",
                              hintStyle: TextStyle(color: Colors.grey[400])),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.all(8.0),
                      //   child: TextField(
                      //     decoration: InputDecoration(
                      //         border: InputBorder.none,
                      //         hintText: "Password",
                      //         hintStyle: TextStyle(color: Colors.grey[400])),
                      //   ),
                      // )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    print(phoneCtrl.text.length);
                    if (phoneCtrl.text.length < 10 || phoneCtrl.text.length > 10) {
                      final snackBar = SnackBar(
                          content: Text('Please enter valid phone number !'));

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else
                      Provider.of<LoginService>(context, listen: false)
                          .initLogin("+91" + phoneCtrl.text, context);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(143, 148, 255, 1),
                          Color.fromRGBO(143, 148, 255, .6),
                        ])),
                    child: Center(
                      child: Text(
                        "Lets Go !",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Text(
                  "Welcome back",
                  style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
                ),
              ],
            ),
          )
        ]

            // [
            //   Image.asset("assets/images/logo.jpg"),
            //   Padding(
            //     padding: const EdgeInsets.only(
            //         right: 8.0, left: 8.0, top: 45.0, bottom: 15),
            //     child: TextField(
            //         controller: phoneCtrl,
            //         onChanged: null,
            //         decoration: InputDecoration(
            //             labelText: "Mobile Number",
            //             prefixText: "+91",
            //             border: new OutlineInputBorder(
            //                 borderSide: new BorderSide(color: Colors.teal))),
            //         keyboardType: TextInputType.number,
            //         inputFormatters: <TextInputFormatter>[
            //           FilteringTextInputFormatter.digitsOnly
            //         ]),
            //   ),
            //   Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: FlatButton(
            //         child: Text(
            //           "GET OTP",
            //           style: TextStyle(color: Colors.white),
            //         ),
            //         color: Colors.blue,
            //         onPressed: () {
            //           print(phoneCtrl.text);
            //           Provider.of<LoginService>(context, listen: false)
            //               .initLogin("+91" + phoneCtrl.text, context);
            //         }),
            //   )
            // ],

            ),
      ),
    );
  }
}
