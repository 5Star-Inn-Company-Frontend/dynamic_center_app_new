class LoginModel {
  final bool status;
  final String message;

  LoginModel({required this.status, required this.message});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      status: json['status'],
      message: json['message'],
    );
  }
}