import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

// ignore: must_be_immutable
class MyInheritedWidget extends InheritedWidget {
  MyInheritedWidget({
    Key key,
    @required Widget child,
    this.appConfig,
  }) : super(key: key, child: child);

  Map<String, dynamic> appConfig;

  // String _latestAppVersion;

  // BehaviorSubject _refresh = BehaviorSubject.seeded(false);

  Map<String, dynamic> get config => appConfig;

  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) =>
      appConfig != oldWidget.appConfig;

  // set latestAppVersion(String version) => _latestAppVersion = version;
  // String get latestAppVersion => _latestAppVersion;

  // set appConfig(String share) => _appConfig = share;
  // BehaviorSubject get refresh => _refresh;

  static MyInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }

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
  dynamic _getV(String fetchV, [dynamic src]) {
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
    if (src != null) icons = _getV(icons, src);

    if (icons == null) return null;

    return Icon(IconData(int.parse(icons), fontFamily: 'MaterialIcons'));
  }

  /// Build bottom navigation list based on config
  List<BottomNavigationBarItem> buildBottomNavList() {
    List<BottomNavigationBarItem> list = [];
    if (_exists("BOTTOM_NAV_ITEMS.value")) {
      for (var i = 0; i < _getV("BOTTOM_NAV_ITEMS.items").length; i++) {
        list.add(BottomNavigationBarItem(
          icon: new Icon(Icons.more),
          title: new Text(_getV("BOTTOM_NAV_ITEMS.items")[i]["label"]),
        ));
      }
    }
    return list;
  }

  // Build drawer list
  List<Widget> buildDrawerList() {
    List<Widget> list = [];

    if (_exists("DRAWER.value")) {
      if (_exists("DRAWER.header")) {
        list.add(DrawerHeader(
          child: Text(_getV("DRAWER.header.label")),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ));
      }

      for (var i = 0; i < _getV("DRAWER.items").length; i++) {
        list.add(ListTile(
          leading: _getI("leading.icon", _getV("DRAWER.items")[i]),
          title: new Text(_getV("DRAWER.items")[i]["label"]),
          trailing: Text(_getV("trailing.text",_getV("DRAWER.items")[i])??""),
        ));
      }
    }
    return list;
  }
}
