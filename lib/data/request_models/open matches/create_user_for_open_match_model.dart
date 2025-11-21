class CreateUserForOpenMatchModel {
  String? status;
  String? message;
  Response? response;

  CreateUserForOpenMatchModel({this.status, this.message, this.response});

  CreateUserForOpenMatchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  Location? location;
  String? sId;
  String? email;
  String? countryCode;
  int? phoneNumber;
  String? name;
  String? lastName;
  String? gender;
  String? category;
  bool? isActive;
  bool? isDeleted;
  String? role;
  String? level;
  List<String>? fcmTokens;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Response(
      {this.location,
        this.sId,
        this.email,
        this.countryCode,
        this.phoneNumber,
        this.name,
        this.lastName,
        this.gender,
        this.category,
        this.isActive,
        this.isDeleted,
        this.role,
        this.level,
        this.fcmTokens,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Response.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    sId = json['_id'];
    email = json['email'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    name = json['name'];
    lastName = json['lastName'];
    gender = json['gender'];
    category = json['category'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    role = json['role'];
    level = json['level'];
    fcmTokens = json['fcmTokens'] != null
        ? List<String>.from(json['fcmTokens'].map((v) => v.toString()))
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['countryCode'] = this.countryCode;
    data['phoneNumber'] = this.phoneNumber;
    data['name'] = this.name;
    data['lastName'] = this.lastName;
    data['gender'] = this.gender;
    data['category'] = this.category;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['role'] = this.role;
    data['level'] = this.level;
    if (this.fcmTokens != null) {
      data['fcmTokens'] = this.fcmTokens;
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Location {
  List<double>? coordinates;

  Location({this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'] != null
        ? List<double>.from(
            json['coordinates'].map((v) => (v as num).toDouble()))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates;
    }
    return data;
  }
}
