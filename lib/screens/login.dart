import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
// import 'package:hexcolor/hexcolor.dart';

import 'package:ashwini_electronics/components/hero_container.dart';
import 'package:ashwini_electronics/components/rounded_textIconBox.dart';
import 'package:ashwini_electronics/components/primary_button.dart';
import 'package:ashwini_electronics/components/dialog_alert.dart';
import 'package:ashwini_electronics/constants.dart';
import 'package:ashwini_electronics/messages.dart';

import 'package:ashwini_electronics/models/login_request_model.dart';
import 'package:ashwini_electronics/services/api_service.dart';
import 'package:ashwini_electronics/functions/validation_functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAPICallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? email;
  String? password;

  void submitLogin() {
    if (validateAndSave(globalFormKey)) {
      setState(() {
        isAPICallProcess = true;
      });
      LoginRequestModel model = LoginRequestModel(
        email: email!,
        password: password!,
      );
      APIService.login(model).then((response) {
        setState(() {
          isAPICallProcess = false;
        });
        if (response!.status!!) {
          showSnackBar(context, response!.message!!, kSuccessColor);
          Navigator.pushNamedAndRemoveUntil(
            context,
            kHomeRoute,
            (route) => false,
          );
        } else {
          customDialogAlert(
            context,
            kWentWrongMessage,
            'Ok',
            () {
              Navigator.of(context).pop();
            },
          );
        }
      }).catchError((e) {
        setState(() {
          isAPICallProcess = false;
        });
        customDialogAlert(
          context,
          kInvalidEmailPassMessage,
          'Ok',
          () {
            Navigator.of(context).pop();
          },
        );
      });
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
        backgroundColor: kLoginBgColor,
        body: ProgressHUD(
          inAsyncCall: isAPICallProcess,
          opacity: kLoaderBgOpacity,
          key: UniqueKey(),
          child: Form(
            key: globalFormKey,
            child: _loginUI(context),
          ),
        ),
        // home: Container(
        //   child: Text('Login Screen Ashwini'),
        // ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: RoundedTextIconInput(
                        inputName: "password",
                        placeholder: kPasswordField,
                        borderRadius: kInputBorderRadius,
                        borderColor: kTextLight,
                        icon: Icons.key_sharp,
                        onValidateVal: (onValidateVal) {
                          return checkOnlyIfEmpty(
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
                      buttonTitle: 'Login',
                      onPress: submitLogin,
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
                        padding: EdgeInsets.only(right: 25, top: 10),
                        child: RichText(
                          text: TextSpan(
                            style: kSecondaryTextStyle,
                            children: <TextSpan>[
                              const TextSpan(text: kMessageForSignup),
                              TextSpan(
                                text: 'Sign up',
                                style: kPrimaryLinkStyle,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      kRegisterRoute,
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
