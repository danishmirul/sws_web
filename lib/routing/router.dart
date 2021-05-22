import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/controllers/menu_controller.dart';
import 'package:sws_web/main.dart';
import 'package:sws_web/routing/routes.dart';
import 'package:sws_web/screens/main/main_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HOME_ROUTE:
    case WHEELCHAIRS_ROUTE:
    case USERS_ROUTE:
    case LOCATION_ROUTE:
    case PROFILE_ROUTE:
      return getPageRoute(MultiProvider(
        providers: [
          ChangeNotifierProvider<MenuController>(
            create: (_) => MenuController(),
          ),
        ],
        child: MainScreen(route: settings.name),
      ));
    default:
      return getPageRoute(MyApp());
  }
}

PageRoute getPageRoute(Widget _widget) {
  return MaterialPageRoute(
    builder: (context) => _widget,
  );
}
