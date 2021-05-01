import 'package:flutter/material.dart';
import 'package:order_management/models/customersModel.dart';
import 'package:order_management/controllers/appConfigService.dart';
import 'package:order_management/controllers/utilService.dart';
import 'package:provider/provider.dart';

class Customers extends StatefulWidget {
  Customers({Key? key}) : super(key: key);

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  late var srv;
  List<CustomersM>? customers = [];
  var stateMachine;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<AppConfigService>(context).listLoaded.stream.listen((event) {
      if (event) {
        setState(() {
          customers = srv.getCustomers();
          stateMachine = srv.config["STATE_MACHINE"]["customers"];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    srv = Provider.of<AppConfigService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Customers"),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: customers!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${customers![index].name}',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                    customers![index].address != null
                        ? customers![index].address!["address"]
                        : "",
                    style: TextStyle(fontSize: 13))
              ],
            ),
            // subtitle: Container(
            //   child: Row(
            //     children: <Widget>[
            //       Expanded(
            //         child: ElevatedButton(
            //           onPressed: () {},
            //           child: Text(
            //             "Details",
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         child: ElevatedButton(
            //           child: Text("Orders"),
            //           style: ElevatedButton.styleFrom(
            //             primary: Colors.red, // background
            //             onPrimary: Colors.white, // foreground
            //           ),
            //           onPressed: () {},
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            // trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print(stateMachine);
              String route = getV("actions.onTap.gotoRoute", stateMachine);
              Navigator.pushNamed(context, route,
                  arguments: {"customer": customers![index]});
            },
          );
        },
      ),
    );
  }
}
