import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants.dart';
import 'package:sws_web/controllers/menu_controller.dart';
import 'package:sws_web/routing/routes.dart';
import 'package:sws_web/services/firebase_auth_service.dart';
import 'package:sws_web/widgets/custom_text.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    @required this.route,
    Key key,
  }) : super(key: key);
  final String route;

  @override
  Widget build(BuildContext context) {
    final menuController = Provider.of<MenuController>(context, listen: true);
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/wheelchair-01.png'),
              fit: BoxFit.fitHeight),
        ),
        child: SingleChildScrollView(
          // it enables scrolling
          child: Column(
            children: [
              DrawerHeader(
                child: Image.asset("images/logo_white.png"),
              ),
              DrawerListTile(
                title: "Dashbord",
                imgSrc: "icons/squared_menu_96px.png",
                selected: menuController.verifyRoute(HOME_ROUTE, route),
                press: () {
                  Navigator.pushReplacementNamed(context, HOME_ROUTE);
                },
              ),
              DrawerListTile(
                title: "Wheelchairs",
                imgSrc: "icons/wheelchair_96px.png",
                selected: menuController.verifyRoute(WHEELCHAIRS_ROUTE, route),
                press: () {
                  Navigator.pushReplacementNamed(context, WHEELCHAIRS_ROUTE);
                },
              ),
              DrawerListTile(
                title: "Users",
                imgSrc: "icons/staff_96px.png",
                selected: menuController.verifyRoute(USERS_ROUTE, route),
                press: () {
                  Navigator.pushReplacementNamed(context, USERS_ROUTE);
                },
              ),
              DrawerListTile(
                title: "Location",
                imgSrc: "icons/place_marker_96px.png",
                selected: menuController.verifyRoute(LOCATION_ROUTE, route),
                press: () {
                  Navigator.pushReplacementNamed(context, LOCATION_ROUTE);
                },
              ),
              DrawerListTile(
                title: "Profile",
                imgSrc: "icons/person_96px.png",
                selected: menuController.verifyRoute(PROFILE_ROUTE, route),
                press: () {
                  Navigator.pushReplacementNamed(context, PROFILE_ROUTE);
                },
              ),
              DrawerListTile(
                color: Colors.red,
                title: "Sign Out",
                imgSrc: "icons/exit_sign_96px.png",
                press: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: kBgColor,
                        title: new CustomText(
                          text: 'You about to leave',
                          color: kSecondaryColor,
                          weight: FontWeight.bold,
                        ),
                        content: new CustomText(
                          text: 'Are you sure to sign out?',
                          color: kSecondaryColor,
                          weight: FontWeight.bold,
                        ),
                        actions: <Widget>[
                          new TextButton(
                            child: new CustomText(
                              text: 'Cancel',
                              color: Colors.red,
                              weight: FontWeight.bold,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          new TextButton(
                            child: new CustomText(
                              text: 'Confirm',
                              color: kSecondaryColor,
                              weight: FontWeight.bold,
                            ),
                            onPressed: () async {
                              try {
                                final auth = Provider.of<FirebaseAuthService>(
                                    context,
                                    listen: false);
                                await auth.signOut();
                              } catch (e) {
                                print('_signOut Catch: $e');
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key key,
    // For selecting those three line once press "Command+D"
    @required this.title,
    @required this.imgSrc,
    @required this.press,
    this.color = Colors.white,
    this.selected = false,
  }) : super(key: key);

  final String title, imgSrc;
  final Color color;
  final bool selected;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Image.asset(
        imgSrc,
        color: selected ? kSecondaryColor : color,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: selected ? kSecondaryColor : color),
      ),
      selectedTileColor: Colors.white,
      selected: selected,
    );
  }
}
