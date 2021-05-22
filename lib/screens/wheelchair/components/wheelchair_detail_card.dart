import 'package:flutter/material.dart';

import '../../../constants.dart';

class WheelchairDetailCard extends StatelessWidget {
  const WheelchairDetailCard({
    Key key,
    @required this.title,
    @required this.imgSrc,
    @required this.percentage,
    @required this.numOfWheelchairs,
  }) : super(key: key);

  final String title, imgSrc;
  final double numOfWheelchairs, percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: kDefaultPadding),
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: kPrimaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(kDefaultPadding),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Image.asset(imgSrc),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "$numOfWheelchairs wheelchairs",
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          Text('$percentage%')
        ],
      ),
    );
  }
}
