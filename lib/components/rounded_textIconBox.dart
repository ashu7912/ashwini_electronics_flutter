import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import 'package:ashwini_electronics/constants.dart';

class RoundedTextIconInput extends StatelessWidget {
  final String inputName;
  final String placeholder;
  final double borderRadius;
  final Color borderColor;
  final IconData icon;
  // final VoidCallback onValidateVal;
  final String? Function(dynamic) onValidateVal;
  final void Function(String?) onSavedVal;
  final bool? obscureText;
  final IconButton? suffixIcon;
  final String initialValue;
  final bool numericKeyboard;
  final int multilineRows;
  final Function? onChangeValue;
  // final VoidCallback onSavedVal;

  const RoundedTextIconInput(
      {required this.inputName,
      this.placeholder = '',
      required this.borderRadius,
      required this.borderColor,
      required this.icon,
      required this.onValidateVal,
      required this.onSavedVal,
      this.onChangeValue,
      this.obscureText = false,
      this.suffixIcon,
      this.initialValue = '',
      this.numericKeyboard = false,
      this.multilineRows = 1});

  @override
  Widget build(BuildContext context) {
    return FormHelper.inputFieldWidget(
        context,
        inputName,
        prefixIcon: Icon(icon),
        showPrefixIcon: true,
        placeholder,
        onValidateVal,
        onSavedVal,
        onChange: onChangeValue,
        // initialValue: this.loginModel.host,
        borderFocusColor: kPrimary01,
        prefixIconColor: kPrimary02,
        borderColor: borderColor,
        textColor: kPrimary01,
        hintColor: kHintTextColor,
        borderRadius: borderRadius,
        paddingLeft: 0,
        paddingRight: 0,
        obscureText: obscureText,
        suffixIcon: suffixIcon,
        initialValue: initialValue,
        isNumeric: numericKeyboard,
        isMultiline:true,
        multilineRows: multilineRows,
    );
  }
}
