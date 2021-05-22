import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants.dart';
import 'package:sws_web/controllers/user_controller.dart';
import 'package:sws_web/models/user.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/custom_alert.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';

class UpdateUserForm extends StatefulWidget {
  UpdateUserForm({@required this.data, @required this.route, Key key})
      : super(key: key);
  final User data;
  final String route;

  @override
  _UpdateUserFormState createState() => _UpdateUserFormState();
}

class _UpdateUserFormState extends State<UpdateUserForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _showError = false;

  User data;

  @override
  void initState() {
    super.initState();
    data = User.copy(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: kBgColor,
      title: new Text(
        'New User Form',
        style: TextStyle(
            color: kSecondaryColor,
            fontSize: Responsive.isDesktop(context) ? 24 : 16,
            fontWeight: FontWeight.bold),
      ),
      content: isLoading
          ? Loading()
          : Container(
              height:
                  _size.height * (Responsive.isDesktop(context) ? 0.4 : 0.5),
              width:
                  (_size.width * (Responsive.isDesktop(context) ? 0.5 : 0.8)),
              padding: EdgeInsets.all(kDefaultPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildFullNameField(),
                    SizedBox(height: kDefaultPadding),
                    _buildPhoneField(),
                    SizedBox(height: kDefaultPadding),
                    _buildHotlineField(),
                    SizedBox(height: kDefaultPadding),
                    _buildAccessibilityField(),
                    SizedBox(height: kDefaultPadding),
                    CustomAlert(
                      text: 'Error occured. Please try again',
                      show: _showError,
                      type: 'danger',
                    ),
                    SizedBox(height: kDefaultPadding),
                  ],
                ),
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
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              _save();
            } else {
              setState(() {
                isLoading = false;
              });
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Complete the form.')));
            }
          },
        ),
      ],
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
        Navigator.pushReplacementNamed(context, widget.route);
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

  Widget _buildFullNameField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: TextFormField(
          style: TextStyle(
              color: Colors.indigo,
              fontSize: Responsive.isMobile(context) ? 12 : 18),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Full Name',
            hintStyle: TextStyle(color: Colors.grey),
            icon: Icon(
              Icons.edit,
              color: Colors.indigo,
            ),
          ),
          validator: (String value) {
            if (value.isEmpty) {
              return REQUIRED_FIELD;
            } else
              return null;
          },
          initialValue: data.fullname,
          onSaved: (String value) {
            setState(() => data.fullname = value);
          },
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: TextFormField(
          style: TextStyle(
              color: Colors.indigo,
              fontSize: Responsive.isMobile(context) ? 12 : 18),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Phone No.',
            hintStyle: TextStyle(color: Colors.grey),
            icon: Icon(
              Icons.phone,
              color: Colors.indigo,
            ),
          ),
          validator: (String value) {
            if (value.isEmpty) {
              return REQUIRED_FIELD;
            } else
              return null;
          },
          initialValue: data.phone,
          onSaved: (String value) {
            setState(() {
              data.phone = value;
            });
          },
        ),
      ),
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

  Widget _buildAccessibilityField() {
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
                'Accessibility',
                style: TextStyle(
                    color: Colors.indigo,
                    fontSize: Responsive.isMobile(context) ? 12 : 18),
              ),
              SizedBox(width: kDefaultPadding * 2),
              Text(
                '${userController.getAccessibilityString(data.accessible)}',
                style: TextStyle(
                    color: Colors.indigo,
                    fontSize: Responsive.isMobile(context) ? 12 : 18),
              ),
              Switch(
                value: data.accessible,
                onChanged: (value) {
                  setState(() => data.accessible = value);
                },
                activeTrackColor: kPrimaryColor,
                activeColor: kSecondaryColor,
              ),
            ],
          )),
    );
  }
}
