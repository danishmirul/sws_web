import 'package:flutter/material.dart';
import 'package:sws_web/widgets/custom_text.dart';

class StatisticCard extends StatelessWidget {
  const StatisticCard(
      {this.title,
      this.value,
      this.color1,
      this.color2,
      this.icon,
      this.subtitle,
      Key key})
      : super(key: key);
  final String subtitle;
  final String title;
  final String value;
  final Color color1;
  final Color color2;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Container(
        height: 90,
        width: size.width * 0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
              colors: [color1 ?? Colors.green, color2 ?? Colors.blue],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300], offset: Offset(0, 3), blurRadius: 16)
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTile(
                title: CustomText(
                  text: title,
                  size: 16,
                  weight: FontWeight.bold,
                  color: Colors.white,
                ),
                subtitle: CustomText(
                  text: subtitle,
                  size: 16,
                  weight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: value,
                    size: 34,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
