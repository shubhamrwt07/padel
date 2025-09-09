class OpenMatchDetailsModel {
  String? message;
  Data? data;

  OpenMatchDetailsModel({this.message, this.data});

  OpenMatchDetailsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  ClubId? clubId;
  List<Slot>? slot;
  String? matchType;
  String? skillLevel;
  List<String>? skillDetails;
  String? matchDate;
  String? matchTime;
  String? matchStatus;
  List<TeamA>? teamA;
  List<TeamB>? teamB;
  String? createdBy;
  String? gender;
  bool? status;
  bool? adminStatus;
  bool? isActive;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
        this.clubId,
        this.slot,
        this.matchType,
        this.skillLevel,
        this.skillDetails,
        this.matchDate,
        this.matchTime,
        this.matchStatus,
        this.teamA,
        this.teamB,
        this.createdBy,
        this.gender,
        this.status,
        this.adminStatus,
        this.isActive,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    clubId =
    json['clubId'] != null ? new ClubId.fromJson(json['clubId']) : null;
    if (json['slot'] != null) {
      slot = <Slot>[];
      json['slot'].forEach((v) {
        slot!.add(new Slot.fromJson(v));
      });
    }
    matchType = json['matchType'];
    skillLevel = json['skillLevel'];
    skillDetails = json['skillDetails'].cast<String>();
    matchDate = json['matchDate'];
    matchTime = json['matchTime'];
    matchStatus = json['matchStatus'];
    if (json['teamA'] != null) {
      teamA = <TeamA>[];
      json['teamA'].forEach((v) {
        teamA!.add(new TeamA.fromJson(v));
      });
    }
    if (json['teamB'] != null) {
      teamB = <TeamB>[];
      json['teamB'].forEach((v) {
        teamB!.add(new TeamB.fromJson(v));
      });
    }
    createdBy = json['createdBy'];
    gender = json['gender'];
    status = json['status'];
    adminStatus = json['adminStatus'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (clubId != null) {
      data['clubId'] = clubId!.toJson();
    }
    if (slot != null) {
      data['slot'] = slot!.map((v) => v.toJson()).toList();
    }
    data['matchType'] = matchType;
    data['skillLevel'] = skillLevel;
    data['skillDetails'] = skillDetails;
    data['matchDate'] = matchDate;
    data['matchTime'] = matchTime;
    data['matchStatus'] = matchStatus;
    if (teamA != null) {
      data['teamA'] = teamA!.map((v) => v.toJson()).toList();
    }
    if (teamB != null) {
      data['teamB'] = teamB!.map((v) => v.toJson()).toList();
    }
    data['createdBy'] = createdBy;
    data['gender'] = gender;
    data['status'] = status;
    data['adminStatus'] = adminStatus;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class ClubId {
  String? sId;
  String? clubName;
  String? address;

  ClubId({this.sId, this.clubName, this.address});

  ClubId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    clubName = json['clubName'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['clubName'] = clubName;
    data['address'] = address;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['slotId'] = slotId;
    data['courtName'] = courtName;
    if (slotTimes != null) {
      data['slotTimes'] = slotTimes!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['amount'] = amount;
    data['status'] = status;
    data['availabilityStatus'] = availabilityStatus;
    return data;
  }
}

class TeamA {
  UserId? userId;
  String? joinedAt;
  String? sId;

  TeamA({this.userId, this.joinedAt, this.sId});

  TeamA.fromJson(Map<String, dynamic> json) {
    userId =
    json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
    joinedAt = json['joinedAt'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userId != null) {
      data['userId'] = userId!.toJson();
    }
    data['joinedAt'] = joinedAt;
    data['_id'] = sId;
    return data;
  }
}
class TeamB {
  UserId? userId;
  String? joinedAt;
  String? sId;

  TeamB({this.userId, this.joinedAt, this.sId});

  TeamB.fromJson(Map<String, dynamic> json) {
    userId =
    json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
    joinedAt = json['joinedAt'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userId != null) {
      data['userId'] = userId!.toJson();
    }
    data['joinedAt'] = joinedAt;
    data['_id'] = sId;
    return data;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['_id'] = sId;
    data['email'] = email;
    data['countryCode'] = countryCode;
    data['phoneNumber'] = phoneNumber;
    data['name'] = name;
    data['lastname'] = lastname;
    data['password'] = password;
    data['city'] = city;
    data['agreeTermsAndCondition'] = agreeTermsAndCondition;
    data['category'] = category;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['role'] = role;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['dob'] = dob;
    data['gender'] = gender;
    data['profilePic'] = profilePic;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}




