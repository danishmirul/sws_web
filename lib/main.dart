import 'package:flutter/material.dart';
import 'package:sws_web/constants.dart';
import 'package:sws_web/routing/router.dart';
import 'package:sws_web/screens/auth/components/auth.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(Auth());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Wheelchair System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        fontFamily: 'OpenSans',
      ),
      onGenerateRoute: generateRoute,
      home: Auth(),
    );
  }
}
