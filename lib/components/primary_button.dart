import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:ashwini_electronics/constants.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonTitle;
  final void Function() onPress;
  final Color buttonColor;
  const PrimaryButton({Key? key, required this.buttonTitle, required this.onPress, this.buttonColor = kPrimary01}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormHelper.submitButton(buttonTitle,
        onPress,
        btnColor: buttonColor,
        borderColor: Colors.white,
        borderRadius: kInputBorderRadius,
    );
  }
}
