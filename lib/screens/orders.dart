import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_management/service/appConfigService.dart';
import 'package:order_management/service/handlerService.dart';
import 'package:order_management/service/loginService.dart';
import 'package:order_management/widgets/dropdownbutton.dart';
import 'package:order_management/widgets/widgetUtils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Orders extends StatefulWidget {
  Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  var pastOrders = [];
  var futureOrders = [];

  Map? args;
  var src,
      result,
      _loginSrv,
      _appConfig,
      selectedOrderId,
      selectedProductAction;
  String? title;
  bool onlyOrders = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>?;
    _loginSrv = Provider.of<LoginService>(context, listen: false);

    // if (args == null) {
    //   args = new Map();
    //   args["customerId"] = null;
    //   onlyOrders = true;
    // }

    _appConfig = Provider.of<AppConfigService>(context, listen: false);

    // stateMachine = _appConfig.config["PRODUCT_ACTIONS"];

    // loadOrders();
  }

  void loadOrders() {
    getCustomerPastOrders(_loginSrv.currentUser);

    getCustomerFutureOrders(_loginSrv.currentUser);
  }

  Future getCustomerFutureOrders(currentUsr) {
    var customerId;
    if (currentUsr["role"] == "K_USER") {
      customerId = currentUsr["belongs_to_customer"]["id"];
    } else {
      // if comming from cutomer screen
      if (args != null) {
        customerId = args!["customer"].id.id.hexString;
        title = args!["customer"].name;
      }
    }
    return Provider.of<AppConfigService>(context, listen: false)
        .getCustomerFutureOrders(customerId);
    //     .then((data) {
    //   setState(() {
    //     if (futureOrders.length != 0)
    //       title = onlyOrders ? "Orders List" : futureOrders[0]["customer_name"];
    //     futureOrders = data;
    //   });
    // });
  }

  Future getCustomerPastOrders(currentUsr) {
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
      if (args != null) {
        customerId = args!["customer"].id.id.hexString;
        title = args!["customer"].name;
      }
    }
    return Provider.of<AppConfigService>(context, listen: false)
        .getCustomerPastOrders(customerId);
  }

  void onCustomDropdownTap(action, refData) async {
    selectedProductAction = action;
    var state, dtLastAction;
    switch (selectedProductAction) {
      case "K_ACTION_DELIVERED":
        state = "K_STATE_COMPLETE";
        dtLastAction = new DateTime.now();
        break;
      case "K_ACTION_CANCELLED":
        state = "K_STATE_CANCEL";
        dtLastAction = new DateTime.now();

        break;
      default:
        state = "NO_ACTION";
        dtLastAction = new DateTime.now();
    }
    await getHandler()[_appConfig.config["STATE_MACHINE"]["PRODUCT_ACTIONS"]
            ["actions"]["onTap"]["handler"]](
        _appConfig, action, state, dtLastAction, refData["_id"].id.hexString);
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
          title: Text(title ?? "Orders List"),
        ),
        body: TabBarView(
          children: [
            customLoader(
                future: getCustomerFutureOrders(_loginSrv.currentUser),
                builder: (data) {
                  futureOrders = data;
                  // if (futureOrders.length != 0)
                  //   title = onlyOrders
                  //       ? "Orders List"
                  //       : futureOrders[0]["customer_name"];

                  return buildListViewForOrders(futureOrders, true);
                }),
            customLoader(
                future: getCustomerPastOrders(_loginSrv.currentUser),
                builder: (data) {
                  pastOrders = data;
                  // if (pastOrders.length != 0)
                  // title = onlyOrders
                  //     ? "Orders List"
                  //     : pastOrders[0]["customer_name"];
                  return buildListViewForOrders(pastOrders);
                }),
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

  Widget buildListViewForOrders(orders, [bool? showMore]) {
    if (orders.length == 0) return Center(child: Text("No Item Found"));
    return ListView.separated(
      shrinkWrap: true,
      itemCount: orders.length,
      separatorBuilder: (context, index) => Divider(
        color: Colors.black,
      ),
      itemBuilder: (context, index) {
        return ListTile(
          isThreeLine: true,
          leading: new Container(
            margin: const EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
                borderRadius: BorderRadius.circular(8.0)),
            child: Text(
              "Qty: " + orders[index]['quantity'].toString(),
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          title: buildTitle(orders, index),
          subtitle: Text(DateFormat('dd-MMM-yyyy h:mm a')
              .format((orders[index]['dt_order_place']).toLocal())),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_loginSrv.currentUser["role"] == "K_ADMIN")
                IconButton(
                    color: Colors.green[700],
                    icon: Icon(Icons.call),
                    onPressed: () {
                      if (orders[index] != null &&
                          orders[index]["phone_no"] != null)
                        launch("tel:" + orders[index]["phone_no"]);
                    }),
              showMore == true
                  ? CustomDropdownButton(
                      data: _appConfig.config["PRODUCT_ACTIONS"],
                      refData: orders[index],
                      onCustomDropdownTap: onCustomDropdownTap)
                  : getProductStatus(orders, index),
            ],
          ),
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

  Widget getProductStatus(orders, int index) {
    var color;
    var status =
        _appConfig.config["PRODUCT_ACTIONS"][orders[index]["last_action"]];
    // print(status);
    switch (orders[index]["last_action"]) {
      case "K_ACTION_CREATE":
        color = Colors.orange;
        break;
      case "K_ACTION_DELIVERED":
        color = Colors.green;
        break;
      case "K_ACTION_CANCELLED":
        color = Colors.red;
        break;
      default:
        color = Colors.black;
    }
    if (status == null) return Text("");
    return Text(status, style: TextStyle(color: color));
  }

  Widget buildTitle(orders, int index) {
    if (_loginSrv.currentUser["role"] == "K_USER") {
      return Text(orders[index]["product"]["name"].toString().trim());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          orders[index]["product"]["name"].toString().trim(),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          "( " +
              (orders[index]["belongs_to_customer"]["name"] ??
                  orders[index]["belongs_to_customer"]["phone_no"]
                      .toString()
                      .trim()) +
              " )",
          style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
