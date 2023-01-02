import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_view/photo_view.dart';

import 'package:ashwini_electronics/components/rounded_textIconBox.dart';
import 'package:ashwini_electronics/components/primary_button.dart';
import 'package:ashwini_electronics/components/productForm_label.dart';
import 'package:ashwini_electronics/config.dart';
import 'package:ashwini_electronics/constants.dart';

import 'package:ashwini_electronics/functions/validation_functions.dart';
import 'package:ashwini_electronics/models/product_model.dart';
import 'package:ashwini_electronics/services/api_service.dart';

class ProductAddEditScreen extends StatefulWidget {
  const ProductAddEditScreen({Key? key}) : super(key: key);

  @override
  State<ProductAddEditScreen> createState() => _ProductAddEditScreenState();
}

class _ProductAddEditScreenState extends State<ProductAddEditScreen> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool isAPICallProcess = false;
  ProductModel? productModel;
  var productImage;
  bool isEditMode = false;
  bool isImageSelected = false;

  submitAddUpdateProduct() {
    if (validateAndSave()) {
      setState(() {
        isAPICallProcess = true;
      });
      if (!isEditMode) {
        APIService.saveProduct(productModel!).then((response) {
          setState(() {
            isAPICallProcess = false;
          });
          if (response!.status!!) {
            showSnackBar(context, response!.message!!, kSuccessColor);
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          } else {
            FormHelper.showSimpleAlertDialog(
                context, Customconfig.appName, 'Error Occure!', 'Ok', () {
              Navigator.of(context).pop();
            });
          }
        });
      } else {
        APIService.updateProduct(productModel!).then((response) {
          setState(() {
            isAPICallProcess = false;
          });
          if (response!.status!!) {
            showSnackBar(context, response!.message!!, kSuccessColor);
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          } else {
            FormHelper.showSimpleAlertDialog(
                context, Customconfig.appName, 'Error Occure!', 'Ok', () {
              Navigator.of(context).pop();
            });
          }
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productModel = ProductModel();
    Future.delayed(Duration.zero, () {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
        productModel = arguments["model"];
        isEditMode = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimary01,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text((isEditMode) ? kEditProductTitle : kAddProductTitle),
            elevation: 0,
            backgroundColor: kPrimary01,
          ),
          backgroundColor: kLoginBgColor,
          body: ProgressHUD(
            key: UniqueKey(),
            child: Form(
              key: globalKey,
              child: productForm(),
            ),
            inAsyncCall: isAPICallProcess,
            opacity: kLoaderBgOpacity,
            color: kPrimary01,
          ),
        ),
      ),
    );
  }

  Widget productForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProductFormLabel(
              title: kProductNameField,
            ),
            RoundedTextIconInput(
              inputName: "title",
              borderRadius: kInputBorderRadius,
              borderColor: kTextLight,
              icon: Icons.settings,
              initialValue: productModel!.title ?? "",
              onValidateVal: (onValidateVal) {
                return checkOnlyIfEmpty(onValidateVal, kProductNameField);
              },
              onSavedVal: (onSavedValue) {
                productModel!.title = onSavedValue;
              },
            ),
            ProductFormLabel(
              title: kBuyingPriceField,
            ),
            RoundedTextIconInput(
              inputName: "buyingPrice",
              borderRadius: kInputBorderRadius,
              borderColor: kTextLight,
              icon: Icons.currency_rupee,
              onValidateVal: (onValidateVal) {
                return checkNumericValue(onValidateVal, kBuyingPriceField);
              },
              onSavedVal: (onSavedValue) {
                productModel!.buyingPrice = onSavedValue;
              },
              initialValue: productModel!.buyingPrice ?? "",
              numericKeyboard: true,
            ),
            ProductFormLabel(
              title: kSellingPriceField,
            ),
            RoundedTextIconInput(
              inputName: "sellingPrice",
              borderRadius: kInputBorderRadius,
              borderColor: kTextLight,
              icon: Icons.currency_rupee,
              onValidateVal: (onValidateVal) {
                return checkNumericValue(onValidateVal, kSellingPriceField);
              },
              onSavedVal: (onSavedValue) {
                productModel!.sellingPrice = onSavedValue;
              },
              initialValue: productModel!.sellingPrice ?? "",
              numericKeyboard: true,
            ),
            ProductFormLabel(
              title: kQuantityField,
            ),
            RoundedTextIconInput(
              inputName: "count",
              borderRadius: kInputBorderRadius,
              borderColor: kTextLight,
              icon: Icons.add_shopping_cart,
              onValidateVal: (onValidateVal) {
                return checkNumericValue(onValidateVal, kQuantityField);
              },
              onSavedVal: (onSavedValue) {
                productModel!.count = int.parse(onSavedValue!);
              },
              initialValue: productModel!.count != null
                  ? productModel!.count.toString()
                  : "0",
              numericKeyboard: true,
            ),
            ProductFormLabel(
              title: kDescriptionField,
            ),
            RoundedTextIconInput(
              inputName: "description",
              borderRadius: kInputBorderRadius,
              borderColor: kTextLight,
              icon: Icons.description,
              onValidateVal: (onValidateVal) {
                return null;
              },
              onSavedVal: (onSavedValue) {
                productModel!.description = onSavedValue ?? '';
              },
              initialValue: productModel!.description ?? "",
              multilineRows: 3,
            ),
            SizedBox(height: 20),
            PrimaryButton(
              buttonTitle: 'Save',
              onPress: submitAddUpdateProduct,
            ),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

}

