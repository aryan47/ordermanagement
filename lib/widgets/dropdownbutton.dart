import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  CustomDropdownButton({Key key}) : super(key: key);

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: null,
      // itemHeight: 10,
      icon: Icon(Icons.more_vert),
      // iconSize: 10,
      // style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 0,
        color: Colors.transparent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Delivered','Cancel']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
