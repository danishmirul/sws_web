import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants.dart';
import 'package:sws_web/routing/router.dart';
import 'package:sws_web/services/firebase_auth_service.dart';
import './auth_widget.dart';
import './auth_widget_builder.dart';

class Auth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(),
        ),
      ],
      child: AuthWidgetBuilder(builder: (context, userSnapshot) {
        return MaterialApp(
          title: 'Smart Wheelchair System',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: kBgColor,
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
                .apply(bodyColor: Colors.white),
            canvasColor: kSecondaryColor,
          ),
          onGenerateRoute: generateRoute,
          home: AuthWidget(userSnapshot: userSnapshot),
        );
      }),
    );
  }
}
