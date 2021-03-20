
import 'package:flutter/material.dart';

// Map<String, dynamic> appConfig;
dynamic db;

// Map<String, dynamic> get config => appConfig;

/// Check value exists inside Object
bool exists(String fetchV, dynamic src) {
  // if (src == null) src = appConfig;
  List<String> keys;
  bool res = false;
  var item;

  if (fetchV.isEmpty) return res;

  if (src == null || src.isEmpty) return res;

  keys = fetchV.split(".");
  item = src[keys[0]];

  for (int count = 0; count < keys.length; count++) {
    if (count == 0) continue;
    res = true;
    if (item == null) return false;
    item = item[keys[count]];
  }
  return res;
}

/// Get value from inside object
dynamic getV(String fetchV, dynamic src) {
  // if (src == null) src = appConfig;

  if (fetchV.isEmpty || src.isEmpty) return null;
  List<String> keys = fetchV.split(".");

  dynamic fetchValue(List keys, dynamic src) {
    if (keys == null || keys.length == 0 || src == null) return null;
    if (keys.length == 1) return src[keys[0]];

    return fetchValue(keys.sublist(1), src[keys.first]);
  }

  return fetchValue(keys, src);
}

/// Get icon from config
Widget getI(icons, dynamic src) {
  if (icons == null) return null;
  if (src != null) icons = getV(icons, src);

  if (icons == null) return null;

  return Icon(IconData(int.parse(icons), fontFamily: 'MaterialIcons'));
}
