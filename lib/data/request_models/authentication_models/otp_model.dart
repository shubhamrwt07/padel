class OTPModel {
  String? status;
  String? message;
  String? response;

  OTPModel({this.status, this.message, this.response});

  OTPModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    response = json['response'];
  }
}
