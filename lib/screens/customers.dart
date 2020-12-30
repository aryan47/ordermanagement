import 'package:flutter/material.dart';
import 'package:order_management/screens/models/customersModel.dart';
import 'package:order_management/service/DBService.dart';
import 'package:provider/provider.dart';

class Customers extends StatefulWidget {
  Customers({Key key}) : super(key: key);

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  var srv;
  List<CustomersM> customers = [];
  var stateMachine;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Provider.of<DBService>(context).listLoaded.stream.listen((event) {
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
    srv = Provider.of<DBService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Customers"),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: customers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${customers[index].name}'),
            subtitle: Text(customers[index].address),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print(stateMachine);
              String route = srv.getV("actions.onTap.gotoRoute", stateMachine);
              Navigator.pushNamed(context, route,
                  arguments: {"customerId": customers[index].id});
            },
          );
        },
      ),
    );
  }
}
