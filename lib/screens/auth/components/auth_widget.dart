import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/controllers/menu_controller.dart';
import 'package:sws_web/models/user.dart';
import 'package:sws_web/routing/routes.dart';
import 'package:sws_web/screens/auth/signin_screen.dart';
import 'package:sws_web/screens/main/main_screen.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';

/// Builds the signed-in or non signed-in UI, depending on the user snapshot.
/// This widget should be below the [MaterialApp].
/// An [AuthWidgetBuilder] ancestor is required for this widget to work.
class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active ||
        userSnapshot.connectionState == ConnectionState.done) {
      return userSnapshot.hasData
          ? MultiProvider(
              providers: [
                ChangeNotifierProvider<MenuController>(
                  create: (_) => MenuController(),
                ),
              ],
              child: MainScreen(route: HOME_ROUTE),
            )
          : SigninScreen();
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Loading(),
          CustomText(text: 'If the loading is too long, refresh the page.'),
        ],
      ),
    );
  }
}
