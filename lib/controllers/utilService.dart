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
Widget? getI(String? icons, dynamic src, [double size = 30]) {
  if (icons == null) return null;
  if (src != null) icons = getV(icons, src);

  if (icons == null) return null;

  return Icon(
    IconData(int.parse(icons), fontFamily: 'MaterialIcons'),
    size: size,
  );
}

void applyUserPrivileges(Map? config, userRole) {
  if (userRole == null) {
    return;
  }
  Map? userPriv = getV("USER_PRIVILEGES." + userRole, config);
  if (userPriv != null && userPriv.isNotEmpty) {
    userPriv.forEach((k, v) {
      // get items from config
      dynamic items = getV(k, config);
      var privEachItem = userPriv[k];
      if (items is List) {
        List itemsCopy = [];
        for (var i = 0; i < items.length; i++) {
          if (privEachItem[items[i]['key']] != false) {
            itemsCopy.add(items[i]);
          }
        }
        items.clear();
        items.addAll(itemsCopy);
      } else if (items is Map) {
        items.removeWhere((k, v) => privEachItem[k] == false);
      }
    });
  }
}

String transformText(String text, loginSrv) {
  var textArrResult = [];
  var textArr = text.split(" ");
  textArr.asMap().forEach((index, field) {
    switch (field) {
      case "\$\$K_LOGGED_IN_CUSTOMER_NAME":
        print("current user: ");
        // textArr.removeAt(index);
        if (loginSrv != null &&
            loginSrv.currentUser != null &&
            loginSrv.currentUser["belongs_to_customer"] != null)
          textArrResult.add(loginSrv.currentUser["belongs_to_customer"]
                  ["name"] ??
              loginSrv.currentUser["belongs_to_customer"]["phone_no"]);
        break;
      case "\$\$K_LOGGED_IN_CUSTOMER_ID":
        // textArr.removeAt(index);
        if (loginSrv != null &&
            loginSrv.currentUser != null &&
            loginSrv.currentUser["belongs_to_customer"] != null)
          textArrResult.add(loginSrv.currentUser["belongs_to_customer"]["id"]);
        break;
      default:
        textArrResult.add(field);
    }
  });
  return textArrResult.join(" ");
}
