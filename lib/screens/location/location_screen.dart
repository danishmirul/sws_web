import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/controllers/location_controller.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/screens/dashboard/components/header.dart';
import 'package:sws_web/services/firestore_service.dart';

import '../../constants.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({Key key}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService =
        Provider.of<FirestoreService>(context, listen: false);
    LocationController locationController =
        LocationController(firestoreService: firestoreService);

    final Size _size = MediaQuery.of(context).size;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(kDefaultPadding),
        // child: StreamBuilder(
        //   stream: locationController.getCurrentUser(),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       User data = snapshot.data;
        //       return Column(
        //         children: [
        //           Header(title: 'Profile'),
        //           SizedBox(height: kDefaultPadding),
        //           Row(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Expanded(
        //                 flex: 5,
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: [
        //                         Container(
        //                           padding:
        //                               EdgeInsets.all(kDefaultPadding * 0.75),
        //                           height:
        //                               Responsive.isDesktop(context) ? 80 : 40,
        //                           width:
        //                               Responsive.isDesktop(context) ? 80 : 40,
        //                           decoration: BoxDecoration(
        //                             color: kSecondaryColor.withOpacity(0.1),
        //                             borderRadius: const BorderRadius.all(
        //                                 Radius.circular(10)),
        //                           ),
        //                           child: Image.asset(
        //                             'images/profile_pic.png',
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                     Text(
        //                       data.fullname,
        //                       maxLines: 2,
        //                       overflow: TextOverflow.ellipsis,
        //                       style: TextStyle(
        //                           color: kSecondaryColor,
        //                           fontSize:
        //                               Responsive.isDesktop(context) ? 32 : 16),
        //                     ),
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: [
        //                         Text(
        //                           "Email",
        //                           style: TextStyle(
        //                               color: kSecondaryColor,
        //                               fontSize: Responsive.isDesktop(context)
        //                                   ? 32
        //                                   : 16),
        //                         ),
        //                         Text(
        //                           "${data.email}",
        //                           maxLines: 2,
        //                           overflow: TextOverflow.ellipsis,
        //                           style: TextStyle(
        //                               color: kSecondaryColor,
        //                               fontSize: Responsive.isDesktop(context)
        //                                   ? 32
        //                                   : 16),
        //                         ),
        //                       ],
        //                     ),
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: [
        //                         Text(
        //                           "Phone",
        //                           style: TextStyle(
        //                               color: kSecondaryColor,
        //                               fontSize: Responsive.isDesktop(context)
        //                                   ? 32
        //                                   : 16),
        //                         ),
        //                         Text(
        //                           "${data.phone}",
        //                           style: TextStyle(
        //                               color: kSecondaryColor,
        //                               fontSize: Responsive.isDesktop(context)
        //                                   ? 32
        //                                   : 16),
        //                         ),
        //                       ],
        //                     ),
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: [
        //                         Text(
        //                           "Hotline",
        //                           style: TextStyle(
        //                               color: kSecondaryColor,
        //                               fontSize: Responsive.isDesktop(context)
        //                                   ? 20
        //                                   : 12),
        //                         ),
        //                         Text(
        //                           "${locationController.getHotlineString(data.hotline).toUpperCase()}",
        //                           style: TextStyle(
        //                               color: kSecondaryColor,
        //                               fontSize: Responsive.isDesktop(context)
        //                                   ? 20
        //                                   : 12),
        //                         ),
        //                       ],
        //                     ),
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: [
        //                         Text(
        //                           "Accessibility",
        //                           style: TextStyle(
        //                               color: kSecondaryColor,
        //                               fontSize: Responsive.isDesktop(context)
        //                                   ? 20
        //                                   : 12),
        //                         ),
        //                         Text(
        //                           "${locationController.getAccessibilityString(data.accessible).toUpperCase()}",
        //                           style: TextStyle(
        //                               color: kSecondaryColor,
        //                               fontSize: Responsive.isDesktop(context)
        //                                   ? 20
        //                                   : 12),
        //                         ),
        //                       ],
        //                     ),
        //                     SizedBox(height: kDefaultPadding),
        //                     Container(
        //                       height: 3,
        //                       width: _size.width,
        //                       decoration: BoxDecoration(color: kSecondaryColor),
        //                     ),
        //                     SizedBox(height: kDefaultPadding),
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: [
        //                         Text(
        //                           "Reset Password",
        //                           style: TextStyle(
        //                               color: kSecondaryColor,
        //                               fontSize: Responsive.isDesktop(context)
        //                                   ? 32
        //                                   : 16),
        //                         ),
        //                         ResetPasswordTextButton(email: data.email),
        //                       ],
        //                     ),
        //                     SizedBox(height: kDefaultPadding),
        //                     if (Responsive.isMobile(context))
        //                       SizedBox(height: kDefaultPadding),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           )
        //         ],
        //       );
        //     }
        //     return Loading();
        //   },
        // ),
      ),
    );
  }
}
