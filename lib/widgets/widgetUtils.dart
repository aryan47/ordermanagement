import 'package:flutter/material.dart';

BottomNavigationBar buildBottomNavigationBar(list, _currentIndex) {
  if (list.isEmpty)
    return null;
  else
    return BottomNavigationBar(
      backgroundColor: Colors.grey[100],
      onTap: (int index) {
        _currentIndex = index;
        switch (index) {
          case 0:
            // detailsPage();
            break;
          case 1:
            // countryList();
            break;
          case 2:
            // changeContext('Global');
            break;
        }
      },
      currentIndex: _currentIndex, // this will be set when a new tab is tapped
      items: list,
    );
}

Widget buildDrawer(list) {
  if (list.isEmpty) return null;

  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: list,
    ),
  );
}
