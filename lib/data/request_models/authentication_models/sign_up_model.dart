class SignUpModel {
  String? status;
  String? message;
  SignUpResponse? response;

  SignUpModel({this.status, this.message, this.response});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    response = json['response'] != null
        ? new SignUpResponse.fromJson(json['response'])
        : null;
  }
}

class SignUpResponse {
  String? email;
  String? countryCode;
  int? phoneNumber;
  String? password;
  Location? location;
  String? city;
  bool? agreeTermsAndCondition;
  String? category;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SignUpResponse({
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.password,
    this.location,
    this.city,
    this.agreeTermsAndCondition,
    this.category,
    this.sId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  SignUpResponse.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    city = json['city'];
    agreeTermsAndCondition = json['agreeTermsAndCondition'];
    category = json['category'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }
}
