import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants/color.dart';
import 'package:sws_web/routing/router.dart';
import 'package:sws_web/services/firebase_auth_service.dart';
import 'package:sws_web/wrapper/auth_widget.dart';
import 'package:sws_web/wrapper/auth_widget_builder.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(),
        ),
        // Provider<ImagePickerService>(
        //   create: (_) => ImagePickerService(),
        // ),
      ],
      child: AuthWidgetBuilder(builder: (context, userSnapshot) {
        return MaterialApp(
          title: 'Smart Wheelchair System',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: cPrimaryColor,
            fontFamily: 'OpenSans',
          ),
          onGenerateRoute: generateRoute,
          home: AuthWidget(userSnapshot: userSnapshot),
        );
      }),
    );
  }
}
