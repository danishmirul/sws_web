import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/services/firebase_auth_service.dart';
import 'package:sws_web/widgets/custom_alert.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';

class SigninForm extends StatefulWidget {
  SigninForm({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SigninForm> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  bool _showPassword = false;
  bool _showError = false;
  bool isLoading = false;

  bool verifyForm() {
    final form = _formKey.currentState;
    form.save();

    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _signInEmailPassword(
      BuildContext context, String email, String password) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      dynamic result = await auth.signInEmailPassword(_email, _password);
      print(result.toString());

      if (result == null) {
        setState(() {
          _showError = true;
          isLoading = false;
        });
      }
      print('Sign In Try: $result');
    } catch (e) {
      print('Sign In Catch: $e');
      setState(() {
        _showError = true;
        isLoading = false;
      });
    }
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
              Icons.email_outlined,
              color: Colors.indigo,
            ),
          ),
          validator: (String value) {
            if (value.isEmpty) {
              return REQUIRED_EMAIL;
            }

            if (!RegExp(REG_EXP_EMAIL).hasMatch(value)) {
              return INVALID_EMAIL;
            }

            return null;
          },
          onSaved: (String value) {
            setState(() {
              _email = value;
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
              Icons.lock_open_outlined,
              color: Colors.indigo,
            ),
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
              child: Icon(
                (_showPassword ? Icons.visibility : Icons.visibility_off),
                color: Colors.indigo,
              ),
            ),
          ),
          obscureText: !_showPassword,
          keyboardType: TextInputType.visiblePassword,
          validator: (String value) {
            if (value.isEmpty) {
              return REQUIRED_PASSWORD;
            }

            return null;
          },
          onSaved: (String value) {
            setState(() {
              _password = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return InkWell(
      onTap: () {
        setState(() {
          isLoading = true;
          _showError = false;
        });

        if (verifyForm()) {
          _signInEmailPassword(context, _email, _password);
        } else {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: Container(
        height: 50,
        width: 420,
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: "Sign In",
                size: Responsive.isMobile(context) ? 12 : 18,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm() => Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.isDesktop(context)
                  ? kLargePadding
                  : kMediumPadding),
          child: isLoading
              ? Center(child: Loading())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Sign In",
                      size: Responsive.isMobile(context) ? 20 : 26,
                      weight: FontWeight.bold,
                    ),
                    SizedBox(height: kDefaultPadding * 2),
                    _buildEmailField(),
                    SizedBox(height: kDefaultPadding),
                    _buildPasswordField(),
                    SizedBox(height: kDefaultPadding),
                    CustomAlert(
                      text:
                          'Invalid email and password entered. Please try again',
                      show: _showError,
                      type: 'danger',
                    ),
                    SizedBox(height: kDefaultPadding),
                    _buildSignInButton(),
                  ],
                ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return _buildSignInForm();
  }
}
