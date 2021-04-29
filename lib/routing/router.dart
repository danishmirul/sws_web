import 'package:flutter/material.dart';
import 'package:sws_web/main.dart';
import 'package:sws_web/pages/home_screen.dart';
import 'package:sws_web/pages/menu_options.dart';
import 'package:sws_web/pages/signin/sign_in_screen.dart';
import 'package:sws_web/routing/routes.dart';
import 'package:sws_web/wrapper/wrapper.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HOME_ROUTE:
      return getPageRoute(Application());
    case SIGN_IN_ROUTE:
      return getPageRoute(SignInScreen());
    // return getPageRoute(HomeScreen(menuOption: menuOptions[1]));
    case DASHBOARD_ROUTE:
      return getPageRoute(HomeScreen(menuOption: menuOptions[1]));
    default:
      return getPageRoute(MyApp());
  }
}

PageRoute getPageRoute(Widget _widget) {
  return MaterialPageRoute(
    builder: (context) => _widget,
  );
}
