// import 'package:flutter/material.dart';
List<ProductModel> productFromJson(dynamic str) =>
    List<ProductModel>.from((str).map((e) => ProductModel.fromJson(e)));

class ProductModel {
  String? title;
  String? description;
  String? buyingPrice;
  String? sellingPrice;
  int? count;
  String? createdAt;
  String? updatedAt;
  String? id;

  ProductModel(
      {this.title,
        this.description,
        this.buyingPrice,
        this.sellingPrice,
        this.count,
        this.createdAt,
        this.updatedAt,
        this.id});

  ProductModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    buyingPrice = json['buyingPrice'];
    sellingPrice = json['sellingPrice'];
    count = json['count'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['buyingPrice'] = this.buyingPrice;
    data['sellingPrice'] = this.sellingPrice;
    data['count'] = this.count;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['_id'] = this.id;
    return data;
  }
}