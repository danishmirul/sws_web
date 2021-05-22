import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/controllers/wheelchair_controller.dart';
import 'package:sws_web/models/wheelchair.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/screens/wheelchair/components/wheelchair_info_card.dart';
import 'package:sws_web/screens/wheelchair/components/create_wheelchair_form.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';

import '../../../constants.dart';

class AvailableWheelchairs extends StatelessWidget {
  const AvailableWheelchairs({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: 'Available Wheelchairs',
              color: kSecondaryColor,
              weight: FontWeight.bold,
              size: 24,
            ),
            CreateWheelchairButton(),
          ],
        ),
        SizedBox(height: kDefaultPadding),
        Responsive(
          mobile: AvailableWheelchairCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 ? 1.3 : 1,
          ),
          tablet: AvailableWheelchairCardGridView(),
          desktop: AvailableWheelchairCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class AvailableWheelchairCardGridView extends StatelessWidget {
  const AvailableWheelchairCardGridView({
    Key key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreService>(context, listen: false);
    final WheelchairController wheelchairController =
        WheelchairController(firestoreService: database);

    return FutureBuilder<List<Wheelchair>>(
      future: wheelchairController.getAvailableWheelchairs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Wheelchair> wheelchairs = snapshot.data;

          return GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: wheelchairs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: kDefaultPadding,
              mainAxisSpacing: kDefaultPadding,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) =>
                WheelchairInfoCard(data: wheelchairs[index]),
          );
        } else
          return Loading();
      },
    );
  }
}
