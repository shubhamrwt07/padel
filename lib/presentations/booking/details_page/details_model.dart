class OpenMatchDetails {
   MatchData? data;
  OpenMatchDetails(
      {
      required  this.data });
}

class MatchData {
  String? sId;
  String? clubId;
  String? clubName;
  List<Slot>? slot;
  String? matchType;
  String? skillLevel;
  List<String>? skillDetails;
  String? matchDate;
  String? matchTime;
  String? matchStatus;
  List<TeamA>? teamA;
  List<TeamB>? teamB;
  UserId? createdBy;
  String? gender;
  MatchData(
      {
        required  this.sId,
        required  this.clubId,
        required  this.clubName,
        required this.slot,
        required  this.matchType,
        required this.skillLevel,
        required  this.skillDetails,
        required  this.matchDate,
        required this.matchTime,
        required  this.matchStatus,
        this.teamA,
        this.teamB,
      });
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


class Slot {
  String? slotId;
  String? courtName;
  List<SlotTimes>? slotTimes;

  Slot({this.slotId, this.courtName, this.slotTimes});

  Slot.fromJson(Map<String, dynamic> json) {
    slotId = json['slotId'];
    courtName = json['courtName'];
    if (json['slotTimes'] != null) {
      slotTimes = <SlotTimes>[];
      json['slotTimes'].forEach((v) {
        slotTimes!.add(new SlotTimes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slotId'] = this.slotId;
    data['courtName'] = this.courtName;
    if (this.slotTimes != null) {
      data['slotTimes'] = this.slotTimes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SlotTimes {
  String? time;
  int? amount;
  String? status;
  String? availabilityStatus;

  SlotTimes({this.time, this.amount, this.status, this.availabilityStatus});

  SlotTimes.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    amount = json['amount'];
    status = json['status'];
    availabilityStatus = json['availabilityStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['availabilityStatus'] = this.availabilityStatus;
    return data;
  }
}

class TeamA {
  UserId? userId;
  String? teamId;

  TeamA({this.userId,  this.teamId});

  TeamA.fromJson(Map<String, dynamic> json) {
    userId =
    json['userId'] != null ?   UserId.fromJson(json['userId']) : null;
    teamId = json['_id'];
  }

}

class UserId {
  Location? location;
  String? sId;
  String? email;
  String? countryCode;
  int? phoneNumber;
  String? name;
  String? lastname;
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

  UserId(
      {this.location,
        this.sId,
        this.email,
        this.countryCode,
        this.phoneNumber,
        this.name,
        this.lastname,
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
        this.profilePic});

  UserId.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    sId = json['_id'];
    email = json['email'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    name = json['name'];
    lastname = json['lastname'];
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
    data['lastname'] = this.lastname;
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
    return data;
  }
}

class TeamB {
  UserId? userId;

  String? teamId;

  TeamB({this.userId, this.teamId});

  TeamB.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];

    teamId = json['_id'];
  }


}

