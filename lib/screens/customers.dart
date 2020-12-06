import 'package:flutter/material.dart';
import 'package:order_management/screens/models/customersModel.dart';
import 'package:order_management/service/mainService.dart';

class Customers extends StatefulWidget {
  Customers({Key key}) : super(key: key);

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  var srv;
  List<CustomersM> customers = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    MyInheritedWidget.of(context).listLoaded.stream.listen((event) {
      if (event) {
        setState(() {
          customers = srv.getCustomers();
        });
        print(customers.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    srv = MyInheritedWidget.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Customer"),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: customers.length,
        itemBuilder: (context, index) {
          print("loading" + index.toString());
          return ListTile(
            title: Text('${customers[index].customer_name}'),
          );
        },
      ),
    );
  }
}
