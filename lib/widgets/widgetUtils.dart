import 'package:flutter/material.dart';
import 'package:order_management/service/utilService.dart';

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
