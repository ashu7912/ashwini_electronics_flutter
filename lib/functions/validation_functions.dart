import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:validators/validators.dart';

const String kEmailField = 'Email';
const String kPasswordField = 'Password';
const String kNameField = 'Name';
const String kProductNameField = 'Product Name';
const String kBuyingPriceField = 'Buying Price';
const String kSellingPriceField = 'Selling Price';
const String kQuantityField = 'Quantity';
const String kDescriptionField = 'Description';
const int minPassLimit = 6;


bool validateAndSave(GlobalKey<FormState> globalFormKey) {
  final form = globalFormKey.currentState;
  if (form!.validate()) {
    form.save();
    return true;
  } else {
    return false;
  }
}


String? checkValidEmail (onValidateVal, fieldTitle) {
  if (onValidateVal.isEmpty) {
    return '$fieldTitle can\'t be empty.';
  }
  if(!isEmail(onValidateVal)) {
    return 'Please enter valid ${fieldTitle!.toLowerCase()}.';
  }
  return null;
}

String? checkValidPassword (onValidateVal, fieldTitle) {
  if (onValidateVal.isEmpty) {
    return '$fieldTitle can\'t be empty.';
  }
  if(minPassLimit > onValidateVal.toString().length) {
    return '$fieldTitle must be at least ${minPassLimit.toString()} characters.';
  }

  return null;
}

String? checkNumericValue (onValidateVal, String fieldTitle) {
  if (onValidateVal.isEmpty) {
    return '$fieldTitle can\'t be empty';
  }
  // if (!new RegExp(r'^[0-9]+$').hasMatch(onValidateVal)) {
  //   return 'Invalid price';
  // }

  if (!isNumeric(onValidateVal)) {
    return 'Invalid ${fieldTitle.toLowerCase()}';
  }
  return null;
}

String? checkOnlyIfEmpty (onValidateVal, fieldTitle) {
  if (onValidateVal.isEmpty) {
    return '$fieldTitle can\'t be empty.';
  }
  return null;
}


void showSnackBar(BuildContext context, String message, Color snackBarColor) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: snackBarColor,
      content: Text(message),
    ),
  );
}


void clearImageCache(void Function() setState) {
  DefaultCacheManager().emptyCache();

  imageCache?.clear();
  imageCache?.clearLiveImages();
  setState;
}

