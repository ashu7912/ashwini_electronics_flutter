import 'package:flutter/material.dart';
import 'package:ashwini_electronics/config.dart';
import 'package:ashwini_electronics/constants.dart';


Future<dynamic> customDialogAlert(BuildContext context, String alertMessage, String buttonText, Function()? onPressed) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(Customconfig.appName),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(alertMessage),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: const TextStyle(color: kPrimary01),
            ),
          ),
        ],
      );
    },
  );
}