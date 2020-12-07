import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_management/service/mainService.dart';

class CustomerOrders extends StatefulWidget {
  CustomerOrders({Key key}) : super(key: key);

  @override
  _CustomerOrdersState createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders> {
  var custOrders = [];
  Map args;
  var src;
  @override
  void didUpdateWidget(covariant CustomerOrders oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    MyInheritedWidget.of(context)
        .getCustomerOrders(args["customerId"])
        .then((data) {
      print(data);
      custOrders = data;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;

    // print(custOrders);
    return Scaffold(
      appBar: AppBar(
        title: Text("CustomerOrders"),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: custOrders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(DateFormat('dd/MM/yyyy')
                .format(custOrders[index]['dt_order_place'])),
            subtitle: Text("Qty: " + custOrders[index]['quantity'].toString()),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // print(stateMachine);
              // String route = srv.getV("actions.onTap.gotoRoute", stateMachine);
              // Navigator.pushNamed(context, route, arguments: {"customerId": custOrders[index].id});
            },
          );
        },
      ),
    );
  }
}
