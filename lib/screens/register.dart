import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import 'package:ashwini_electronics/components/hero_container.dart';
import 'package:ashwini_electronics/components/rounded_textIconBox.dart';
import 'package:ashwini_electronics/components/primary_button.dart';
import 'package:ashwini_electronics/components/dialog_alert.dart';
import 'package:ashwini_electronics/config.dart';
import 'package:ashwini_electronics/constants.dart';
import 'package:ashwini_electronics/messages.dart';

import 'package:ashwini_electronics/services/api_service.dart';
import 'package:ashwini_electronics/models/register_request_model.dart';
import 'package:ashwini_electronics/functions/validation_functions.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isAPICallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? name;
  String? password;
  String? email;

  void submitRegister() {
    if (validateAndSave(globalFormKey)) {
      setState(() {
        isAPICallProcess = true;
      });

      RegisterRequestModel model = RegisterRequestModel(
        name: name!,
        email: email!,
        password: password!,
      );
      APIService.register(model).then((response) {
        if (response!.status!!) {
          setState(() {
            isAPICallProcess = false;
          });

          customDialogAlert(
            context,
            kRegistrationMessage(response.message),
            'Ok',
            () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                kLoginRoute,
                (route) => false,
              );
            },
          );
        } else {
          customDialogAlert(
            context,
            response.message!,
            'Ok',
            () {
              Navigator.of(context).pop();
            },
          );
        }
      }).catchError(
        (e) {
          setState(() {
            isAPICallProcess = false;
          });
          customDialogAlert(
            context,
            kSignupErrorMessage,
            'Ok',
            () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  IconButton passVisibilityToggle() {
    return IconButton(
      onPressed: () {
        setState(() {
          hidePassword = !hidePassword;
        });
      },
      icon: Icon(
        hidePassword ? Icons.visibility_off : Icons.visibility,
      ),
      color: kPrimary02,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ProgressHUD(
          inAsyncCall: isAPICallProcess,
          opacity: 0.3,
          key: UniqueKey(),
          child: Form(
            key: globalFormKey,
            child: _registerUI(context),
          ),
        ),
        // home: Container(
        //   child: Text('Login Screen Ashwini'),
        // ),
      ),
    );
  }

  Widget _registerUI(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const HeroContainer(),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextIconInput(
                      inputName: "name",
                      placeholder: "Name",
                      borderRadius: kInputBorderRadius,
                      borderColor: kTextLight,
                      icon: Icons.person,
                      onValidateVal: (onValidateVal) {
                        return checkOnlyIfEmpty(onValidateVal, kNameField);
                      },
                      onSavedVal: (onSavedVal) => {
                        name = onSavedVal,
                      },
                      obscureText: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: RoundedTextIconInput(
                        inputName: "email",
                        placeholder: kEmailField,
                        borderRadius: kInputBorderRadius,
                        borderColor: kTextLight,
                        icon: Icons.person,
                        onValidateVal: (onValidateVal) {
                          return checkValidEmail(onValidateVal, kEmailField);
                        },
                        onSavedVal: (onSavedVal) => {
                          email = onSavedVal,
                        },
                        obscureText: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: RoundedTextIconInput(
                        inputName: "password",
                        placeholder: kPasswordField,
                        borderRadius: kInputBorderRadius,
                        borderColor: kTextLight,
                        icon: Icons.key_sharp,
                        onValidateVal: (onValidateVal) {
                          return checkValidPassword(
                              onValidateVal, kPasswordField);
                        },
                        onSavedVal: (onSavedVal) => {password = onSavedVal},
                        obscureText: hidePassword,
                        suffixIcon: passVisibilityToggle(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PrimaryButton(
                      buttonTitle: 'Register',
                      onPress: submitRegister,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        'OR',
                        style: kCapsBoldTextStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: RichText(
                          text: TextSpan(
                            style: kSecondaryTextStyle,
                            children: <TextSpan>[
                              const TextSpan(text: 'Back to '),
                              TextSpan(
                                text: 'Log in',
                                style: kPrimaryLinkStyle,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      kLoginRoute,
                                      (route) => false,
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
