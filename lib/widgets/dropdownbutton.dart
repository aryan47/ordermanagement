import 'package:flutter/material.dart';
import '../service/handlerService.dart';

class CustomDropdownButton extends StatefulWidget {
  final List data;
  final Function onCustomDropdownTap;
  // Used to store refData; it is used if we want to pass data to oncustomDropdownTap function
  final refData;
  CustomDropdownButton(
      {Key key, @required this.data, this.refData, this.onCustomDropdownTap})
      : super(key: key);
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
        dropdownValue = newValue;
        // productAction(dropdownValue);
        // getShortForm()[fieldDef["autoFillHandler"]["handler"]](data);
        widget.onCustomDropdownTap(dropdownValue, widget.refData);
        setState(() {});
      },
      items: widget.data.map((var eachData) {
        return new DropdownMenuItem<String>(
          value: eachData.keys.first,
          child: new Text(eachData.values.first),
        );
      }).toList(),
    );
  }
}
