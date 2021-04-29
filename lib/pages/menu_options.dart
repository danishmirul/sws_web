import 'package:flutter/material.dart';
import 'package:sws_web/pages/dashboard/dashboard.dart';
import 'package:sws_web/pages/staff/staff_list.dart';
import 'package:sws_web/pages/wheelchair/wheelchair_list.dart';
import 'package:sws_web/routing/routes.dart';

class MenuOption {
  MenuOption({this.icon, this.title, this.route, this.widget});
  final String title;
  final IconData icon;
  final String route;
  final Widget widget;
}

List<MenuOption> menuOptions = [
  MenuOption(
    title: 'Dashboard',
    icon: Icons.dashboard,
    route: DASHBOARD_ROUTE,
    widget: Dashboard(),
  ),
  MenuOption(
    title: 'Wheelchairs',
    icon: Icons.wheelchair_pickup_outlined,
    route: WHEELCHAIRS_ROUTE,
    widget: WheelchairList(),
  ),
  MenuOption(
    title: 'Staffs',
    icon: Icons.people,
    route: STAFFS_ROUTE,
    widget: StaffList(),
  ),
  // MenuOption(
  //   title: 'Settings',
  //   icon: Icons.settings,
  //   route: SETTINGS_ROUTE,
  //   widget: Dashboard(),
  // ),
  // MenuOption(
  //   title: 'Support',
  //   icon: Icons.support_agent,
  //   route: SUPPORT_ROUTE,
  //   widget: Dashboard(),
  // ),
  MenuOption(
    title: 'Sign Out',
    icon: Icons.exit_to_app,
    route: LOG_OUT_ROUTE,
    widget: Dashboard(),
  ),
];
