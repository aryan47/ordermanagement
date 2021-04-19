import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:order_management/constants.dart';
import 'package:order_management/service/appConfigService.dart';
import 'package:order_management/service/utilService.dart';
import 'package:provider/provider.dart';

class CustomListScreen extends StatefulWidget {
  final String customListType;
  CustomListScreen(this.customListType);

  @override
  _CustomListScreenState createState() => _CustomListScreenState();
}

class _CustomListScreenState extends State<CustomListScreen> {
  var srv, stateMachine;
  List data = [];
  late Map<String, dynamic> customList;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    srv = Provider.of<AppConfigService>(context, listen: false);
    customList = srv.config["CUSTOM_LIST"][widget.customListType];
    Provider.of<AppConfigService>(context).listLoaded.stream.listen((event) {
      if (event) {
        setState(() {
          data = srv.toMap()[customList["dataInitHandler"]]();
          stateMachine = srv.config["STATE_MACHINE"]["customers"];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(customList["title"]),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.grey[100],
            margin: EdgeInsets.all(5),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                          text: "Name: ",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: '${data[index].name}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            )
                          ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                          text: "Address: ",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: data[index].address != null
                                  ? data[index].address!["address"]
                                  : "",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            )
                          ]),
                    ),
                  ),
                ],
              ),
              subtitle: buildActions(data[index]),
              // trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                print(stateMachine);
                String route = getV("actions.onTap.gotoRoute", stateMachine);
                Navigator.pushNamed(context, route,
                    arguments: {"customer": data[index]});
              },
            ),
          );
        },
      ),
    );
  }

  Container buildActions(param) {
    // create actionWidgets
    List<Widget> actionWidgets = [];
    if (customList["actions"]?.keys.length != 0) {
      customList["actions"].forEach((k, v) {
        actionWidgets.add(Expanded(
          child: ElevatedButton(
            onPressed: () {
              print(stateMachine);
              String route = getV("actions.onTap.gotoRoute", stateMachine);
              Navigator.pushNamed(context, route,
                  arguments: {"customer": param});
            },
            child: Text(
              v["label"],
            ),
            style: ElevatedButton.styleFrom(
              primary: getConstants()[v["color"]],
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.all(Radius.zero),
              ),
            ),
          ),
        ));
      });
      return Container(
        child: Row(
          children: actionWidgets,
        ),
      );
    }
    return Container();
  }
}
