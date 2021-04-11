import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

BottomNavigationBar buildBottomNavigationBar(list, action) {
  if (list.isEmpty)
    return null;
  else
    return BottomNavigationBar(
      backgroundColor: Colors.grey[100],
      onTap: action["onTap"],
      currentIndex: 0, // this will be set when a new tab is tapped
      items: list,
    );
}

Widget buildDrawer(list) {
  if (list.isEmpty) return null;
  return Drawer(
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: list,
    ),
  );
}

FutureBuilder customLoader({future, Function builder}) {
  return FutureBuilder<dynamic>(
      future: future,
      builder: (context, snapshot) {
        if ((snapshot.data == null ||
            snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.waiting)) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
        return builder(snapshot.data);
      });
}

Future showMyDialog(context) async {
  var optCtrl = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.only(left: 24.0),
        actionsPadding: EdgeInsets.all(0.0),
        buttonPadding: EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Detecting OTP',
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 9, 105, 163))),
              SizedBox(height: 5),
              Text(
                'We have sent a 6-digits OTP on mobile number',
                style: TextStyle(fontSize: 13, color: Colors.black),
              )
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                  controller: optCtrl,
                  onChanged: null,
                  decoration: InputDecoration(
                    labelText: "Enter OTP",
                    // border: new OutlineInputBorder(
                    //     borderSide: new BorderSide(color: Colors.teal)),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ]),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Waiting for OTP ",
                      style: TextStyle(fontSize: 13, color: Colors.black)),
                  SizedBox(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                      height: 15,
                      width: 15)
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Verify',
                style: TextStyle(color: Color.fromARGB(255, 9, 105, 163))),
            onPressed: () {
              Navigator.of(context).pop(optCtrl.text);
            },
          ),
        ],
      );
    },
  );
}

Future showLoaderDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        ],
      );
    },
  );
}
