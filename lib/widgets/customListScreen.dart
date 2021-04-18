// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class CustomListScreen extends StatefulWidget {
//   @override
//   _CustomListScreenState createState() => _CustomListScreenState();
// }

// class _CustomListScreenState extends State<CustomListScreen> {
//   @override
//   Widget build(BuildContext context) {
//      return Scaffold(
//       appBar: AppBar(
//         title: Text("Customers"),
//       ),
//       body: ListView.builder(
//         shrinkWrap: true,
//         itemCount: customers!.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '${customers![index].name}',
//                   style: TextStyle(fontSize: 15),
//                 ),
//                 Text(
//                     customers![index].address != null
//                         ? customers![index].address!["address"]
//                         : "",
//                     style: TextStyle(fontSize: 13))
//               ],
//             ),
//             subtitle: Container(
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       child: Text(
//                         "Details",
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: ElevatedButton(
//                       child: Text("Orders"),
//                       style: ElevatedButton.styleFrom(
//                         primary: Colors.red, // background
//                         onPrimary: Colors.white, // foreground
//                       ),
//                       onPressed: () {},
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             // trailing: Icon(Icons.keyboard_arrow_right),
//             onTap: () {
//               print(stateMachine);
//               String route = getV("actions.onTap.gotoRoute", stateMachine);
//               Navigator.pushNamed(context, route,
//                   arguments: {"customer": customers![index]});
//             },
//           );
//         },
//       ),
//     );
 
//   }
// }