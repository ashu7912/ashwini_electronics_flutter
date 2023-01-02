import 'dart:io';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:ashwini_electronics/components/dialog_alert.dart';
import 'package:ashwini_electronics/components/image_cropper.dart';

import 'package:ashwini_electronics/config.dart';
import 'package:ashwini_electronics/constants.dart';
import 'package:ashwini_electronics/messages.dart';
import 'package:ashwini_electronics/services/api_service.dart';
import 'package:ashwini_electronics/models/product_model.dart';
import 'package:ashwini_electronics/functions/validation_functions.dart';

class AddUploadImage extends StatefulWidget {
  const AddUploadImage({Key? key}) : super(key: key);

  @override
  State<AddUploadImage> createState() => _AddUploadImageState();
}

class _AddUploadImageState extends State<AddUploadImage> {
  bool isAPICallProcess = false;
  var productImage;
  bool isImageSelected = false;
  ProductModel productModel = ProductModel();

  uploadImage() {
    setState(() {
      isAPICallProcess = true;
    });
    APIService.uploadProductImage(productModel!.id!!, productImage)
        .then((response) {
      clearImageCache(() {
        setState(() {
          isAPICallProcess = false;
        });
      });
      if (response) {
        showSnackBar(context, 'Image uploaded!', kSuccessColor);
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
      showSnackBar(context, kWentWrongMessage, kDangerColor);
      setState(() {
        isAPICallProcess = false;
      });
    });
  }

  deleteProductImage() {
    setState(() {
      isAPICallProcess = true;
    });
    APIService.deleteProductImage(productModel).then((response) {
      String message = response!.message ?? '';
      if (response!.status!!) {
        clearImageCache(() {
          setState(() {
            isAPICallProcess = false;
          });
        });
        showSnackBar(context, message, kSuccessColor);
        Navigator.pushNamedAndRemoveUntil(
          context,
          kHomeRoute,
          (route) => false,
        );
      } else {
        showSnackBar(context, kWentWrongMessage, kDangerColor);
      }
      // print(response);
      // var deleteResponse = jsonDecode(response);
    }).catchError((e) {
      showSnackBar(context, kWentWrongMessage, kDangerColor);
      setState(() {
        isAPICallProcess = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productModel = ProductModel();

    // clearImageCache(() {
    //   setState(() {});
    // });
    Future.delayed(Duration.zero, () {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
        productModel = arguments["model"];
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
            title: const Text(kAddProductImage),
            elevation: 0.5,
            backgroundColor: kPrimary01,
          ),
          backgroundColor: kLoginBgColor,
          body: ProgressHUD(
            key: UniqueKey(),
            inAsyncCall: isAPICallProcess,
            opacity: kLoaderBgOpacity,
            child: SingleChildScrollView(
              child: picPicker(
                context,
                isImageSelected,
                productImage ?? '',
                (File file) {
                  setState(() {
                    productImage = file.path;
                    isImageSelected = true;
                    uploadImage();
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget picPicker(
    context,
    bool isFileSelected,
    String fileName,
    Function onFilePicked,
  ) {
    // print('------------------------------------------- = ${productModel!.id}');
    Future<XFile?> imageFile;
    // File? _croppedImage;
    ImagePicker picker = ImagePicker();

    return (productModel!.id != null)
        ? Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // fileName.isNotEmpty ?
              const SizedBox(
                height: 20,
              ),
              isFileSelected
                  ? PreviewSelectedImage(
                      fileName: fileName,
                    )
                  : CachedNetworkImage(
                      key: UniqueKey(),
                      imageUrl:
                          '${Customconfig.apiURL}/products/${productModel!.id}/image',
                      // width: MediaQuery.of(context).size.width - 40,
                      // fit: BoxFit.contain,

                      imageBuilder: (context, imageProvider) => Column(
                        children: [
                          PreviewNetworkImage(imageProvider: imageProvider),
                          const SizedBox(
                            height: 10,
                          ),
                          DeleteImageButton(
                            deleteFunction: () {
                              Navigator.of(context).pop();
                              setState(() {
                                deleteProductImage();
                              });
                            },
                          ),
                          // Expanded(
                          //   child: Container(
                          //     width: MediaQuery.of(context).size.width - 40,
                          //     decoration: BoxDecoration(
                          //       image: DecorationImage(
                          //         image: imageProvider,
                          //         fit: BoxFit.fill,
                          //       ),
                          //     ),
                          //   ),
                          // )
                          // LayoutBuilder(
                          //   builder: (context, constraints) {
                          //     return Container(
                          //       width: MediaQuery.of(context).size.width - 40,
                          //
                          //       // width: double.infinity,
                          //       height: constraints.minHeight,
                          //       decoration: BoxDecoration(
                          //         image: DecorationImage(
                          //           image: imageProvider,
                          //           fit: BoxFit.cover,
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),
                        ],
                      ),
                      // imageBuilder: (context, imageProvider) =>,
                      // fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const PreviewPlaceholderImage(
                        fileName: 'images/logo_placeholder.png',
                        isLoading: true,
                      ),
                      errorWidget: (context, url, error) =>
                          const PreviewPlaceholderImage(
                        fileName: 'images/logo_placeholder.png',
                        isLoading: false,
                      ),
                    ),

              // This is also working ----------------

              // SizedBox(
              //         child: Image.network(
              //           fileName =
              //               '${Config.apiURL}/products/${productModel!.id}/image',
              //           // height: MediaQuery.of(context).size.height/2,
              //           width: MediaQuery.of(context).size.width - 40,
              //           fit: BoxFit.contain,
              //           loadingBuilder: (BuildContext context, Widget child,
              //               ImageChunkEvent? loadingProgress) {
              //             return Column(
              //               children: [
              //                 ClipRRect(
              //                   borderRadius: BorderRadius.circular(8.0),
              //                   child: child,
              //                 ),
              //                 SizedBox(
              //                   height: 10,
              //                 ),
              //                 IconButton(
              //                   icon: const Icon(
              //                     Icons.delete,
              //                     color: kDangerColor,
              //                     size: 32,
              //                   ),
              //                   onPressed: () {
              //                     FormHelper.showSimpleAlertDialog(
              //                       context,
              //                       Config.appName,
              //                       'Do you want to delete this image ?',
              //                       "Ok",
              //                       () {
              //                         Navigator.pop(context);
              //                         setState(() {
              //                           deleteProduct();
              //                         });
              //                       },
              //                     );
              //                   },
              //                 ),
              //               ],
              //             );
              //           },
              //           errorBuilder: (context, error, stackTrace) {
              //             return Image.asset(
              //               fileName = 'images/logo_placeholder.png',
              //               // height: MediaQuery.of(context).size.height / 2,
              //               width: MediaQuery.of(context).size.width - 40,
              //               fit: BoxFit.contain,
              //             );
              //           },
              //           key: ValueKey(new Random().nextInt(100)),
              //         ),
              //       ),

              // : SizedBox(
              //     child: GestureDetector(
              //       child: Image.network(
              //         'https://www.aaronfaber.com/wp-content/uploads/2017/03/product-placeholder-wp-95907_800x675.jpg',
              //         height: 200,
              //         width: 100,
              //         fit: BoxFit.scaleDown,
              //       ),
              //       onTap: () {
              //         viewImage(
              //           context,
              //           Image.network(
              //               'https://www.aaronfaber.com/wp-content/uploads/2017/03/product-placeholder-wp-95907_800x675.jpg'),
              //         );
              //       },
              //     ),
              //   ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ImageSelector(
                    title: 'Gallary',
                    icon: Icons.image,
                    onPress: () {
                      imageFile = picker.pickImage(source: ImageSource.gallery);
                      imageFile.then(
                        (file) async {
                          File? img = File(file!.path);
                          img = await cropImage(imageFile: img);
                          if (img != null) {
                            onFilePicked(img);
                          }
                        },
                      ).catchError((err) {

                      });
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),

                  ImageSelector(
                    title: 'Camera',
                    icon: Icons.camera,
                    onPress: () {
                      imageFile = picker.pickImage(source: ImageSource.camera);
                      imageFile.then((file) async {
                        File? img = File(file!.path);
                        img = await cropImage(imageFile: img);
                        if (img != null) {
                          onFilePicked(img);
                        }
                      }).catchError((err) {

                      });
                    },
                  ),
                ],
              ),
              // SizedBox(
              //   height: 40.0,
              // ),
              // AbsorbPointer(
              //   absorbing: !isFileSelected,
              //   child: PrimaryButton(
              //     buttonTitle: 'Upload',
              //     onPress: () {
              //       uploadImage();
              //     },
              //     buttonColor: (isFileSelected) ? kPrimary01 : kSecondary02,
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Visibility(
              //   visible: !isFileSelected,
              //   child: Text(
              //     'Please select new file to upload!',
              //     // 'You can ',
              //     style: TextStyle(
              //       color: kSecondary02,
              //       fontStyle: FontStyle.italic,
              //     ),
              //   ),
              // )
            ],
          )
        : Container();
  }
}

// Reusable optimised Components-----------------

class ImageSelector extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final double size;
  final void Function() onPress;

  const ImageSelector({
    Key? key,
    required this.title,
    required this.icon,
    this.color = kPrimary01,
    this.size = 100.0,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          // color: Color(0xFFF5F5F5),
          color: kSecondary01,
          borderRadius: BorderRadius.circular(kCardDeleteRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              color: color,
              icon,
              size: kImageIconSize,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: TextStyle(color: color),
            )
          ],
        ),
      ),
    );
  }
}

class DeleteImageButton extends StatelessWidget {
  final void Function() deleteFunction;

  const DeleteImageButton({Key? key, required this.deleteFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.delete,
        color: kDangerColor,
        size: 32,
      ),
      onPressed: () {
        customDialogAlert(
          context,
          'Do you want to delete this image ?',
          'Ok',
          deleteFunction,
        );
        // FormHelper.showSimpleAlertDialog(
        //   context,
        //   Customconfig.appName,
        //   'Do you want to delete this image ?',
        //   "Ok",
        //   () {
        //     Navigator.pop(context);
        //     setState(() {
        //       deleteProduct();
        //     });
        //   },
        // );
      },
    );
  }
}

class PreviewPlaceholderImage extends StatelessWidget {
  final String fileName;
  final bool isLoading;
  const PreviewPlaceholderImage(
      {Key? key, required this.fileName, this.isLoading = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          fileName,
          // height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width - 40,
          fit: BoxFit.contain,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          (isLoading)
              ? 'Loading image please wait...'
              : 'No image available, You can upload new image!',
          style: TextStyle(
            color: (isLoading) ? kPrimary01 : kDangerColor,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class PreviewNetworkImage extends StatelessWidget {
  final ImageProvider imageProvider;
  const PreviewNetworkImage({Key? key, required this.imageProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kImageRadius),
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        child: Image(
          image: imageProvider,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class PreviewSelectedImage extends StatelessWidget {
  final String fileName;
  const PreviewSelectedImage({Key? key, required this.fileName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kImageRadius),
      child: Image.file(
        File(fileName),
        // height: MediaQuery.of(context).size.height/2,
        width: MediaQuery.of(context).size.width - 40,
        fit: BoxFit.contain,
      ),
    );
  }
}

// void viewImage(context, Image imageToView) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (_) {
//         return DetailScreen(
//           image: imageToView,
//         );
//       },
//     ),
//   );
// }
//
// class DetailScreen extends StatelessWidget {
//   final Image image;
//   const DetailScreen({Key? key, required this.image}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         child: Scaffold(
//           body: Center(
//             child: Container(
//               height: MediaQuery.of(context).size.height / 2,
//               width: MediaQuery.of(context).size.width,
//               child: image,
//             ),
//           ),
//         ),
//         onTap: () {
//           Navigator.pop(context);
//         });
//   }
// }
