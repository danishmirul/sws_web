import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/services/firebase_auth_service.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';

class ResetPasswordTextButton extends StatelessWidget {
  const ResetPasswordTextButton({@required this.email, Key key})
      : super(key: key);
  final String email;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 1.5,
          vertical: kDefaultPadding / (Responsive.isMobile(context) ? 2 : 1),
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ResetPasswordDialog(email: email);
          },
        );
      },
      icon: Icon(
        Icons.restore,
        size: Responsive.isMobile(context) ? 12 : 18,
      ),
      label: Text(
        "Reset Password",
        style: TextStyle(fontSize: Responsive.isMobile(context) ? 12 : 18),
      ),
    );
  }
}

class ResetPasswordDialog extends StatefulWidget {
  ResetPasswordDialog({@required this.email, Key key}) : super(key: key);
  final String email;

  @override
  _ResetPasswordDialogState createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kBgColor,
      title: new CustomText(
        text: 'You about to reset the password',
        color: kSecondaryColor,
        weight: FontWeight.bold,
      ),
      content: Column(
        children: [
          CustomText(
            text:
                'Are you sure to reset the password?\nAn email will send to you to reset the password.',
            color: kSecondaryColor,
            weight: FontWeight.bold,
          ),
          isLoading ? Loading() : Container()
        ],
      ),
      actions: <Widget>[
        new TextButton(
          child: new CustomText(
            text: 'Cancel',
            color: Colors.red,
            weight: FontWeight.bold,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        new TextButton(
          child: new CustomText(
            text: 'Confirm',
            color: kSecondaryColor,
            weight: FontWeight.bold,
          ),
          onPressed: () async {
            try {
              final auth =
                  Provider.of<FirebaseAuthService>(context, listen: false);
              setState(() => isLoading = true);
              await auth.resetPassword(email: '');
              setState(() => isLoading = false);
            } catch (e) {
              print('_resetPassword Catch: $e');
            }
          },
        ),
      ],
    );
  }
}
