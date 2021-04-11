import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:order_management/service/loginService.dart';
import 'package:order_management/widgets/widgetUtils.dart';
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
        backgroundColor: Colors.black,
        body: ListView(shrinkWrap: true, children: <Widget>[
          Container(
            height: 300,
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.only(
                // bottomLeft: Radius.circular(10),
                // bottomRight: Radius.circular(10)),
                image: DecorationImage(
                    image: AssetImage('assets/images/logo.jpg'),
                    fit: BoxFit.fill)),
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Container(
                    margin: EdgeInsets.only(top: 170, left: 35),
                    child: Text(
                      "Welcome",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Positioned(
                  child: Container(
                    margin: EdgeInsets.only(top: 210, left: 35),
                    child: Text(
                      "Glad to meet you",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              // image: DecorationImage(
              //     image: AssetImage('assets/images/logo.jpg'),
              //     fit: BoxFit.fill)
            ),
            child: Padding(
              padding: EdgeInsets.all(35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 25, bottom: 15.0),
                    child: Text("Sign in",
                        style: TextStyle(
                            color: Color.fromARGB(255, 9, 105, 163),
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(255, 9, 105, 163),
                              blurRadius: 20.0,
                              offset: Offset(0, 5))
                        ]),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8.0),
                          // decoration: BoxDecoration(
                          //     border: Border(
                          //         bottom: BorderSide(color: Colors.grey[100]))),
                          child: TextField(
                            controller: phoneCtrl,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone,
                                    color: Color.fromARGB(255, 9, 105, 163)),
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
                      if (phoneCtrl.text.length < 10 ||
                          phoneCtrl.text.length > 10) {
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
                        color: Color.fromARGB(255, 9, 105, 163),
                      ),
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
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite),
                        Text(
                          "Welcome back",
                          style: TextStyle(
                              color: Color.fromARGB(255, 9, 105, 163)),
                        ),
                        Icon(Icons.favorite),
                      ],
                    ),
                  ),
                ],
              ),
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
