import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/controllers/menu_controller.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/routing/routes.dart';
import 'package:sws_web/screens/dashboard/dashboard_screen.dart';
import 'package:sws_web/screens/location/location_screen.dart';
import 'package:sws_web/screens/profile/profile_screen.dart';
import 'package:sws_web/screens/user/user_screen.dart';
import 'package:sws_web/screens/wheelchair/wheelchair_screen.dart';

import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  MainScreen({@required this.route, Key key}) : super(key: key);
  final String route;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (widget.route) {
      case HOME_ROUTE:
        content = DashboardScreen();
        break;
      case WHEELCHAIRS_ROUTE:
        content = WheelchairScreen();
        break;
      case USERS_ROUTE:
        content = UserScreen();
        break;
      case LOCATION_ROUTE:
        content = LocationScreen();
        break;
      case PROFILE_ROUTE:
        content = ProfileScreen();
        break;
      default:
        content = DashboardScreen();
    }
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(route: widget.route),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(route: widget.route),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}
