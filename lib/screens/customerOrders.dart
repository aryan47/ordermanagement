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
  var custOrders = [];
  Map args;
  var src;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context).settings.arguments;

    MyInheritedWidget.of(context)
        .getCustomerOrders(args["customerId"])
        .then((data) {
      print(data);
      setState(() {
        custOrders = data;
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
          title: Text('My Orders'),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: custOrders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  isThreeLine: true,
                  title: Text(
                    "Qty: " + custOrders[index]['quantity'].toString(),
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  subtitle: Text(DateFormat('dd-MMM-yyyy hh:mm')
                      .format(custOrders[index]['dt_order_place'])),
                  trailing: CustomDropdownButton(),
                  onTap: () {
                    // print(stateMachine);
                    // String route = srv.getV("actions.onTap.gotoRoute", stateMachine);
                    // Navigator.pushNamed(context, route, arguments: {"customerId": custOrders[index].id});
                  },
                );
              },
            ),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }
}
