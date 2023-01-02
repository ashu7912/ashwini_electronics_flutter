class ProductAddEditResponseModel {
  bool? status;
  String? message;
  Data? data;

  ProductAddEditResponseModel({this.status, this.message, this.data});

  ProductAddEditResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? title;
  String? description;
  String? buyingPrice;
  String? sellingPrice;
  int? count;
  String? owner;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? id;

  Data(
      {this.title,
        this.description,
        this.buyingPrice,
        this.sellingPrice,
        this.count,
        this.owner,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    buyingPrice = json['buyingPrice'];
    sellingPrice = json['sellingPrice'];
    count = json['count'];
    owner = json['owner'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['buyingPrice'] = this.buyingPrice;
    data['sellingPrice'] = this.sellingPrice;
    data['count'] = this.count;
    data['owner'] = this.owner;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}