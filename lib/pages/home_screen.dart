import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/models/user.dart';
import 'package:sws_web/pages/dashboard/dashboard.dart';
import 'package:sws_web/pages/menu_options.dart';
import 'package:sws_web/pages/staff/staff_list.dart';
import 'package:sws_web/pages/wheelchair/wheelchair_list.dart';
import 'package:sws_web/routing/routes.dart';
import 'package:sws_web/services/firebase_auth_service.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/loading.dart';
import 'package:sws_web/widgets/nav_bar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.menuOption}) : super(key: key);
  final MenuOption menuOption;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User currentUser;
  Widget _currentWidget = Container();
  MenuOption _currentMenuOption;

  List<MenuOption> _options;
  BuildContext _context;

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print('_signOut Catch: $e');
    }
  }

  switchScreen(MenuOption param) {
    if (param.route == LOG_OUT_ROUTE) {
      _signOut(_context);
    } else if (param.route == WHEELCHAIRS_ROUTE) {
      MenuOption _option = MenuOption(
        title: 'Wheelchairs',
        icon: Icons.wheelchair_pickup_outlined,
        route: WHEELCHAIRS_ROUTE,
        widget: WheelchairList(callback: setChildScreen),
      );

      setState(() {
        _currentMenuOption = _option;
        _currentWidget = _option.widget;
      });
    } else if (param.route == STAFFS_ROUTE) {
      MenuOption _option = MenuOption(
        title: 'Staffs',
        icon: Icons.people,
        route: STAFFS_ROUTE,
        widget: StaffList(callback: setChildScreen),
      );

      setState(() {
        _currentMenuOption = _option;
        _currentWidget = _option.widget;
      });
    } else {
      setState(() {
        _currentMenuOption = param;
        _currentWidget = param.widget;
      });
    }
  }

  setChildScreen(Widget widget) {
    setState(() {
      _currentWidget = widget;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      this._options = [...menuOptions];

      this._options[0] = MenuOption(
        title: 'Dashboard',
        icon: Icons.dashboard,
        route: DASHBOARD_ROUTE,
        widget: Dashboard(callback: switchScreen),
      );

      _currentMenuOption = this._options[0];
      _currentWidget = this._options[0].widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreService>(context, listen: false);
    this._context = context;

    return StreamBuilder<User>(
      stream: database.userReferenceStream(),
      builder: (context, snapshot) {
        currentUser = snapshot.data;

        if (snapshot.hasData) {
          return Scaffold(
            body: Row(
              children: [
                Navbar(
                  options: _options,
                  currentRoute: _currentMenuOption.route,
                  callback: switchScreen,
                ),
                _currentWidget,
              ],
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
