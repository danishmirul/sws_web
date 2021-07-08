// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sws_web/constants.dart';
// import 'package:sws_web/controllers/location_controller.dart';
// import 'package:sws_web/controllers/message_controller.dart';
// import 'package:sws_web/controllers/user_controller.dart';
// import 'package:sws_web/models/location.dart';
// import 'package:sws_web/models/message.dart';
// import 'package:sws_web/models/user.dart';
// import 'package:sws_web/models/wheelchair.dart';
// import 'package:sws_web/responsive.dart';
// import 'package:sws_web/services/firestore_service.dart';
// import 'package:sws_web/widgets/loading.dart';

// class WheelchairLocation extends StatefulWidget {
//   WheelchairLocation({@required this.wheelchair, Key key}) : super(key: key);
//   final Wheelchair wheelchair;

//   @override
//   _ViewMessagesState createState() => _ViewMessagesState();
// }

// class _ViewMessagesState extends State<WheelchairLocation> {
//   int length = 10;
//   ScrollController scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     scrollController.addListener(_scrollListener);
//   }

//   @override
//   Widget build(BuildContext context) {
//     FirestoreService firestoreService =
//         Provider.of<FirestoreService>(context, listen: false);
//     LocationController locationController =
//         LocationController(firestoreService: firestoreService);

//     final Size _size = MediaQuery.of(context).size;

//     return AlertDialog(
//       backgroundColor: kBgColor,
//       title: new Text(
//         'Location Log Wheelchair ${widget.wheelchair.plate}',
//         style: TextStyle(
//             color: kSecondaryColor,
//             fontSize: Responsive.isDesktop(context) ? 24 : 16,
//             fontWeight: FontWeight.bold),
//       ),
//       content: Container(
//         height: _size.height * .9,
//         width: _size.width * (Responsive.isDesktop(context) ? 0.3 : 0.5),
//         // width: 222.0,
//         child: StreamBuilder(
//           stream: locationController
//               .wheelchairlocationStream(widget.wheelchair.uid, length: length),
//           builder: (context, snapshot) {
//             print('STREAM: $snapshot');
//             if (snapshot.hasData) {
//               List<Location> locations = [];
//               List snapshots = snapshot.data.documents.toList();
//               print('SNAPSHOTS: ${snapshots.length}');
//               snapshots.forEach((snapshot) {
//                 Location temp = Location.fromSnapShot(snapshot);
//                 locations.add(temp);
//                 // if (temp.wheelchairID == widget.wheelchair.uid)
//                 //   locations.add(temp);
//               });

//               final List<Row> chats = locations.map((_location) {
//                 return Row(
//                   children: <Widget>[
//                     Container(
//                       padding: EdgeInsets.all(12.0),
//                       margin:
//                           EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
//                       decoration: BoxDecoration(
//                           color: kPrimaryColor.shade200,
//                           borderRadius: BorderRadius.circular(7.0)),
//                       child: Column(
//                         children: [
//                           Text(
//                             '${_location.name}',
//                             style: TextStyle(
//                                 color: kSecondaryColor,
//                                 fontSize:
//                                     Responsive.isDesktop(context) ? 20 : 12),
//                           ),
//                           Text(
//                             'Time Stamp: ${_location.createdAt}',
//                             style: TextStyle(
//                                 color: kSecondaryColor.withOpacity(.7),
//                                 fontSize:
//                                     Responsive.isDesktop(context) ? 20 : 12),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                   mainAxisAlignment: MainAxisAlignment.start,
//                 );
//               }).toList();
//               return ListView.builder(
//                 controller: scrollController,
//                 itemCount: chats.length,
//                 itemBuilder: (context, index) {
//                   return chats[index];
//                 },
//               );
//             }
//             return Loading();
//           },
//         ),
//       ),
//     );
//   }

//   void _scrollListener() {
//     if (scrollController.offset >= scrollController.position.maxScrollExtent &&
//         !scrollController.position.outOfRange) {
//       print("at the end of list");
//       setState(() {
//         length += length;
//       });
//     }
//   }
// }
