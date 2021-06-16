import 'package:flutter/material.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/routing/routes.dart';
import 'package:sws_web/screens/wheelchair/components/notified_wheelchairs.dart';

import '../../constants.dart';
import 'components/header.dart';
import '../wheelchair/components/wheelchair_list.dart';
import '../wheelchair/components/available_wheelchairs.dart';
import '../wheelchair/components/wheelchair_details.dart';
import '../user/components/available_hotlines.dart';
import '../user/components/user_list.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            Header(title: 'Dashboard'),
            SizedBox(height: kDefaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      //  Wheelchair
                      AvailableWheelchairs(),
                      // NotifiedWheelchairs(),
                      SizedBox(height: kDefaultPadding),
                      WheelchairList(route: HOME_ROUTE),
                      if (Responsive.isMobile(context))
                        SizedBox(height: kDefaultPadding),
                      if (Responsive.isMobile(context)) WheelchairDetails(),

                      SizedBox(height: kDefaultPadding * 2),
                      //  User
                      AvailableHotlines(),
                      SizedBox(height: kDefaultPadding),
                      UserList(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: kDefaultPadding),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: kDefaultPadding),
                // On Mobile means if the screen is less than 850 we dont want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: WheelchairDetails(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
