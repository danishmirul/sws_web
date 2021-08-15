import 'package:flutter/material.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/routing/routes.dart';
import 'package:sws_web/screens/dashboard/components/header.dart';

import '../../constants.dart';
import 'components/available_hotlines.dart';
import 'components/user_list.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            Header(title: 'Users Management'),
            SizedBox(height: kDefaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      //  User
                      AvailableHotlines(route: USERS_ROUTE),
                      SizedBox(height: kDefaultPadding),
                      UserList(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: kDefaultPadding),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
