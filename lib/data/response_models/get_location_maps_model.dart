class GetLocationMapsModel {
  String? message;
  int? status;
  bool? error;
  Data? data;

  GetLocationMapsModel({this.message, this.status, this.error, this.data});

  GetLocationMapsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    error = json['error'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? address;
  String? mapUrl;
  String? directLink;

  Data({this.address, this.mapUrl, this.directLink});

  Data.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    mapUrl = json['mapUrl'];
    directLink = json['directLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['mapUrl'] = this.mapUrl;
    data['directLink'] = this.directLink;
    return data;
  }
}
