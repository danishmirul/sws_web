import 'package:flutter/material.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/routing/routes.dart';
import 'package:sws_web/screens/dashboard/components/header.dart';
import 'package:sws_web/screens/wheelchair/components/live_camera.dart';
import 'package:web_socket_channel/html.dart';

import '../../constants.dart';
import 'components/wheelchair_list.dart';
import 'components/available_wheelchairs.dart';
import 'components/wheelchair_details.dart';

class WheelchairScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            Header(title: 'Wheelchairs Management'),
            SizedBox(height: kDefaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(kDefaultPadding * 0.75),
                        width: double.infinity,
                        child: LiveCamera(
                          channel: HtmlWebSocketChannel.connect(
                              Uri.parse(IP_ADDRESS)),
                          position: true,
                        ),
                      ),
                      //  Wheelchair
                      // LocationMap(),
                      AvailableWheelchairs(route: WHEELCHAIRS_ROUTE),
                      // NotifiedWheelchairs(),
                      SizedBox(height: kDefaultPadding),
                      WheelchairList(route: WHEELCHAIRS_ROUTE),
                      if (Responsive.isMobile(context))
                        SizedBox(height: kDefaultPadding),
                      if (Responsive.isMobile(context)) WheelchairDetails(),
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
