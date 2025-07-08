class UpdateProfileModel {
  final String status;
  final String message;
  final UserResponse response;

  UpdateProfileModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      status: json['status'],
      message: json['message'],
      response: UserResponse.fromJson(json['response']),
    );
  }
}

class UserResponse {
  final Location location;
  final String id;
  final String email;
  final String countryCode;
  final int phoneNumber;
  final String password;
  final String city;
  final bool agreeTermsAndCondition;
  final String category;
  final String createdAt;
  final String updatedAt;
  final int v;
  final String name;
  final String dob;
  final String gender;

  UserResponse({
    required this.location,
    required this.id,
    required this.email,
    required this.countryCode,
    required this.phoneNumber,
    required this.password,
    required this.city,
    required this.agreeTermsAndCondition,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.name,
    required this.dob,
    required this.gender,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      location: Location.fromJson(json['location']),
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
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );
  }
}
