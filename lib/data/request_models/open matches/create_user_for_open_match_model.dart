class CreateUserForOpenMatchModel {
  String? status;
  String? message;
  Response? response;

  CreateUserForOpenMatchModel({this.status, this.message, this.response});

  CreateUserForOpenMatchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    response =
    json['response'] != null ? Response.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}

class Response {
  String? email;
  String? countryCode;
  int? phoneNumber;
  String? name;
  String? gender;
  Location? location;
  String? category;
  bool? isActive;
  bool? isDeleted;
  String? role;
  String? level;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Response({
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.name,
    this.gender,
    this.location,
    this.category,
    this.isActive,
    this.isDeleted,
    this.role,
    this.level,
    this.sId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Response.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    name = json['name'];
    gender = json['gender'];
    location =
    json['location'] != null ? Location.fromJson(json['location']) : null;
    category = json['category'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    role = json['role'];
    level = json['level'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['email'] = email;
    data['countryCode'] = countryCode;
    data['phoneNumber'] = phoneNumber;
    data['name'] = name;
    data['gender'] = gender;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['category'] = category;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['role'] = role;
    data['level'] = level;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Location {
  List<double>? coordinates;

  Location({this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    if (json['coordinates'] != null) {
      coordinates = List<double>.from(json['coordinates'].map((v) => v.toDouble()));
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (coordinates != null) {
      data['coordinates'] = coordinates;
    }
    return data;
  }
}
