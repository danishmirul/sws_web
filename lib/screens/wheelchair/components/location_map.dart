import 'package:flutter/material.dart';
import 'package:sws_web/constants.dart';
import 'package:sws_web/responsive.dart';

class LocationMap extends StatefulWidget {
  LocationMap({Key key}) : super(key: key);

  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    double height = Responsive.isDesktop(context)
        ? 600
        : Responsive.isTablet(context)
            ? 400
            : 200;
    return Column(
      children: [
        SizedBox(height: kDefaultPadding),
        Stack(
          children: [
            Container(
              height: height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/floorplan.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: (height / 2) - 5,
              left: 20,
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: Colors.red),
                  ),
                  Text(
                    'R001',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
