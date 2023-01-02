
class LoginRequestModel {
  late final String email;
  late final String password;

  LoginRequestModel({required this.email, required this.password});

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = this.email;
    _data['password'] = this.password;
    return _data;
  }
}