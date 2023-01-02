import 'dart:convert';

import 'package:ashwini_electronics/models/login_request_model.dart';
import 'package:ashwini_electronics/models/login_response_model.dart';
import 'package:ashwini_electronics/models/product_model.dart';
import 'package:ashwini_electronics/models/register_request_model.dart';
import 'package:ashwini_electronics/models/register_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:ashwini_electronics/config.dart';
import 'package:ashwini_electronics/services/shared_servicec.dart';
import 'package:ashwini_electronics/models/delete_response_model.dart';
import 'package:ashwini_electronics/models/productAddEdit_response_model.dart';

class APIService {
  static var client = http.Client();

  static Future<LoginResponseModel?> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.parse(Customconfig.apiURL+Customconfig.loginAPI);
    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    var loginResponse = loginResponseJson(response.body);
    if (response.statusCode == 200) {
      await SharedService.setLoginDetails(loginResponse);
      return loginResponse;
    } else {
      return null;
    }
  }


  static Future<RegisterResponseModel?> register(RegisterRequestModel model) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.parse(Customconfig.apiURL+Customconfig.registerAPI);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    var registerResponse = registerResponseModel(response.body);
    if (response.statusCode == 201) {
      return registerResponse;
    } else {
      return null;
    }
  }

   Future<String> getProductList() async {

    var loginDetails = await SharedService.loginDetails();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.data!.token}'
    };

    var url = Uri.parse(Customconfig.apiURL+Customconfig.getProductsAPI);
    var response = await client.get(url,
        headers: requestHeaders
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "";
    }
  }

  static Future<List<ProductModel>?> getProducts(String filterQuery) async {
    var loginDetails = await SharedService.loginDetails();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.data!.token}'
    };
    var url = Uri.parse(Customconfig.apiURL+Customconfig.getProductsAPI+'?'+filterQuery);
    var response = await client.get(url,
        headers: requestHeaders
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // print('Product List ${response.body}');
      return productFromJson(data["data"]);
    } else {
      return null;
    }
  }

  static Future<ProductAddEditResponseModel?> saveProduct(ProductModel model) async {
    var loginDetails = await SharedService.loginDetails();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.data!.token}'
    };
    var url = Uri.parse(Customconfig.apiURL+Customconfig.addProductAPI);
    var response = await client.post(url,
        headers: requestHeaders,
        body: jsonEncode(model)
    );
    var addProductResponse = ProductAddEditResponseModel.fromJson(json.decode(response.body));
    if (response.statusCode == 201) {
      return addProductResponse;
    } else {
      return null;
    }
  }

  static Future<ProductAddEditResponseModel?> updateProduct(ProductModel model) async {
    var loginDetails = await SharedService.loginDetails();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.data!.token}'
    };
    var url = Uri.parse(Customconfig.apiURL+Customconfig.updateProductAPI+'/'+model.id!!);
    var response = await client.patch(url,
        headers: requestHeaders,
        body: jsonEncode({
          "title": model.title,
          "buyingPrice": model.buyingPrice,
          "sellingPrice": model.sellingPrice,
          "count": model.count,
          "description": model.description
        })
    );
    var updateProductResponse = ProductAddEditResponseModel.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      return updateProductResponse;
    } else {
      return null;
    }
  }


  static Future<DeleteResponseModel?> deleteProduct(
      ProductModel model
      ) async {
    var loginDetails = await SharedService.loginDetails();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.data!.token}'
    };
    var url = Uri.parse(Customconfig.apiURL+Customconfig.deleteProductAPI+'/'+model.id!!);
    var response = await client.delete(url,
        headers: requestHeaders
    );
    var deleteResponse = DeleteResponseModel.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      return deleteResponse;
    } else {
      return null;
    }
  }

  static Future<DeleteResponseModel?> deleteProductImage(
      ProductModel model
      ) async {
    var loginDetails = await SharedService.loginDetails();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.data!.token}'
    };
    var url = Uri.parse(Customconfig.apiURL+'/products/${model.id!!}/image');
    var response = await client.delete(url,
        headers: requestHeaders
    );
    var deleteResponse = DeleteResponseModel.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      return deleteResponse;
    } else {
      return null;
    }
  }

  static Future<bool> uploadProductImage(
      String productId, String productImage
      ) async {
    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer ${loginDetails!.data!.token}'
    };
    var url = Uri.parse(Customconfig.apiURL+'/products/$productId/image');
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(requestHeaders);
    if(productImage!='') {
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath('product_image', productImage);
      request.files.add(multipartFile);
    }
    var response = await request.send();
    // var deleteResponse = DeleteResponseModel.fromJson(json.decode(response.stream.bytesToString().toString()));
    print('-----------------------------------------------$response');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }


}
