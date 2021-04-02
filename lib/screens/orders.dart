import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:order_management/service/appConfigService.dart';
import 'package:order_management/service/loginService.dart';
import 'package:order_management/widgets/dropdownbutton.dart';
import 'package:provider/provider.dart';

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
  String title = "Orders List";
  bool onlyOrders = false;
  var result;
  var _loginSrv;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context).settings.arguments;
    _loginSrv = Provider.of<LoginService>(context, listen: false);

    // if (args == null) {
    //   args = new Map();
    //   args["customerId"] = null;
    //   onlyOrders = true;
    // }
    getCustomerPastOrders(_loginSrv.currentUser);

    getCustomerFutureOrders(_loginSrv.currentUser);
  }

  void getCustomerFutureOrders(currentUsr) {
    var customerId;
    if (currentUsr["role"] == "K_USER") {
      customerId = currentUsr["belongs_to_customer"]["id"];
    } else {
      // customerId = args["customerI"]
    }
    Provider.of<AppConfigService>(context, listen: false)
        .getCustomerFutureOrders(customerId)
        .then((data) {
      setState(() {
        if (futureOrders.length != 0)
          title = onlyOrders ? "Orders List" : futureOrders[0]["customer_name"];
        futureOrders = data;
      });
    });
  }

  void getCustomerPastOrders(currentUsr) {
    var customerId;
    // if (args == null) {
    //   args = new Map();
    //   args["customerId"] = null;
    //   onlyOrders = true;
    // }
    if (currentUsr["role"] == "K_USER" &&
        currentUsr["belongs_to_customer"] != null) {
      customerId = currentUsr["belongs_to_customer"]["id"];
    } else {
      // customerId = args["customerI"]
    }
    Provider.of<AppConfigService>(context, listen: false)
        .getCustomerPastOrders(customerId)
        .then((data) {
      setState(() {
        pastOrders = data;
        if (pastOrders.length != 0)
          title = onlyOrders ? "Orders List" : pastOrders[0]["customer_name"];
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
          title: Text(title ?? ""),
        ),
        body: TabBarView(
          children: [
            buildListViewForOrders(futureOrders, true),
            buildListViewForOrders(pastOrders),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     result = await Navigator.pushNamed(context, "/forms",
        //         arguments: {"formType": "K_FORM_ORDERS"});
        //     setState(() {
        //       getCustomerPastOrders(_loginSrv.currentUser);

        //       getCustomerFutureOrders(_loginSrv.currentUser);
        //     });
        //   },
        //   tooltip: 'Add Orders',
        //   child: Icon(Icons.add),
        // ),
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
          leading: new Container(
            margin: const EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(8.0)),
            child: Text(
              "Qty: " + orders[index]['quantity'].toString(),
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          title: Text(orders[index]["belongs_to_customer"]["name"] ??
              orders[index]["belongs_to_customer"]["phone_no"]),
          subtitle: Text(DateFormat('dd-MMM-yyyy h:mm a')
              .format((orders[index]['dt_order_place']).toLocal())),
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
