import 'dart:convert';

class DeleteResponseModel {
  bool? status;
  String? message;

  DeleteResponseModel({this.status, this.message});

  DeleteResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}