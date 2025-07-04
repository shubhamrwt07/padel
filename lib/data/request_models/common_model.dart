class CommonModel {
  String? status;
  String? message;

  CommonModel({this.status, this.message});

  CommonModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }


}
