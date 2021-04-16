import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:order_management/screens/models/customersModel.dart';
import 'package:order_management/service/loginService.dart';
import 'package:order_management/service/utilService.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaml/yaml.dart';

// ignore: must_be_immutable
class AppConfigService {
  dynamic appConfig;
  dynamic db;
  List<CustomersM> custM;
  BehaviorSubject listLoaded = BehaviorSubject.seeded(false);

  Map<String, dynamic> get config => appConfig;

  Future initDB() async {
    final content =
        await rootBundle.loadString("assets/configuration/config.yaml");

    final cred =
        await rootBundle.loadString("assets/configuration/credential.json");

    db = await Db.create(jsonDecode(cred)["mongo"]["url"]);

    // appConfig = jsonDecode(content);
    dynamic yamlContent = loadYaml(content);
    appConfig = json.decode(json.encode(yamlContent));
    print('initDB');
    return await db.open();
  }

  /// Build bottom navigation list based on config
  List<BottomNavigationBarItem> buildBottomNavList() {
    List<BottomNavigationBarItem> list = [];
    if (exists("BOTTOM_NAV_ITEMS.value", appConfig)) {
      for (var i = 0;
          i < getV("BOTTOM_NAV_ITEMS.items", appConfig).length;
          i++) {
        list.add(BottomNavigationBarItem(
          icon: getI("icon", getV("BOTTOM_NAV_ITEMS.items", appConfig)[i]),
          title:
              new Text(getV("BOTTOM_NAV_ITEMS.items", appConfig)[i]["label"]),
        ));
      }
    }
    return list;
  }

  // Build drawer list
  List<Widget> buildDrawerList(context, _loginSrv) {
    List<Widget> list = [];
    if (exists("DRAWER.value", appConfig)) {
      if (exists("DRAWER.header", appConfig)) {
        list.add(DrawerHeader(
          child: Center(
            child: Text(
                transformText(
                    getV("DRAWER.header.label", appConfig), _loginSrv),
                style: TextStyle(color: Colors.white)),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
        ));
      }

      for (var i = 0; i < getV("DRAWER.items", appConfig).length; i++) {
        Map<String, Function> actions =
            buildRoute(getV("DRAWER.items", appConfig)[i], context);

        list.add(ListTile(
          leading: getI("leading.icon", getV("DRAWER.items", appConfig)[i]),
          title: new Text(getV("DRAWER.items", appConfig)[i]["label"]),
          trailing: Text(
              getV("trailing.text", getV("DRAWER.items", appConfig)[i]) ?? ""),
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
      var actions = getV("actions.onTap", src);
      actions = actions.keys.toList()[0];
      switch (actions) {
        case "gotoRoute":
          String route = getV("actions.onTap.gotoRoute", src);
          loadDataFromDB(getV("actions.onTap.gotoRoute", src));
          Navigator.pushNamed(context, route);
          break;
        case "action":
          if (getV("actions.onTap.action", src) == "C_ACTION_LOGOUT") {
            // FirebaseAuth.instance.signOut();
            LoginService().signOut(context);
          } else if (getV("actions.onTap.action", src) == "C_ACTION_CALL") {
            launch("tel:" + this.appConfig["GENERAL_SETTINGS"]["phone"]);
          }
          break;
      }
    };
    return routes;
  }

  /// Build Route to screen
  Map<String, Function> buildBottomNavRoutes(_currentIndex, context) {
    Map<String, Function> routes = {};
    routes["onTap"] = (int index) {
      _currentIndex = index;
      String route = getV("actions.onTap.gotoRoute",
          getV("BOTTOM_NAV_ITEMS.items", appConfig)[index]);

      if (route != null) Navigator.pushNamed(context, route);
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
              .eq("belongs_to_customer.id", id)
              .eq('status', "K_STATE_NEW")
              .eq('last_action', "K_ACTION_CREATE")
              .sortBy('dt_delivery', descending: true))
          .toList();
      return data;
    } else {
      var data = await db
          .collection("orders")
          .find(where
              .eq('status', "K_STATE_NEW")
              .eq('last_action', "K_ACTION_CREATE")
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
              .eq("belongs_to_customer.id", id)
              .ne('status', "K_STATE_NEW")
              .ne('last_action', "K_ACTION_CREATE")
              .sortBy('dt_last_action', descending: true))
          .toList();
      return data;
    } else {
      var data = await db
          .collection("orders")
          .find(where
              .ne('status', "K_STATE_NEW")
              .ne('last_action', "K_ACTION_CREATE")
              .sortBy('dt_last_action', descending: true))
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

  dynamic getModelByID(refModel, id) async {
    var data = await db
        .collection(refModel)
        .find(where.id(ObjectId.parse(id)))
        .toList();
    print(data);
    return data;
  }

  /// Saves the form in the [colName]
  /// [model] data to update
  /// [refId] used while update operation. refId should be the id field of the collection
  /// [key] used if the data is nested
  /// eg: `saveForm('customers', {"name": userCtrl.text},_loginSrv.currentUser["belongs_to_customer"]["id"])`
  /// returns the updated model data
  dynamic saveForm(colName, model, [refId, key]) async {
    var refItem;
    var modelToUpdate = model;
    if (refId != null) {
      refItem = await db
          .collection(colName)
          .find(where.id(ObjectId.parse(refId)))
          .toList();
      if (key != null) {
        refItem[0][key] = model;
        modelToUpdate = refItem[0];
      } else {
        refItem[0].addAll(model);
        modelToUpdate = refItem[0];
      }
    }
    await db.collection(colName).save(modelToUpdate);
    return modelToUpdate;
  }
}
