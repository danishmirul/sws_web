import 'package:flutter/material.dart';
import 'package:sws_web/constants/color.dart';
import 'package:sws_web/routing/router.dart';
import 'package:sws_web/wrapper/wrapper.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(Application());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Wheelchair System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: cPrimaryColor,
        fontFamily: 'OpenSans',
      ),
      onGenerateRoute: generateRoute,
      home: Application(),
    );
  }
}
