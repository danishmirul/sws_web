import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/controllers/wheelchair_controller.dart';
import 'package:sws_web/models/wheelchair.dart';
import 'package:sws_web/screens/wheelchair/components/wheelchair_detail_card.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/loading.dart';

import '../../../constants.dart';
import '../../dashboard/components/chart.dart';

class WheelchairDetails extends StatelessWidget {
  const WheelchairDetails({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreService>(context, listen: false);
    final WheelchairController wheelchairController =
        WheelchairController(firestoreService: database);
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: FutureBuilder(
        future: wheelchairController.getWheelchairs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Wheelchair> wheelchairs = snapshot.data;

            //  Status
            double numAvailable = wheelchairs.fold(0, (previousValue, element) {
              if (element.status == 'A') {
                return previousValue + 1;
              }
              return previousValue;
            });
            double perAvailable =
                roundDouble((numAvailable / wheelchairs.length) * 100, 2);

            double numUnavailable =
                wheelchairs.fold(0, (previousValue, element) {
              if (element.status == 'U') {
                return previousValue + 1;
              }
              return previousValue;
            });
            double perUnavailable =
                roundDouble((numUnavailable / wheelchairs.length) * 100, 2);

            double numMaintenance =
                wheelchairs.fold(0, (previousValue, element) {
              if (element.status == 'M') {
                return previousValue + 1;
              }
              return previousValue;
            });
            double perMaintenance =
                roundDouble((numMaintenance / wheelchairs.length) * 100, 2);

            List<PieChartSectionData> dataStatus = [];
            double remaining = wheelchairs.length.toDouble();
            if (numAvailable > 0) {
              dataStatus.add(PieChartSectionData(
                color: kPrimaryColor,
                value: numAvailable,
                showTitle: false,
                radius: 25,
              ));
              remaining -= numAvailable;
            }
            if (numUnavailable > 0) {
              dataStatus.add(PieChartSectionData(
                color: Colors.amber,
                value: numUnavailable,
                showTitle: false,
                radius: 22,
              ));
              remaining -= numUnavailable;
            }
            if (numMaintenance > 0) {
              dataStatus.add(PieChartSectionData(
                color: Colors.deepOrange,
                value: numMaintenance,
                showTitle: false,
                radius: 19,
              ));
              remaining -= numMaintenance;
            }
            if (remaining > 0)
              dataStatus.add(PieChartSectionData(
                color: kPrimaryColor.withOpacity(0.1),
                value: remaining,
                showTitle: false,
                radius: 13,
              ));

            //  Battery
            double numBatteryHigh =
                wheelchairs.fold(0, (previousValue, element) {
              if (element.battery == 'HIGH') {
                return previousValue + 1;
              }
              return previousValue;
            });
            double perBatteryHigh =
                roundDouble((numBatteryHigh / wheelchairs.length) * 100, 2);
            double numBatteryLow =
                wheelchairs.fold(0, (previousValue, element) {
              if (element.battery == 'LOW') {
                return previousValue + 1;
              }
              return previousValue;
            });
            double perBatteryLow =
                roundDouble((numBatteryLow / wheelchairs.length) * 100, 2);

            List<PieChartSectionData> dataBattery = [];
            remaining = wheelchairs.length.toDouble();
            if (numBatteryHigh > 0) {
              dataBattery.add(PieChartSectionData(
                color: kPrimaryColor,
                value: numBatteryHigh,
                showTitle: false,
                radius: 25,
              ));
              remaining -= numBatteryHigh;
            }
            if (numBatteryLow > 0) {
              dataBattery.add(PieChartSectionData(
                color: Color(0xFFEE2727),
                value: numBatteryLow,
                showTitle: false,
                radius: 22,
              ));
              remaining -= numBatteryLow;
            }
            if (remaining > 0)
              dataBattery.add(PieChartSectionData(
                color: kPrimaryColor.withOpacity(0.1),
                value: remaining,
                showTitle: false,
                radius: 13,
              ));

            //  Accessibility
            double numAccessible =
                wheelchairs.fold(0, (previousValue, element) {
              if (element.accessible) {
                return previousValue + 1;
              }
              return previousValue;
            });
            double perAccessible =
                roundDouble((numAccessible / wheelchairs.length) * 100, 2);
            double numInaccessible =
                wheelchairs.fold(0, (previousValue, element) {
              if (!element.accessible) {
                return previousValue + 1;
              }
              return previousValue;
            });
            double perInaccessible =
                roundDouble((numInaccessible / wheelchairs.length) * 100, 2);

            List<PieChartSectionData> dataAccessibility = [];
            remaining = wheelchairs.length.toDouble();
            if (numAccessible > 0) {
              dataAccessibility.add(PieChartSectionData(
                color: kPrimaryColor,
                value: numAccessible,
                showTitle: false,
                radius: 25,
              ));
              remaining -= numAccessible;
            }
            if (numInaccessible > 0) {
              dataAccessibility.add(PieChartSectionData(
                color: Color(0xFFEE2727),
                value: numInaccessible,
                showTitle: false,
                radius: 22,
              ));
              remaining -= numInaccessible;
            }
            if (remaining > 0)
              dataAccessibility.add(PieChartSectionData(
                color: kPrimaryColor.withOpacity(0.1),
                value: remaining,
                showTitle: false,
                radius: 13,
              ));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Wheelchair Status",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: kDefaultPadding),
                    Chart(
                      data: dataStatus,
                      focusData: 'Available',
                      focusValue: perAvailable,
                    ),
                    WheelchairDetailCard(
                      imgSrc: "icons/ok_96px.png",
                      title: "Available",
                      percentage: perAvailable,
                      numOfWheelchairs: numAvailable,
                    ),
                    WheelchairDetailCard(
                      imgSrc: "icons/process_96px.png",
                      title: "In use",
                      percentage: perUnavailable,
                      numOfWheelchairs: numUnavailable,
                    ),
                    WheelchairDetailCard(
                      imgSrc: "icons/wrench_96px.png",
                      title: "Maintenance",
                      percentage: perMaintenance,
                      numOfWheelchairs: numMaintenance,
                    ),
                  ],
                ),
                SizedBox(height: kDefaultPadding),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Wheelchair Battery",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: kDefaultPadding),
                    Chart(
                      data: dataBattery,
                      focusData: 'High Battery',
                      focusValue: perBatteryHigh,
                    ),
                    WheelchairDetailCard(
                      imgSrc: "icons/full_battery_96px.png",
                      title: "Battery High",
                      percentage: perBatteryHigh,
                      numOfWheelchairs: numBatteryHigh,
                    ),
                    WheelchairDetailCard(
                      imgSrc: "icons/low_battery_96px.png",
                      title: "Battery Low",
                      percentage: perBatteryLow,
                      numOfWheelchairs: numBatteryLow,
                    ),
                  ],
                ),
                SizedBox(height: kDefaultPadding),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Wheelchair Accessibility",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: kDefaultPadding),
                    Chart(
                      data: dataAccessibility,
                      focusData: 'Accessible',
                      focusValue: perAccessible,
                    ),
                    WheelchairDetailCard(
                      imgSrc: "icons/access_96px.png",
                      title: "Accessible",
                      percentage: perAccessible,
                      numOfWheelchairs: numAccessible,
                    ),
                    WheelchairDetailCard(
                      imgSrc: "icons/unavailable_96px.png",
                      title: "Inaccessible",
                      percentage: perInaccessible,
                      numOfWheelchairs: numInaccessible,
                    ),
                  ],
                ),
              ],
            );
          }
          return Loading();
        },
      ),
    );
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
