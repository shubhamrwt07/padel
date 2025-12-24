class UpdateProfileModel {
  final String? status;
  final String? message;
  final UserResponse? response;

  UpdateProfileModel({
    this.status,
    this.message,
    this.response,
  });

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      status: json['status'],
      message: json['message'],
      response: json['response'] != null
          ? UserResponse.fromJson(json['response'])
          : null,
    );
  }
}

class UserResponse {
  final Location? location;
  final String? id;
  final String? email;
  final String? countryCode;
  final int? phoneNumber;
  final String? password;
  final String? city;
  final bool? agreeTermsAndCondition;
  final String? category;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final String? name;
  final String? dob;
  final String? gender;

  UserResponse({
    this.location,
    this.id,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.password,
    this.city,
    this.agreeTermsAndCondition,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.name,
    this.dob,
    this.gender,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      location:
      json['location'] != null ? Location.fromJson(json['location']) : null,
      id: json['_id'],
      email: json['email'],
      countryCode: json['countryCode'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      city: json['city'],
      agreeTermsAndCondition: json['agreeTermsAndCondition'],
      category: json['category'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      name: json['name'],
      dob: json['dob'],
      gender: json['gender'],
    );
  }
}

class Location {
  final String? type;
  final List<double>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: json['coordinates'] != null
          ? List<double>.from(
        json['coordinates'].map((x) => x.toDouble()),
      )
          : null,
    );
  }
}
