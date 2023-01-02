import 'package:flutter/material.dart';
import 'package:ashwini_electronics/constants.dart';

class ProductFormLabel extends StatelessWidget {
  final String title;
  const ProductFormLabel({Key? key, this.title = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 6),
      child: Text(
        title,
        style: TextStyle(
          color: kTextPrimary,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
