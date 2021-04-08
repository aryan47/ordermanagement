import 'package:flutter/material.dart';

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
        // setState(() {
        return builder(snapshot.data);
        // return buildListViewForOrders(futureOrders, true);
      });
}
