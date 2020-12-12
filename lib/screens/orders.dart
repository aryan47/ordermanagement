import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_management/service/mainService.dart';
import 'package:order_management/widgets/dropdownbutton.dart';

class Orders extends StatefulWidget {
  Orders({Key key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  var pastOrders = [];
  var futureOrders = [];

  Map args;
  var src;
  String title = '';
  bool onlyOrders = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context).settings.arguments;

    if (args == null) {
      args = new Map();
      args["customerId"] = null;
      onlyOrders = true;
    }
    MyInheritedWidget.of(context)
        .getCustomerPastOrders(args["customerId"])
        .then((data) {
      setState(() {
        pastOrders = data;
        if (pastOrders.length != 0)
          title = onlyOrders ? "Orders List" : pastOrders[0]["name"];
      });
    });

    MyInheritedWidget.of(context)
        .getCustomerFutureOrders(args["customerId"])
        .then((data) {
      setState(() {
        if (futureOrders.length != 0)
          title = onlyOrders ? "Orders List" : futureOrders[0]["name"];
        futureOrders = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Upcoming Orders",
              ),
              Tab(
                text: "Past Orders",
              ),
            ],
          ),
          title: Text(title),
        ),
        body: TabBarView(
          children: [
            buildListViewForOrders(futureOrders, true),
            buildListViewForOrders(pastOrders),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "/forms",
                arguments: {"formType": "K_FORM_ORDERS"});
          },
          tooltip: 'Add Orders',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  ListView buildListViewForOrders(orders, [bool showMore]) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return ListTile(
          isThreeLine: true,
          title: Text(
            "Qty: " + orders[index]['quantity'].toString(),
            style: TextStyle(color: Colors.blueAccent),
          ),
          subtitle: Text(DateFormat('dd-MMM-yyyy hh:mm')
              .format(orders[index]['dt_order_place'])),
          trailing: showMore == true ? CustomDropdownButton() : null,
          onTap: () {
            // String route = srv.getV("actions.onTap.gotoRoute", stateMachine);
            // Navigator.pushNamed(context, route, arguments: {"customerId": custOrders[index].id});
          },
        );
      },
    );
  }
}
