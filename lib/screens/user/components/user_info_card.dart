import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/controllers/user_controller.dart';
import 'package:sws_web/models/user.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/custom_alert.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';

import '../../../constants.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({@required this.data, Key key}) : super(key: key);
  final User data;

  @override
  Widget build(BuildContext context) {
    // final database = Provider.of<FirestoreService>(context, listen: false);
    // final UserController userController =
    //     UserController(firestoreService: database);

    final Size _size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent.shade700,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
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
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Image.asset('images/profile_pic.png'),
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.white54),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return UpdateForm(data: data, size: _size);
                    },
                  );
                },
              )
            ],
          ),
          Text(
            data.fullname,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Email",
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: Responsive.isDesktop(context) ? 12 : 10),
              ),
              Text(
                "${data.email}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: Responsive.isDesktop(context) ? 12 : 10),
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
                    fontSize: Responsive.isDesktop(context) ? 12 : 10),
              ),
              Text(
                "${data.phone}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.isDesktop(context) ? 12 : 10),
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       "Hotline",
          //       style: TextStyle(
          //           color: Colors.white,
          //           fontSize: Responsive.isDesktop(context) ? 12 : 10),
          //     ),
          //     Text(
          //       "${userController.getHotlineString(data.hotline).toUpperCase()}",
          //       style: TextStyle(
          //           color: Colors.white,
          //           fontSize: Responsive.isDesktop(context) ? 12 : 10),
          //     ),
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       "Accessibility",
          //       style: Theme.of(context)
          //           .textTheme
          //           .caption
          //           .copyWith(color: Colors.white),
          //     ),
          //     Text(
          //       "${userController.getAccessibilityString(data.accessible).toUpperCase()}",
          //       style: Theme.of(context)
          //           .textTheme
          //           .caption
          //           .copyWith(color: Colors.white),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class UpdateForm extends StatefulWidget {
  UpdateForm({@required this.data, @required this.size, Key key})
      : super(key: key);
  final Size size;
  final User data;

  @override
  _UpdateFormState createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  User data;
  bool isLoading = false;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    data = User.copy(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kBgColor,
      title: new Text(
        'Update User Hotline',
        style: TextStyle(
            color: kSecondaryColor,
            fontSize: Responsive.isDesktop(context) ? 24 : 16,
            fontWeight: FontWeight.bold),
      ),
      content: isLoading
          ? Loading()
          : Container(
              height: widget.size.height *
                  (Responsive.isDesktop(context) ? 0.1 : 0.5),
              width: (widget.size.width *
                  (Responsive.isDesktop(context) ? 0.2 : 0.8)),
              padding: EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  _buildHotlineField(),
                  CustomAlert(
                    text: 'Error occured. Please try again',
                    show: _showError,
                    type: 'danger',
                  ),
                ],
              ),
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
        SizedBox(width: kDefaultPadding),
        new TextButton(
          child: Row(
            children: [
              Icon(
                Icons.save,
                color: kSecondaryColor,
              ),
              CustomText(
                text: 'Save',
                color: kSecondaryColor,
                weight: FontWeight.bold,
              ),
            ],
          ),
          onPressed: () async {
            setState(() {
              isLoading = true;
            });
            _save();
          },
        ),
      ],
    );
  }

  Widget _buildHotlineField() {
    final database = Provider.of<FirestoreService>(context, listen: false);
    final UserController userController =
        UserController(firestoreService: database);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: kDefaultPadding * 2),
              Text(
                'Hotline',
                style: TextStyle(
                    color: Colors.indigo,
                    fontSize: Responsive.isMobile(context) ? 12 : 18),
              ),
              SizedBox(width: kDefaultPadding * 2),
              Text(
                '${userController.getHotlineString(data.hotline)}',
                style: TextStyle(
                    color: Colors.indigo,
                    fontSize: Responsive.isMobile(context) ? 12 : 18),
              ),
              Switch(
                value: data.hotline,
                onChanged: (value) {
                  setState(() => data.hotline = value);
                },
                activeTrackColor: kPrimaryColor,
                activeColor: kSecondaryColor,
              ),
            ],
          )),
    );
  }

  Future<void> _save() async {
    try {
      // Save to Firestore
      final database = Provider.of<FirestoreService>(context, listen: false);
      final UserController userController =
          UserController(firestoreService: database);

      bool success = await userController.updateUser(data);

      setState(() {
        isLoading = false;

        if (!success) _showError = true;
      });

      if (success) {
        Navigator.pushReplacementNamed(context, '/');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Saved Successfully')));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        _showError = true;
      });
    }
  }
}
