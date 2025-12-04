class ProfileModel {
  String? status;
  String? message;
  Response? response;
  bool? existsOpenMatchData;

  ProfileModel({this.status, this.message, this.response,this.existsOpenMatchData});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    existsOpenMatchData = json['existsOpenMatchData'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    data['existsOpenMatchData'] = this.existsOpenMatchData;
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
  String? password;
  String? city;
  bool? agreeTermsAndCondition;
  String? category;
  bool? isActive;
  bool? isDeleted;
  String? role;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? dob;
  String? gender;
  String? profilePic;
  String? playerLevel;
  String? level;

  Response(
      {this.location,
        this.sId,
        this.email,
        this.countryCode,
        this.phoneNumber,
        this.name,
        this.lastName,
        this.password,
        this.city,
        this.agreeTermsAndCondition,
        this.category,
        this.isActive,
        this.isDeleted,
        this.role,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.dob,
        this.gender,
        this.profilePic,
        this.playerLevel,this.level});

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
    password = json['password'];
    city = json['city'];
    agreeTermsAndCondition = json['agreeTermsAndCondition'];
    category = json['category'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    role = json['role'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    dob = json['dob'];
    gender = json['gender'];
    profilePic = json['profilePic'];
    playerLevel = json['playerLevel'];
    level = json['level'];
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
    data['password'] = this.password;
    data['city'] = this.city;
    data['agreeTermsAndCondition'] = this.agreeTermsAndCondition;
    data['category'] = this.category;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['role'] = this.role;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['profilePic'] = this.profilePic;
    data['playerLevel'] = this.playerLevel;
    data['level'] = this.level;
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}
