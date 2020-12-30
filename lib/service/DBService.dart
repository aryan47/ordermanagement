import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:order_management/screens/models/customersModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

// ignore: must_be_immutable
class DBService {
  Map<String, dynamic> appConfig;
  dynamic db;
  List<CustomersM> custM;
  BehaviorSubject listLoaded = BehaviorSubject.seeded(false);

  Map<String, dynamic> get config => appConfig;

  Future initDB() async {
    final content =
        await rootBundle.loadString("assets/configuration/config.json");

    final cred =
        await rootBundle.loadString("assets/configuration/credential.json");

    db = await Db.create(jsonDecode(cred)["mongo"]["url"]);

    appConfig = jsonDecode(content);
    print('initDB');
    return await db.open();
  }

  // DBService({@required Widget child, this.appConfig, this.db})

  // String _latestAppVersion;

  // @override
  // bool updateShouldNotify(Provider oldWidget) =>
  //     appConfig != oldWidget.appConfig;

  // set latestAppVersion(String version) => _latestAppVersion = version;
  // String get latestAppVersion => _latestAppVersion;

  // set appConfig(String share) => _appConfig = share;
  // BehaviorSubject get refresh => _refresh;

  // static Provider of(BuildContext context) {
  //   return context.dependOnInheritedWidgetOfExactType<Provider>();
  // }

  /// Check value exists inside Object
  bool _exists(String fetchV, [dynamic src]) {
    if (src == null) src = appConfig;
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
  dynamic getV(String fetchV, [dynamic src]) {
    if (src == null) src = appConfig;

    if (fetchV.isEmpty || src.isEmpty) return null;
    List<String> keys = fetchV.split(".");

    dynamic _fetchValue(List keys, dynamic src) {
      if (keys == null || keys.length == 0 || src == null) return null;
      if (keys.length == 1) return src[keys[0]];

      return _fetchValue(keys.sublist(1), src[keys.first]);
    }

    return _fetchValue(keys, src);
  }

  /// Get icon from config
  Widget _getI(icons, [dynamic src]) {
    if (icons == null) return null;
    if (src != null) icons = getV(icons, src);

    if (icons == null) return null;

    return Icon(IconData(int.parse(icons), fontFamily: 'MaterialIcons'));
  }

  /// Build bottom navigation list based on config
  List<BottomNavigationBarItem> buildBottomNavList() {
    List<BottomNavigationBarItem> list = [];
    if (_exists("BOTTOM_NAV_ITEMS.value")) {
      for (var i = 0; i < getV("BOTTOM_NAV_ITEMS.items").length; i++) {
        list.add(BottomNavigationBarItem(
          icon: _getI("icon", getV("BOTTOM_NAV_ITEMS.items")[i]),
          title: new Text(getV("BOTTOM_NAV_ITEMS.items")[i]["label"]),
        ));
      }
    }
    return list;
  }

  // Build drawer list
  List<Widget> buildDrawerList(context) {
    List<Widget> list = [];

    if (_exists("DRAWER.value")) {
      if (_exists("DRAWER.header")) {
        list.add(DrawerHeader(
          child: Text(getV("DRAWER.header.label")),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ));
      }

      for (var i = 0; i < getV("DRAWER.items").length; i++) {
        Map<String, Function> actions =
            buildRoute(getV("DRAWER.items")[i], context);

        list.add(ListTile(
          leading: _getI("leading.icon", getV("DRAWER.items")[i]),
          title: new Text(getV("DRAWER.items")[i]["label"]),
          trailing: Text(getV("trailing.text", getV("DRAWER.items")[i]) ?? ""),
          onTap: actions["onTap"],
        ));
      }
    }
    return list;
  }

  /// Build Route to screen
  Map<String, Function> buildRoute(dynamic src, context) {
    Map<String, Function> routes = {};
    routes["onTap"] = () {
      String route = getV("actions.onTap.gotoRoute", src);
      loadDataFromDB(getV("actions.onTap.gotoRoute", src));
      Navigator.pushNamed(context, route);
    };
    return routes;
  }

  /// Build Route to screen
  Map<String, Function> buildBottomNavRoutes(_currentIndex, context) {
    Map<String, Function> routes = {};
    routes["onTap"] = (int index) {
      _currentIndex = index;
      String route = getV(
          "actions.onTap.gotoRoute", getV("BOTTOM_NAV_ITEMS.items")[index]);
      print(route);

      Navigator.pushNamed(context, route);
    };
    return routes;
  }

  /// Load data from DB
  void loadDataFromDB(String url) async {
    if (url != null) {
      print('loding data from db...');
      var colName = url.substring(1);
      var data = await db.collection(colName).find().toList();
      switch (colName) {
        case "customers":
          data = data.map((custJson) => CustomersM.fromJson(custJson)).toList();
          custM = List<CustomersM>.from(data);
          listLoaded.add(true);
          break;
        default:
      }
    }
  }

  /// get customer data
  dynamic getCustomers() {
    return custM;
  }

  /// get customer data
  dynamic getCustomerFutureOrders(id) async {
    if (id != null) {
      var data = await db
          .collection("orders")
          .find(where
              .eq("belongs_to_customer.id", id.id.hexString)
              .ne('status', "Delivered")
              .sortBy('dt_delivery', descending: true))
          .toList();
      return data;
    } else {
      var data = await db
          .collection("orders")
          .find(where
              .ne('status', "Delivered")
              .sortBy('dt_delivery', descending: true))
          .toList();
      return data;
    }
  }

  /// get customer data
  dynamic getCustomerPastOrders(id) async {
    if (id != null) {
      var data = await db
          .collection("orders")
          .find(where
              .eq("belongs_to_customer.id", id.id.hexString)
              .eq('status', "Delivered")
              .sortBy('dt_delivery', descending: true))
          .toList();
      return data;
    } else {
      var data = await db
          .collection("orders")
          .find(where
              .eq('status', "Delivered")
              .sortBy('dt_delivery', descending: true))
          .toList();
      return data;
    }
  }

  /// get customer typeahead
  dynamic getTypeAhead(colName, value) async {
    var data = await db
        .collection(colName)
        .find(where.match('name', value, caseInsensitive: true).limit(5))
        .toList();
    return data;
  }

  dynamic getRefModel(refModel, id) async {
    var data = await db
        .collection(refModel)
        .find(where.id(ObjectId.parse(id)))
        .toList();
    print(data);
    return data;
  }

  dynamic saveForm(colName, model) async {
    var data = await db.collection(colName).save(model);
    print(data);
    return data;
  }
}
