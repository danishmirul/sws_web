import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sws_web/constants/size.dart';
import 'package:sws_web/models/wheelchair.dart';
import 'package:sws_web/pages/dashboard/statistic.dart';
import 'package:sws_web/pages/menu_options.dart';
import 'package:sws_web/routing/routes.dart';
import 'package:sws_web/services/firestore_path.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';
import 'package:sws_web/widgets/page_header.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.callback}) : super(key: key);
  final Function callback;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Wheelchair> _wheelchairs;
  int _available, _charging, _unavailable;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: Firestore.instance
          .collection(FirestorePath.wheelchairs())
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _wheelchairs = [];
          List snapshots = snapshot.data.documents.toList();
          snapshots.forEach((snapshot) {
            Wheelchair temp = Wheelchair.fromSnapShot(snapshot);
            _wheelchairs.add(temp);
          });

          _available = _wheelchairs.where((e) => e.status == 'A').length;
          _charging = _wheelchairs.where((e) => e.status == 'C').length;
          _unavailable = _wheelchairs.where((e) => e.status == 'U').length;
        }

        return SafeArea(
          child: Container(
            height: size.height,
            width: size.width - cNavbarWidth,
            child: snapshot.hasData
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PageHeader(text: 'Dashboard'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          StatisticCard(
                              title: 'Available',
                              subtitle:
                                  'Number of wheelchairs that available to be use currently.',
                              value: _available.toString(),
                              color1: Colors.green.shade700,
                              color2: Colors.green,
                              icon: Icons.power_input),
                          StatisticCard(
                            title: 'Charging',
                            subtitle:
                                'Number of wheelchair charging currently.',
                            value: _charging.toString(),
                            color1: Colors.orange.shade700,
                            color2: Colors.orange,
                            icon: Icons.charging_station,
                          ),
                          StatisticCard(
                            title: 'Unavailable',
                            subtitle:
                                'Number of wheelchair can not be use currently.',
                            value: _unavailable.toString(),
                            color1: Colors.red.shade700,
                            color2: Colors.red,
                            icon: Icons.power_off,
                          ),
                        ],
                      ),
                      // MainStatistic(),
                      Padding(
                        padding: const EdgeInsets.all(cDefaultPadding),
                        child: Container(
                          height: size.height * 0.5,
                          width: size.width - cNavbarWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff2c274c),
                                Color(0xff46426c),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: Center(
                            child: CustomText(
                              text: 'Wheelchairs Position View here.',
                              color: Colors.white,
                              size: 32.0,
                              weight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: cDefaultPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () => widget.callback(
                                  menuOptions.firstWhere((element) =>
                                      element.route == WHEELCHAIRS_ROUTE)),
                              child: Container(
                                height: 90,
                                width: size.width * 0.25,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.lightBlue.shade700,
                                      Colors.lightBlue,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.wheelchair_pickup,
                                      size: 48.0,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: cDefaultPadding),
                                    CustomText(
                                      text: 'Manage Wheelchairs',
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => widget.callback(
                                  menuOptions.firstWhere((element) =>
                                      element.route == STAFFS_ROUTE)),
                              child: Container(
                                height: 90,
                                width: size.width * 0.25,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.lightBlue.shade700,
                                      Colors.lightBlue,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.people,
                                      size: 48.0,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: cDefaultPadding),
                                    CustomText(
                                      text: 'Manage Users',
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Loading(),
          ),
        );
      },
    );
  }
}
