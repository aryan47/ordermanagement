import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_management/service/mainService.dart';
import 'package:order_management/widgets/dropdownbutton.dart';

class CustomerOrders extends StatefulWidget {
  CustomerOrders({Key key}) : super(key: key);

  @override
  _CustomerOrdersState createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders> {
  var custPastOrders = [];
  var custFutureOrders = [];

  Map args;
  var src;
  String title = '';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context).settings.arguments;

    MyInheritedWidget.of(context)
        .getCustomerPastOrders(args["customerId"])
        .then((data) {
      print(data);
      setState(() {
        custPastOrders = data;
        if (custPastOrders.length != 0)
          title = custPastOrders[0]["customer_name"];
      });
    });

    MyInheritedWidget.of(context)
        .getCustomerFutureOrders(args["customerId"])
        .then((data) {
      print(data);
      setState(() {
        if (custFutureOrders.length != 0)
          title = custFutureOrders[0]["customer_name"];
        custFutureOrders = data;
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
            buildListViewForOrders(custFutureOrders, true),
            buildListViewForOrders(custPastOrders),
          ],
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
            // print(stateMachine);
            // String route = srv.getV("actions.onTap.gotoRoute", stateMachine);
            // Navigator.pushNamed(context, route, arguments: {"customerId": custOrders[index].id});
          },
        );
      },
    );
  }
}
