import 'package:flutter/material.dart';

const String kLoginRoute = '/login';
const String kHomeRoute = '/home';
const String kRegisterRoute = '/register';
const String kAddProductRoute = '/add-product';
const String kEditProductRoute = '/edit-product';
const String kUploadProductImage = '/upload-image';

const String kProductListTitle = "Product List";
const String kAddProductTitle = "Add Product";
const String kEditProductTitle = "Edit Product";
const String kAddProductImage = "Add / Update Image";

const String kLogoPlaceholderImage = 'images/logo_placeholder.png';

const kFontPacifico = 'Pacifico';
const kFont30 = 30.0;
const kFont18 = 18.0;
const kFont14 = 14.0;
const kFont12 = 14.0;
const kFont17 = 17.0;
const kInputBorderRadius = 10.0;
const kImageRadius = 8.0;

const kLoaderBgOpacity = 0.3;
const kCardElevation = 0.3;
const kCardBorderRadius = 50.0;
const kCardCountRadius = 30.0;
const kCardCountSize = 27.0;
const kCardDeleteRadius = 10.0;
const kImageIconSize = 32.0;

const kBlackColor = Colors.black;
const kWhiteColor = Colors.white;
const kDangerColor = Color(0xFFF55D6A);
const kSuccessColor = Color(0xFF2A8D4E);

const kPrimary01 = Color(0xFF00B4BB);
const kPrimary02 = Color(0xff29E8EF);
const kPrimary03 = Color(0x9900B4BB);
const kPrimary04 = Color(0xaa00B4BB);
const kSecondary01 = Color(0xAAF5F5F5);
const kSecondary02 = Color(0xAA868686);
const kLoginBgColor = kWhiteColor;
const kCardBgColor = kWhiteColor;
const kCardCountColor = kWhiteColor;
Color? kAppBgColor = Colors.grey[50];
const kTextLight = Colors.black12;
const kTextPrimary = Colors.black54;
const kTextSecondary = Colors.grey;
const kTextSecondary02 = Color(0xFFC9C9C9);
const kHintTextColor = kPrimary04;


const kAppTitleStyle = TextStyle(
  fontFamily: kFontPacifico,
  fontSize: kFont30,
  color: kPrimary01,
);

const kCapsBoldTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: kFont18,
  color: kPrimary01,
);

const kPrimaryLinkStyle = TextStyle(
    color: kPrimary01,
    decoration: TextDecoration.underline
);

const kSecondaryTextStyle = TextStyle(
    color: kTextSecondary,
    fontSize: kFont14
);


String kDeleteMessage(String? productTitle) {
  return 'Are you sure you want to delete $productTitle ?';
}

const String kLogoutMessage = 'Are you sure you want to logout ?';