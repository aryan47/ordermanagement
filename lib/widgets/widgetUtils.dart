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
        contentPadding: EdgeInsets.all(10.0),
        actionsPadding: EdgeInsets.all(5.0),
        buttonPadding: EdgeInsets.all(5.0),
        title: Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Text('Enter OTP'),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
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
              SizedBox(height: 10.0),
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
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Verify'),
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
