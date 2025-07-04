class ResetPasswordModel {
  String? status;
  String? message;
  Response? response;

  ResetPasswordModel({this.status, this.message, this.response});

  ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    response = json['response'] != null
        ? Response.fromJson(json['response'])
        : null;
  }
}

class Response {
  Location? location;
  String? sId;
  String? email;
  String? countryCode;
  int? phoneNumber;
  String? password;
  String? city;
  bool? agreeTermsAndCondition;
  String? category;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? name;
  String? dob;
  String? gender;

  Response({
    this.location,
    this.sId,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.password,
    this.city,
    this.agreeTermsAndCondition,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.name,
    this.dob,
    this.gender,
  });

  Response.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    sId = json['_id'];
    email = json['email'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    city = json['city'];
    agreeTermsAndCondition = json['agreeTermsAndCondition'];
    category = json['category'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    name = json['name'];
    dob = json['dob'];
    gender = json['gender'];
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
