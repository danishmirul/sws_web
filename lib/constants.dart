import 'package:flutter/material.dart';

const kPrimaryColor = Colors.lightBlue;
const kSecondaryColor = Color(0xFF003480);
const kBgColor = Color(0xFFF9F8FD);

const kDefaultPadding = 16.0;
const kMediumPadding = 28.0;
const kLargePadding = 36.0;

const kHomepageBg =
    'https://firebasestorage.googleapis.com/v0/b/smartwheelchairsystem-67d9b.appspot.com/o/assets%2Fweb%2Fbg.jpg?alt=media&token=513bb13c-b192-4e3c-8ad2-fd88ba453b19';
const kLogo =
    'https://firebasestorage.googleapis.com/v0/b/smartwheelchairsystem-67d9b.appspot.com/o/assets%2Fweb%2Flogo.png?alt=media&token=2ce0f20a-3cb2-493a-9cd5-b0f8c3ea5f69';
const kLogoWhite =
    'https://firebasestorage.googleapis.com/v0/b/smartwheelchairsystem-67d9b.appspot.com/o/assets%2Fweb%2Flogo_white.png?alt=media&token=8b095d55-3639-4b24-958c-0a6bcdd05611';

// Messages

const String REQUIRED_EMAIL = 'Email is required.';
const String REQUIRED_FULL_NAME = 'Full name is required.';
const String REQUIRED_PHONE_NO = 'Phone no. is required.';
const String REQUIRED_PASSWORD = 'Password is required.';
const String REQUIRED_CONFIRM_PASSWORD = 'Confirm password is required.';
const String REQUIRED_FIELD = 'This field is required.';
const String REQUIRED_BATTERY = 'Battery reading automatically set to 0.';

const String INVALID_EMAIL = 'Please enter a valid Email Address';
const String INVALID_PASSWORD = 'Please enter a password with\n' +
    'Minimum 1 Upper case\n' +
    'Minimum 1 lowercase\n' +
    'Minimum 1 Numeric Number\n' +
    'Minimum 1 Special Character\n' +
    'Common Allow Character';

const String INVALID_CONFIRM_PASSWORD = 'Confirm password does not match.';

const String REG_EXP_EMAIL =
    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
const String REG_EXP_PASSWORD =
    r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$";
