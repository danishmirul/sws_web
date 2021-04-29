import 'package:flutter/material.dart';

import 'custom_text.dart';

class PageHeader extends StatelessWidget {
  final String text;

  const PageHeader({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 44.0,
        top: 14.0,
        bottom: 14.0,
      ),
      child: CustomText(
        text: text,
        size: 40,
        weight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }
}
