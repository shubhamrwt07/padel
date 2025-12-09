class CreateUserForOpenMatchModel {
  String? status;
  String? message;
  Response? response;

  CreateUserForOpenMatchModel({
    this.status,
    this.message,
    this.response,
  });

  CreateUserForOpenMatchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    response = json['response'] != null
        ? Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (response != null) 'response': response!.toJson(),
    };
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

  Response({
    this.location,
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
    this.iV,
  });

  Response.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? Location.fromJson(json['location'])
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
        ? List<String>.from(json['fcmTokens'])
        : null;

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    return {
      if (location != null) 'location': location!.toJson(),
      '_id': sId,
      'email': email,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'name': name,
      'lastName': lastName,
      'gender': gender,
      'category': category,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'role': role,
      'level': level,
      if (fcmTokens != null) 'fcmTokens': fcmTokens,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
    };
  }
}

class Location {
  List<double>? coordinates;

  Location({this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'] != null
        ? List<double>.from(
            json['coordinates'].map((v) => (v as num).toDouble()),
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      if (coordinates != null) 'coordinates': coordinates,
    };
  }
}
