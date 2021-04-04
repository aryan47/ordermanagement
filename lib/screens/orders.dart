import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_management/service/appConfigService.dart';
import 'package:order_management/service/handlerService.dart';
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
  var src,
      result,
      _loginSrv,
      _appConfig,
      selectedOrderId,
      selectedProductAction;
  String title = "Orders List";
  bool onlyOrders = true;

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

    _appConfig = Provider.of<AppConfigService>(context, listen: false);

    // stateMachine = _appConfig.config["PRODUCT_ACTIONS"];

    loadOrders();
  }

  void loadOrders() {
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

  void onCustomDropdownTap(action, refData) async {
    selectedProductAction = action;
    var state;
    switch (selectedProductAction) {
      case "K_ACTION_DELIVERED":
        state = "K_STATE_COMPLETE";
        break;
      case "K_ACTION_CANCELLED":
        state = "K_STATE_CANCEL";
        break;
      default:
        state = "NO_ACTION";
    }
    await getHandler()[_appConfig.config["STATE_MACHINE"]["PRODUCT_ACTIONS"]
            ["actions"]["onTap"]
        ["handler"]](_appConfig, action, state, refData["_id"].id.hexString);
    setState(() {
      loadOrders();
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
          trailing: showMore == true
              ? CustomDropdownButton(
                  data: _appConfig.config["PRODUCT_ACTIONS"],
                  refData: orders[index],
                  onCustomDropdownTap: onCustomDropdownTap)
              : null,
          onTap: () {
            // print(orders[index]);
            // selectedOrderId = orders[index];

            // getHandler()[_appConfig.config["STATE_MACHINE"]["PRODUCT_ACTIONS"]
            //         ["actions"]["onTap"]
            //     ["handler"]](_appConfig, selectedProductState, selectedOrderId);
            // String route = srv.getV("actions.onTap.gotoRoute", stateMachine);
            // Navigator.pushNamed(context, route, arguments: {"customerId": custOrders[index].id});
          },
        );
      },
    );
  }
}
