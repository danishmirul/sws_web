import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants.dart';
import 'package:sws_web/controllers/user_controller.dart';
import 'package:sws_web/models/user.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/services/firestore_service.dart';

class ViewUserInformation extends StatelessWidget {
  const ViewUserInformation({@required this.data, Key key}) : super(key: key);
  final User data;

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService =
        Provider.of<FirestoreService>(context, listen: false);
    UserController userController =
        UserController(firestoreService: firestoreService);

    final Size _size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: kBgColor,
      title: new Text(
        'User',
        style: TextStyle(
            color: kSecondaryColor,
            fontSize: Responsive.isDesktop(context) ? 24 : 16,
            fontWeight: FontWeight.bold),
      ),
      content: Container(
        height: _size.height * (Responsive.isDesktop(context) ? 0.3 : 0.3),
        width: _size.width * (Responsive.isDesktop(context) ? 0.3 : 0.5),
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(kDefaultPadding * 0.75),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Image.asset(
                    'images/profile_pic.png',
                  ),
                ),
              ],
            ),
            Text(
              data.fullname,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: kSecondaryColor,
                  fontSize: Responsive.isDesktop(context) ? 22 : 14),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Email",
                  style: TextStyle(
                      color: kSecondaryColor.withOpacity(.7),
                      fontSize: Responsive.isDesktop(context) ? 20 : 12),
                ),
                Text(
                  "${data.email}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: kSecondaryColor.withOpacity(.7),
                      fontSize: Responsive.isDesktop(context) ? 20 : 12),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Phone",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.isDesktop(context) ? 22 : 14),
                ),
                Text(
                  "${data.phone}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.isDesktop(context) ? 22 : 14),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hotline",
                  style: TextStyle(
                      color: kSecondaryColor,
                      fontSize: Responsive.isDesktop(context) ? 20 : 12),
                ),
                Text(
                  "${userController.getHotlineString(data.hotline).toUpperCase()}",
                  style: TextStyle(
                      color: kSecondaryColor,
                      fontSize: Responsive.isDesktop(context) ? 20 : 12),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Accessibility",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: kSecondaryColor),
                ),
                Text(
                  "${userController.getAccessibilityString(data.accessible).toUpperCase()}",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: kSecondaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
