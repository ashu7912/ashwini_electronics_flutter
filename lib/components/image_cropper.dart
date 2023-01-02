import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ashwini_electronics/constants.dart';


Future<File?> cropImage({required File imageFile}) async {
  CroppedFile? croppedImage = await ImageCropper().cropImage(
    sourcePath: imageFile.path,
    aspectRatioPresets: [CropAspectRatioPreset.square],
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: kPrimary01,
        statusBarColor: kPrimary01,
        activeControlsWidgetColor: kPrimary01,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
    ],
  );
  if (croppedImage == null) {
    return null;
  }
  return File(croppedImage.path);
}