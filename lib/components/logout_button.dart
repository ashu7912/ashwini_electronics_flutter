import 'package:flutter/material.dart';
import 'package:ashwini_electronics/services/shared_servicec.dart';
// import 'package:snippet_coder_utils/FormHelper.dart';

import 'package:ashwini_electronics/constants.dart';
import 'package:ashwini_electronics/components/dialog_alert.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      // tooltip: 'Show Snackbar',
      onPressed: () {
        customDialogAlert(
          context,
          kLogoutMessage,
          'Ok',
          () {
            Navigator.of(context).pop();
            SharedService.logout(context);
          },
        );
        // FormHelper.showSimpleAlertDialog(
        //     context, Customconfig.appName, kLogoutMessage, "Ok", () {
        //   SharedService.logout(context);
        // });
        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Please add Logout here !')));
      },
    );
  }
}
