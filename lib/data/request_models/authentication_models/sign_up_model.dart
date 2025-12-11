class SignUpModel {
  String? status;
  String? message;
  Response? response;

  SignUpModel({this.status, this.message, this.response});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    response = json['response'] != null
        ? Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        if (response != null) 'response': response!.toJson(),
      };
}

class Response {
  String? email;
  String? countryCode;
  int? phoneNumber;
  String? name;
  String? lastname;
  String? password;
  Location? location;
  String? city;
  bool? agreeTermsAndCondition;
  String? category;
  bool? isActive;
  bool? isDeleted;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Response({
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.name,
    this.lastname,
    this.password,
    this.location,
    this.city,
    this.agreeTermsAndCondition,
    this.category,
    this.isActive,
    this.isDeleted,
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
    lastname = json['lastname'];
    password = json['password'];
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    city = json['city'];
    agreeTermsAndCondition = json['agreeTermsAndCondition'];
    category = json['category'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'countryCode': countryCode,
        'phoneNumber': phoneNumber,
        'name': name,
        'lastname': lastname,
        'password': password,
        if (location != null) 'location': location!.toJson(),
        'city': city,
        'agreeTermsAndCondition': agreeTermsAndCondition,
        'category': category,
        'isActive': isActive,
        'isDeleted': isDeleted,
        '_id': sId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': iV,
      };
}

class Location {
  String type;
  List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? '',
      coordinates: (json['coordinates'] as List)
          .map((coord) => (coord as num).toDouble()) // Convert num to double
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'coordinates': coordinates,
  };
}