class LoginModel {
  String? status;
  String? message;
  LoginResponse? response;

  LoginModel({this.status, this.message, this.response});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    response = json['response'] != null
        ? LoginResponse.fromJson(json['response'])
        : null;
  }
}

class LoginResponse {
  String? token;
  User? user;
  bool? existsOpenMatchData;

  LoginResponse({this.token, this.user,this.existsOpenMatchData});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    existsOpenMatchData = json['existsOpenMatchData'];
  }
}

class User {
  Location? location;
  String? id;
  String? email;
  String? countryCode;
  int? phoneNumber;
  String? password;
  String? city;
  bool? agreeTermsAndCondition;
  String? createdAt;
  String? updatedAt;
  int? iV;

  User({
    this.location,
    this.id,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.password,
    this.city,
    this.agreeTermsAndCondition,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  User.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    id = json['_id'];
    email = json['email'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    city = json['city'];
    agreeTermsAndCondition = json['agreeTermsAndCondition'];
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
    coordinates = json['coordinates'] != null
        ? (json['coordinates'] as List)
        .map((e) => (e as num).toDouble())
        .toList()
        : null;
  }
}
