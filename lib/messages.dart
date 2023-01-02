import 'package:flutter/material.dart';

const String kWentWrongMessage = 'Something went wrong !';
const String kInvalidEmailPassMessage = 'Invalid email/Password !';
const String kMessageForSignup = 'Don\'t have an account?';
const String kSignupErrorMessage = "Email is already exist !";

String kDeleteMessage(String? productTitle) {
  return 'Are you sure you want to delete $productTitle ?';
}

String kRegistrationMessage(String? message) {
  return "$message Please login to the account.";
}