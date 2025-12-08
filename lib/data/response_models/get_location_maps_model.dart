class GetLocationMapsModel {
  String? message;
  int? status;
  bool? error;
  Data? data;

  GetLocationMapsModel({
    this.message,
    this.status,
    this.error,
    this.data,
  });

  GetLocationMapsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'error': error,
      'data': data?.toJson(),
    };
  }
}

class Data {
  String? address;
  String? mapUrl;
  String? directLink;

  Data({
    this.address,
    this.mapUrl,
    this.directLink,
  });

  Data.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    mapUrl = json['mapUrl'];
    directLink = json['directLink'];
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'mapUrl': mapUrl,
      'directLink': directLink,
    };
  }
}