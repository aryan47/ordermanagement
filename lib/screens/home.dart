import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_management/service/appConfigService.dart';
import 'package:order_management/service/productsService.dart';
import 'package:order_management/service/utilService.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List products;
  var stateMachine;
  var dbSrv;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  Future initHome() async {
    dbSrv = Provider.of<AppConfigService>(context, listen: false);
    products = await ProductService().getProducts(dbSrv.db);
    stateMachine = dbSrv.config["STATE_MACHINE"]["products"];
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: initHome(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) {
                var currencyformat =
                    NumberFormat.simpleCurrency(locale: Platform.localeName);
                final _byteImage =
                    Base64Decoder().convert(products[index]["uri"]);
                return InkWell(
                  onTap: () async {
                    String route =
                        getV("actions.onTap.gotoRoute", stateMachine);
                    var arguments =
                        getV("actions.onTap.arguments", stateMachine);
                    var product = products[index];
                    arguments.addAll({"product": product});
                    await Navigator.pushNamed(context, route,
                        arguments: arguments);
                  },
                  child: Card(
                      child: Row(
                    children: [
                      Container(
                          padding: EdgeInsets.all(5.0),
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(_byteImage),
                                fit: BoxFit.fill),
                          )),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              products[index]["name"].toString().trim(),
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              products[index]["desc"].toString().trim(),
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                  text: currencyformat.currencySymbol + ' ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                      text: products[index]["price"]
                                          .toString()
                                          .trim(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ]),
                            ),
                            SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                  text: "Stock: ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  children: [getStock(index)]),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
                );

                ListTile(
                  leading: Image.memory(_byteImage),
                  title: Text('${products[index]["name"]}'),
                  subtitle: Text(products[index]["desc"]),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    String route =
                        getV("actions.onTap.gotoRoute", stateMachine);
                    var arguments =
                        getV("actions.onTap.arguments", stateMachine);
                    var product = products[index];
                    arguments.addAll({"product": product});
                    await Navigator.pushNamed(context, route,
                        arguments: arguments);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(height: 3, color: Colors.grey[400]);
              },
            );
          }
          return Container();
        });
  }

  dynamic getStock(int index) {
    var availableStock = int.parse(products[index]["stock"].toString().trim());
    if (availableStock > 30) {
      // return "Available";
      return TextSpan(
        text: "Available",
        style: TextStyle(
          color: Colors.green,
        ),
      );
    }
    // return availableStock.toString();
    return TextSpan(
      text: availableStock.toString() + " Left",
      style: TextStyle(
        color: Colors.red,
      ),
    );
  }
}
