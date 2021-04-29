import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants/size.dart';
import 'package:sws_web/models/message.dart';
import 'package:sws_web/models/wheelchair.dart';
import 'package:sws_web/services/firestore_path.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';
import 'package:sws_web/widgets/page_header.dart';

class WheelchairDetail extends StatefulWidget {
  WheelchairDetail({Key key, this.uid}) : super(key: key);
  final String uid;

  @override
  _WheelchairDetailState createState() => _WheelchairDetailState();
}

class _WheelchairDetailState extends State<WheelchairDetail> {
  List<Message> _msgLogs = [];
  Wheelchair _wheelchair;
  bool _displayInfo = true;

  _buildDisplayDataItem(String label, String data) => Container(
        height: 50,
        width: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
            colors: [
              Colors.lightBlue,
              Colors.lightBlue.shade700,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300], offset: Offset(0, 3), blurRadius: 16)
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: cDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                text: label,
                size: 28.0,
                color: Colors.white,
                weight: FontWeight.bold,
              ),
              CustomText(
                text: data,
                size: 18.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
      );

  _buildStatusItem(String data) => Container(
        height: 50,
        width: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
            colors: data == 'A'
                ? [Colors.green.shade700, Colors.green]
                : data == 'C'
                    ? [Colors.orange.shade700, Colors.orange]
                    : [Colors.red.shade700, Colors.red],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300], offset: Offset(0, 3), blurRadius: 16)
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: cDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                text: 'Status',
                size: 28.0,
                color: Colors.white,
                weight: FontWeight.bold,
              ),
              CustomText(
                text: data == 'A'
                    ? 'Available'
                    : data == 'C'
                        ? 'Charging'
                        : 'Unavailable',
                size: 18.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
      );

  _buildBatteryItem(String param) => Container(
        height: 50,
        width: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
            colors: param == 'HIGH'
                ? [Colors.green.shade700, Colors.green]
                : [Colors.red.shade700, Colors.red],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300], offset: Offset(0, 3), blurRadius: 16)
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: cDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                text: 'Battery',
                size: 28.0,
                color: Colors.white,
                weight: FontWeight.bold,
              ),
              CustomText(
                text: '$param',
                size: 18.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
      );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _wheelchair = widget.uid;
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreService>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<Wheelchair>(
      stream: database.wheelchairReferenceStream(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _wheelchair = snapshot.data;
          print('Wheelchairs snapshot: $snapshot');
        }

        return SafeArea(
          child: Container(
            height: size.height,
            width: size.width - cNavbarWidth,
            child: snapshot.hasData
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PageHeader(text: 'Wheelchair Details'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: size.height * 0.7,
                            width: (size.width * 0.5) - (cNavbarWidth * 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff2c274c),
                                  Color(0xff46426c),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[300],
                                    offset: Offset(0, 3),
                                    blurRadius: 16)
                              ],
                            ),
                            child: TextButton(
                                onPressed: null,
                                child: CustomText(text: 'Navigate Wheelchair')),
                          ),
                          Container(
                            height: size.height * 0.7,
                            width: (size.width * 0.5) - (cNavbarWidth * 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[300],
                                    offset: Offset(0, 3),
                                    blurRadius: 16)
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Spacer(),
                                    CustomText(
                                      text: 'Information',
                                      size: 36.0,
                                      weight: FontWeight.bold,
                                    ),
                                    Spacer(),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _displayInfo = !_displayInfo;
                                          });
                                        },
                                        child: CustomText(
                                            text: _displayInfo
                                                ? 'Movement Log'
                                                : 'Wheelchair Information')),
                                    Spacer(),
                                  ],
                                ),
                                _displayInfo
                                    ? _buildDisplayDataItem(
                                        'UID', _wheelchair.uid)
                                    : Container(),
                                _displayInfo
                                    ? _buildDisplayDataItem(
                                        'Name', _wheelchair.name)
                                    : Container(),
                                _displayInfo
                                    ? _buildDisplayDataItem(
                                        'Address', _wheelchair.address)
                                    : Container(),
                                _displayInfo
                                    ? _buildDisplayDataItem(
                                        'Plate', _wheelchair.plate)
                                    : Container(),
                                _displayInfo
                                    ? _buildStatusItem(_wheelchair.status)
                                    : Container(),
                                _displayInfo
                                    ? _buildBatteryItem(_wheelchair.battery)
                                    : Container(),
                                !_displayInfo
                                    ? Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: cDefaultPadding),
                                        height: size.height * 0.6,
                                        child: StreamBuilder(
                                          stream: Firestore.instance
                                              .collection(
                                                  FirestorePath.msgLogs())
                                              .orderBy('createdAt',
                                                  descending: true)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              _msgLogs = [];
                                              List snapshots = snapshot
                                                  .data.documents
                                                  .toList();
                                              snapshots.forEach((snapshot) {
                                                Message temp =
                                                    Message.fromSnapShot(
                                                        snapshot);
                                                _msgLogs.add(temp);
                                              });
                                            }

                                            return snapshot.hasData
                                                ? ListView.builder(
                                                    itemCount: _msgLogs.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      Message msg =
                                                          _msgLogs[index];
                                                      return Padding(
                                                        padding: const EdgeInsets
                                                                .all(
                                                            cDefaultPadding),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                            .grey[
                                                                        300],
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            3),
                                                                    blurRadius:
                                                                        16)
                                                              ],
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8)),
                                                              color: msg.whom ==
                                                                      0
                                                                  ? Colors
                                                                      .lightGreen
                                                                  : Colors
                                                                      .lightBlue),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                  'UID: ${msg.uid}'),
                                                              Text(msg.whom == 0
                                                                  ? 'Source: Client'
                                                                  : 'Source: Wheelchair'),
                                                              Text(
                                                                  'Time Stamp: ${msg.createdAt}'),
                                                              Text(
                                                                  'Type: ${msg.label}'),
                                                              Text(
                                                                  'Text: ${msg.text}'),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : Loading();
                                          },
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
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
