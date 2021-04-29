import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants/size.dart';
import 'package:sws_web/models/message.dart';
import 'package:sws_web/models/staff.dart';
import 'package:sws_web/models/user.dart';
import 'package:sws_web/models/wheelchair.dart';
import 'package:sws_web/services/firestore_path.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';
import 'package:sws_web/widgets/page_header.dart';

class StaffDetail extends StatefulWidget {
  StaffDetail({Key key, this.uid}) : super(key: key);
  final String uid;

  @override
  _StaffDetailState createState() => _StaffDetailState();
}

class _StaffDetailState extends State<StaffDetail> {
  List<Message> _msgLogs = [];
  User _user;
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

    // _user = widget.uid;
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreService>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<User>(
      stream: database.userReferenceStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _user = snapshot.data;
          print('User snapshot: $snapshot');
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
                      Center(
                        child: Container(
                          height: size.height * 0.7,
                          width: (size.width * 0.5) - (cNavbarWidth * 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
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
                              CustomText(
                                text: 'Information',
                                size: 36.0,
                                weight: FontWeight.bold,
                              ),
                              _buildDisplayDataItem('UID', _user.uid),
                              _buildDisplayDataItem(
                                  'Full Name', _user.fullname),
                              _buildDisplayDataItem('Email', _user.email),
                              _buildDisplayDataItem('Phone', _user.phone),
                            ],
                          ),
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
