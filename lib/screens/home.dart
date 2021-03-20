import 'dart:convert';

import 'package:flutter/material.dart';
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
                final _byteImage =
                    Base64Decoder().convert(products[index]["uri"]);
                return ListTile(
                  leading: Image.memory(_byteImage),
                  title: Text('${products[index]["name"]}'),
                  subtitle: Text(products[index]["desc"]),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    String route =
                        getV("actions.onTap.gotoRoute", stateMachine);
                    dynamic arguments =
                        getV("actions.onTap.arguments", stateMachine);

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
}
