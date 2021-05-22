import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants.dart';
import 'package:sws_web/controllers/user_controller.dart';
import 'package:sws_web/models/user.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/routing/routes.dart';
import 'package:sws_web/services/firebase_auth_service.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/custom_alert.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';

class CreateUserButton extends StatelessWidget {
  const CreateUserButton({Key key}) : super(key: key);

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
            return CreateUserForm(route: HOME_ROUTE);
          },
        );
      },
      icon: Icon(
        Icons.add,
        size: Responsive.isMobile(context) ? 12 : 18,
      ),
      label: Text(
        "Add New",
        style: TextStyle(fontSize: Responsive.isMobile(context) ? 12 : 18),
      ),
    );
  }
}

class CreateUserForm extends StatefulWidget {
  CreateUserForm({@required this.route, Key key}) : super(key: key);
  final String route;

  @override
  _CreateUserFormState createState() => _CreateUserFormState();
}

class _CreateUserFormState extends State<CreateUserForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _showError = false;

  User _newUser = new User(hotline: false);
  String password, confirmPassword;
  bool showPassword = false, showConfirmPassword = false;

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
              width:
                  (_size.width * (Responsive.isDesktop(context) ? 0.5 : 0.8)),
              padding: EdgeInsets.all(kDefaultPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildFullNameField(),
                    SizedBox(height: kDefaultPadding),
                    _buildEmailField(),
                    SizedBox(height: kDefaultPadding),
                    _buildPhoneField(),
                    SizedBox(height: kDefaultPadding),
                    _buildPasswordField(),
                    SizedBox(height: kDefaultPadding),
                    _buildConfirmPasswordField(),
                    SizedBox(height: kDefaultPadding),
                    _buildHotlineField(),
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
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      final database = Provider.of<FirestoreService>(context, listen: false);
      final UserController userController =
          UserController(firestoreService: database);

      _newUser.accessible = true;
      bool success = await userController.createNewUser(
          authService: auth, user: _newUser, password: password);

      setState(() {
        isLoading = false;
        _newUser = new User(hotline: false);

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
          onSaved: (String value) {
            setState(() => _newUser.fullname = value);
          },
        ),
      ),
    );
  }

  Widget _buildEmailField() {
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
            hintText: 'Email',
            hintStyle: TextStyle(color: Colors.grey),
            icon: Icon(
              Icons.email,
              color: Colors.indigo,
            ),
          ),
          validator: (String value) {
            if (value.isEmpty) {
              return REQUIRED_FIELD;
            } else if (!RegExp(REG_EXP_EMAIL).hasMatch(value)) {
              return INVALID_EMAIL;
            } else
              return null;
          },
          onSaved: (String value) {
            setState(() {
              _newUser.email = value;
            });
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
          onSaved: (String value) {
            setState(() {
              _newUser.phone = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
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
            hintText: 'Password',
            hintStyle: TextStyle(color: Colors.grey),
            icon: Icon(
              Icons.lock,
              color: Colors.indigo,
            ),
            suffixIcon: InkWell(
              onTap: () {
                setState(() => showPassword = !showPassword);
              },
              child: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.indigo),
            ),
          ),
          obscureText: !showPassword,
          validator: (String value) {
            if (value.isEmpty) {
              return REQUIRED_FIELD;
            } else if (!RegExp(REG_EXP_PASSWORD).hasMatch(value)) {
              return INVALID_PASSWORD;
            } else
              return null;
          },
          onChanged: (String value) {
            password = value;
          },
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
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
            hintText: 'Confirm Password',
            hintStyle: TextStyle(color: Colors.grey),
            icon: Icon(
              Icons.lock,
              color: Colors.indigo,
            ),
            suffixIcon: InkWell(
              onTap: () {
                setState(() => showConfirmPassword = !showConfirmPassword);
              },
              child: Icon(
                  showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.indigo),
            ),
          ),
          obscureText: !showConfirmPassword,
          validator: (String value) {
            if (value.isEmpty) {
              return REQUIRED_FIELD;
            } else if (value != password) {
              return INVALID_CONFIRM_PASSWORD;
            } else
              return null;
          },
          onChanged: (String value) {
            confirmPassword = value;
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
                '${userController.getHotlineString(_newUser.hotline)}',
                style: TextStyle(
                    color: Colors.indigo,
                    fontSize: Responsive.isMobile(context) ? 12 : 18),
              ),
              Switch(
                value: _newUser.hotline,
                onChanged: (value) {
                  setState(() => _newUser.hotline = value);
                },
                activeTrackColor: kPrimaryColor,
                activeColor: kSecondaryColor,
              ),
            ],
          )),
    );
  }
}
