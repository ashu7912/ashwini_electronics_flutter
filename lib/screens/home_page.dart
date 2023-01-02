import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:ashwini_electronics/eventhandler.dart';
import 'package:ashwini_electronics/constants.dart';
import 'package:ashwini_electronics/config.dart';
import 'package:ashwini_electronics/components/logout_button.dart';
import 'package:ashwini_electronics/components/rounded_textIconBox.dart';
import 'package:ashwini_electronics/components/card_components/product_item.dart';
import 'package:ashwini_electronics/components/blank_list_message.dart';
import 'package:ashwini_electronics/components/dialog_alert.dart';
import 'package:ashwini_electronics/components/primary_button.dart';

import 'package:ashwini_electronics/services/api_service.dart';
import 'package:ashwini_electronics/services/shared_servicec.dart';
import 'package:ashwini_electronics/models/product_model.dart';
import 'package:ashwini_electronics/functions/validation_functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAPICallProcess = false;
  dynamic loginDetails;
  String username = '';
  String searchString = "";
  List<ProductModel>? _allProducts = [];
  List<ProductModel>? _filteredProducts = [];
  String queryParam = '';


  // void getProductData() async {
  //   APIService apiServiceModal = APIService();
  //   var productData = await apiServiceModal.getProductList();
  //   print('I have productData ----> ${productData}');
  // }

  getUserDetails() async {
    loginDetails = await SharedService.loginDetails();
    setState(() {
      username = loginDetails!.data!.user!.name;
    });
  }

  String getQueryParams() {
    if (Provider.of<EventService>(context).isAlphabaticalSort) {
      return '${Customconfig.sortBy}title:asc';
    } else {
      if (Provider.of<EventService>(context).isAscending) {
        return '${Customconfig.sortBy}createdAt:asc';
      } else {
        return '${Customconfig.sortBy}createdAt:desc';
      }
    }
  }

  Widget loadProducts() {
    return FutureBuilder(
      future: APIService.getProducts(getQueryParams()),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>?> model) {
        if (model.hasData) {
          _allProducts = model.data;
          _filteredProducts = _allProducts;
          return (_filteredProducts!.isNotEmpty)
              ? productList()
              : const BlankListMessage();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );

  // void searchProducts() {
  //   print(searchString);
  //   List<ProductModel>? results = [];
  //   if(searchString.isEmpty) {
  //     results = _allProducts;
  //   } else {
  //     results = _allProducts?.where((ProductModel product) =>
  //     product.title!.toLowerCase().contains(searchString.toLowerCase())
  //     ).toList();
  //   }
  //   print(_allProducts);
  //
  //   setState(() {
  //     _filteredProducts = results;
  //     print(_filteredProducts);
  //   });
  //
  // }

  void deleteProduct(ProductModel model) {
    APIService.deleteProduct(model).then((response) {
      String message = response!.message ?? '';
      if (response.status!) {
        setState(() {
          showSnackBar(context, message, kDangerColor);
          Navigator.pop(context);
        });
      } else {
        showSnackBar(context, message, kDangerColor);
      }
      // print(response);
      // var deleteResponse = jsonDecode(response);
    });
  }

  String? formatDate(ProductModel item) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    // print(item!.updatedAt!);
    final String formatted = formatter.format(DateTime.parse(item.createdAt!));
    return formatted;
  }

  void toggleAscending() {
    Provider.of<EventService>(context, listen: false).toggleIsAscending();
  }

  void toggleAlphabaticSort() {
    Provider.of<EventService>(context, listen: false)
        .toggleIsAlphabaticalSort();
  }

  Widget productList() {
    double height = MediaQuery.of(context).size.height - 150;
    return Column(
      children: [

        SizedBox(
          height: height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: RoundedTextIconInput(
                      inputName: "name",
                      placeholder: "Search",
                      borderRadius: kInputBorderRadius,
                      borderColor: kPrimary01,
                      icon: Icons.search,
                      onValidateVal: (onValidateVal) {
                        return null;
                      },
                      onSavedVal: (onValidateVal) {
                        print(onValidateVal);
                      },
                      onChangeValue: (changeValue) => {
                        setState(() {
                          searchString = changeValue ?? "";
                          // searchProducts();
                        })
                      },
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: _filteredProducts!.length,
                  itemBuilder: (context, index) {
                    return _filteredProducts![index]
                            .title!
                            .toLowerCase()
                            .contains(searchString.toLowerCase())
                        ? ProductItem(
                            model: _filteredProducts![index],
                            updatedDate: formatDate(_filteredProducts![index]),
                            onDelete: (ProductModel model) {
                              customDialogAlert(
                                context,
                                kDeleteMessage(_filteredProducts![index].title),
                                'Ok',
                                () {
                                  deleteProduct(model);
                                },
                              );
                            },
                          )
                        : Container();
                  },
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: kSecondaryTextStyle,
                      children: <TextSpan>[
                        const TextSpan(text: 'Total products : '),
                        TextSpan(
                          text: '${_filteredProducts!.length}',
                          style: kCapsBoldTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: PrimaryButton(
                  buttonTitle: 'Add',
                  onPress: () {
                    Navigator.pushNamed(context, kAddProductRoute);
                  },
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10),
              //   child: RawMaterialButton(
              //     elevation: 0.3,
              //     child: Icon(
              //       Icons.add,
              //       color: kWhiteColor,
              //     ),
              //     onPressed: () {},
              //     constraints: BoxConstraints.tightFor(width: 40, height: 40),
              //     shape: CircleBorder(),
              //     fillColor: kPrimary01,
              //   ),
              // ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    // products.add(ProductModel(
    //     title: "Cable01",
    //     description: "temp description!",
    //     price: "30",
    //     count: 1,
    //     createdAt: "2022-12-08T13:53:24.001Z",
    //     updatedAt: "2022-12-08T13:53:24.001Z",
    //     id: "6391ec54be8d3da95f332f2d"));
    // getProductData();
    getUserDetails();
    clearImageCache(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                // backgroundImage: AssetImage('images/mypic.jpg'),
                radius: 18,
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: kPrimary01,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Welcome $username',
                    style: const TextStyle(fontSize: 10.0),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    kProductListTitle,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ],
          ),
          elevation: 0,
          backgroundColor: kPrimary01,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.sort_by_alpha,
                color: !(Provider.of<EventService>(context).isAlphabaticalSort)
                    ? kSecondary01
                    : kWhiteColor,
              ),
              // tooltip: 'Show Snackbar',
              onPressed: () {
                setState(() {
                  toggleAlphabaticSort();
                  // isAscending = !isAscending;
                  // (isAscending) ? querryParam = '${Config.sortBy}createdAt:asc' : querryParam = 'sortBy=createdAt:desc';
                });
                // ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text('Please add Logout here !')));
              },
            ),
            Visibility(
              visible: !(Provider.of<EventService>(context).isAlphabaticalSort),
              child: IconButton(
                icon: Icon((Provider.of<EventService>(context).isAscending)
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded),
                // tooltip: 'Show Snackbar',
                onPressed: () {
                  setState(() {
                    toggleAscending();
                    // isAscending = !isAscending;
                    // (isAscending) ? querryParam = '${Config.sortBy}createdAt:asc' : querryParam = 'sortBy=createdAt:desc';
                  });
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text('Please add Logout here !')));
                },
              ),
            ),
            // IconButton(
            //   icon: const Icon(Icons.add_box),
            //   // tooltip: 'Show Snackbar',
            //   onPressed: () {
            //     Navigator.pushNamed(context, kAddProductRoute);
            //     // ScaffoldMessenger.of(context).showSnackBar(
            //     //     const SnackBar(content: Text('Please add Logout here !')));
            //   },
            // ),
            const LogoutButton()
          ]),
      backgroundColor: kAppBgColor,
      body: loadProducts(),
      // body: ProgressHUD(
      //   child: loadProducts(),
      //   inAsyncCall: isAPICallProcess,
      //   opacity: 0.3,
      //   key: UniqueKey(),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context, kAddProductRoute);
      //   },
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add_card),
      //   backgroundColor: Color(0xff00B4BB),
      // ));
    );
  }
}
