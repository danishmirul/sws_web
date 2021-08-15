import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/controllers/user_controller.dart';
import 'package:sws_web/models/user.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/screens/user/components/user_info_card.dart';
import 'package:sws_web/screens/user/components/create_user_form.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';

import '../../../constants.dart';

class AvailableHotlines extends StatelessWidget {
  const AvailableHotlines({
    Key key,
    @required this.route,
  }) : super(key: key);
  final String route;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: 'Available User Hotlines',
              color: kSecondaryColor,
              weight: FontWeight.bold,
              size: 24,
            ),
            CreateUserButton(),
          ],
        ),
        SizedBox(height: kDefaultPadding),
        Responsive(
          mobile: AvailableHotlineCardGridView(
            route: route,
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 ? 1.3 : 1,
          ),
          tablet: AvailableHotlineCardGridView(route: route),
          desktop: AvailableHotlineCardGridView(
            route: route,
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class AvailableHotlineCardGridView extends StatelessWidget {
  const AvailableHotlineCardGridView({
    Key key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    @required this.route,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final String route;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreService>(context, listen: false);
    final UserController userController =
        UserController(firestoreService: database);

    return FutureBuilder<List<User>>(
      future: userController.getAvailableHotlines(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<User> users = snapshot.data;

          return GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: users.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: kDefaultPadding,
              mainAxisSpacing: kDefaultPadding,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) =>
                UserInfoCard(route: route, data: users[index]),
          );
        } else
          return Loading();
      },
    );
  }
}
