import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/controllers/wheelchair_controller.dart';
import 'package:sws_web/models/wheelchair.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/routing/routes.dart';
import 'package:sws_web/screens/message/view_messages.dart';
import 'package:sws_web/screens/wheelchair/components/update_wheelchair_form.dart';
import 'package:sws_web/screens/wheelchair/components/view_wheelchair_information.dart';
import 'package:sws_web/screens/wheelchair/components/wheelchair_location.dart';
import 'package:sws_web/screens/wheelchair/components/wheelchair_navigation.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/loading.dart';
import 'package:sws_web/widgets/progress_line.dart';

import '../../../constants.dart';

class WheelchairList extends StatefulWidget {
  WheelchairList({@required this.route, Key key}) : super(key: key);
  final String route;

  @override
  _WheelchairListState createState() => _WheelchairListState();
}

class _WheelchairListState extends State<WheelchairList> {
  FirestoreService firestoreService;
  WheelchairController wheelchairController;

  List<Wheelchair> wheelchairs = [];
  bool next = true;

  @override
  void initState() {
    super.initState();

    firestoreService = Provider.of<FirestoreService>(context, listen: false);
    wheelchairController =
        WheelchairController(firestoreService: firestoreService);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All Wheelchairs",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          FutureBuilder<List<Wheelchair>>(
            future: wheelchairController.getPaginatedWheelchair(next: next),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  wheelchairs = snapshot.data;
                }
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: DataTable(
                        horizontalMargin: 0,
                        columnSpacing: kDefaultPadding,
                        columns: [
                          DataColumn(
                            label: Text(
                              "Plate Name",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      Responsive.isDesktop(context) ? 16 : 8),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Device Name",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      Responsive.isDesktop(context) ? 16 : 8),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Battery",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      Responsive.isDesktop(context) ? 16 : 8),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Status",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      Responsive.isDesktop(context) ? 16 : 8),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Accessibility",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      Responsive.isDesktop(context) ? 16 : 8),
                            ),
                          ),
                          DataColumn(
                            label: Text(""),
                          ),
                        ],
                        rows: List.generate(
                          wheelchairs.length,
                          (index) => wheelchairRow(
                              context, wheelchairs[index], widget.route),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              setState(() => next = false);
                            }),
                        IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              setState(() => next = true);
                            })
                      ],
                    ),
                  ],
                );
              }
              return Loading();
            },
          ),
        ],
      ),
    );
  }
}

DataRow wheelchairRow(BuildContext context, Wheelchair data, String route) {
  final database = Provider.of<FirestoreService>(context, listen: false);
  final WheelchairController wheelchairController =
      WheelchairController(firestoreService: database);

  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Image.asset(
              'icons/wheelchair_96px.png',
              height: Responsive.isDesktop(context) ? 30 : 15,
              width: Responsive.isDesktop(context) ? 30 : 15,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text(
                data.plate,
                style:
                    TextStyle(fontSize: Responsive.isDesktop(context) ? 16 : 8),
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(
        data.name,
        style: TextStyle(fontSize: Responsive.isDesktop(context) ? 16 : 8),
      )),
      DataCell(
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(Responsive.isDesktop(context)
                  ? kDefaultPadding * 0.75
                  : kDefaultPadding * 0.25),
              width: Responsive.isDesktop(context) ? 40 : 20,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ProgressLine(
                color: data.battery == 'HIGH' ? Colors.green : Colors.red,
                percentage: data.battery == 'HIGH' ? 100 : 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text(
                data.battery,
                style:
                    TextStyle(fontSize: Responsive.isDesktop(context) ? 16 : 8),
              ),
            ),
          ],
        ),
      ),
      DataCell(
        Text(
          wheelchairController.getStatusString(data.status),
          style: TextStyle(
            color: wheelchairController.getStatusColor(data.status),
            fontSize: Responsive.isDesktop(context) ? 16 : 8,
          ),
        ),
      ),
      DataCell(
        Text(
          wheelchairController.getAccessibilityString(data.accessible),
          style: TextStyle(
            color: data.accessible ? Colors.green : Colors.red,
            fontSize: Responsive.isDesktop(context) ? 16 : 8,
          ),
        ),
      ),
      DataCell(
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                size: Responsive.isDesktop(context) ? 16 : 8,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ViewWheelchairInformation(data: data);
                  },
                );
              },
            ),
            SizedBox(width: Responsive.isDesktop(context) ? 16 : 8),
            IconButton(
              icon: Icon(
                Icons.edit,
                size: Responsive.isDesktop(context) ? 16 : 8,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UpdateWheelchairForm(data: data, route: route);
                  },
                );
              },
            ),
            SizedBox(width: Responsive.isDesktop(context) ? 16 : 8),
            IconButton(
              icon: Icon(
                Icons.receipt_long,
                size: Responsive.isDesktop(context) ? 16 : 8,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ViewMessages(wheelchair: data);
                  },
                );
              },
            ),
            SizedBox(width: Responsive.isDesktop(context) ? 16 : 8),
            IconButton(
              icon: Icon(
                Icons.place,
                size: Responsive.isDesktop(context) ? 16 : 8,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return WheelchairLocation(wheelchair: data);
                  },
                );
              },
            ),
            SizedBox(width: Responsive.isDesktop(context) ? 16 : 8),
            IconButton(
              icon: Icon(
                Icons.control_camera,
                size: Responsive.isDesktop(context) ? 16 : 8,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return WheelchairNavigation(wheelchair: data, route: route);
                  },
                );
              },
            ),
          ],
        ),
      ),
    ],
  );
}
