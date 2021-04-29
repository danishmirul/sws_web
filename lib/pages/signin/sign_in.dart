import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants/size.dart';
import 'package:sws_web/constants/string.dart';
import 'package:sws_web/services/firebase_auth_service.dart';
import 'package:sws_web/widgets/custom_alert.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Email',
            icon: Icon(
              Icons.email_outlined,
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
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Password',
            icon: Icon(Icons.lock_open_outlined),
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
              child:
                  Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
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
                size: 18,
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
          padding: const EdgeInsets.symmetric(horizontal: cDefaultPadding),
          child: isLoading
              ? Center(child: Loading())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "SignIn",
                      size: 26,
                      weight: FontWeight.bold,
                    ),
                    SizedBox(height: cDefaultPadding * 2),
                    _buildEmailField(),
                    SizedBox(height: cDefaultPadding),
                    _buildPasswordField(),
                    SizedBox(height: cDefaultPadding),
                    CustomAlert(
                      text:
                          'Invalid email and password entered. Please try again',
                      show: _showError,
                      type: 'danger',
                    ),
                    SizedBox(height: cDefaultPadding),
                    _buildSignInButton(),
                  ],
                ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 620,
      width: 460,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey, offset: Offset(0, 3), blurRadius: 24)
        ],
      ),
      child: _buildSignInForm(),
    );
  }
}
