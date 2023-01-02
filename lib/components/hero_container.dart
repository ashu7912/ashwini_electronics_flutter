import 'package:flutter/material.dart';
import 'package:ashwini_electronics/config.dart';
import 'package:ashwini_electronics/constants.dart';

class HeroContainer extends StatelessWidget {
  const HeroContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: 120,
          child: Image.asset(
            Customconfig.appLogo,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          Customconfig.appName,
          textAlign: TextAlign.center,
          style: kAppTitleStyle,
        ),
      ],
    );
  }
}