import 'package:flutter/material.dart';
import 'package:ashwini_electronics/constants.dart';

class BlankListMessage extends StatelessWidget {
  const BlankListMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text(
          'No Products available!',
          style: TextStyle(color: kTextSecondary, fontSize: 16),
        ),
      ),
    );
  }
}
