class AllOpenMatches {
  String? message;
  List<MatchData>? data;

  AllOpenMatches({this.message, this.data});

  AllOpenMatches.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <MatchData>[];
      json['data'].forEach((v) {
        data!.add(MatchData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class MatchData {
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

  MatchData({
    this.sId,
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
    this.iV,
  });

  MatchData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    clubId = json['clubId'] != null ? ClubId.fromJson(json['clubId']) : null;
    if (json['slot'] != null) {
      slot = <Slot>[];
      json['slot'].forEach((v) {
        slot!.add(Slot.fromJson(v));
      });
    }
    matchType = json['matchType'];
    skillLevel = json['skillLevel'];
    skillDetails = json['skillDetails']?.cast<String>();
    matchDate = json['matchDate'];
    matchTime = json['matchTime'];
    matchStatus = json['matchStatus'];
    if (json['teamA'] != null) {
      teamA = <TeamA>[];
      json['teamA'].forEach((v) {
        teamA!.add(TeamA.fromJson(v));
      });
    }
    if (json['teamB'] != null) {
      teamB = <TeamB>[];
      json['teamB'].forEach((v) {
        teamB!.add(TeamB.fromJson(v));
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
    final Map<String, dynamic> map = {};
    map['_id'] = sId;
    if (clubId != null) {
      map['clubId'] = clubId!.toJson();
    }
    if (slot != null) {
      map['slot'] = slot!.map((v) => v.toJson()).toList();
    }
    map['matchType'] = matchType;
    map['skillLevel'] = skillLevel;
    map['skillDetails'] = skillDetails;
    map['matchDate'] = matchDate;
    map['matchTime'] = matchTime;
    map['matchStatus'] = matchStatus;
    if (teamA != null) {
      map['teamA'] = teamA!.map((v) => v.toJson()).toList();
    }
    if (teamB != null) {
      map['teamB'] = teamB!.map((v) => v.toJson()).toList();
    }
    map['createdBy'] = createdBy;
    map['gender'] = gender;
    map['status'] = status;
    map['adminStatus'] = adminStatus;
    map['isActive'] = isActive;
    map['isDeleted'] = isDeleted;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = iV;
    return map;
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
    return {
      '_id': sId,
      'clubName': clubName,
      'address': address,
    };
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
        slotTimes!.add(SlotTimes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['slotId'] = slotId;
    map['courtName'] = courtName;
    if (slotTimes != null) {
      map['slotTimes'] = slotTimes!.map((v) => v.toJson()).toList();
    }
    return map;
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
    return {
      'time': time,
      'amount': amount,
      'status': status,
      'availabilityStatus': availabilityStatus,
    };
  }
}

class TeamA {
  UserId? userId;
  String? joinedAt;
  String? sId;

  TeamA({this.userId, this.joinedAt, this.sId});

  TeamA.fromJson(Map<String, dynamic> json) {
    userId = json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    joinedAt = json['joinedAt'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (userId != null) {
      map['userId'] = userId!.toJson();
    }
    map['joinedAt'] = joinedAt;
    map['_id'] = sId;
    return map;
  }
}

class TeamB {
  UserId? userId;
  String? joinedAt;
  String? sId;

  TeamB({this.userId, this.joinedAt, this.sId});

  TeamB.fromJson(Map<String, dynamic> json) {
    userId = json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    joinedAt = json['joinedAt'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (userId != null) {
      map['userId'] = userId!.toJson();
    }
    map['joinedAt'] = joinedAt;
    map['_id'] = sId;
    return map;
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
  String? level;

  UserId({
    this.location,
    this.sId,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.name,
    this.lastname,
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
    this.level,
  });

  UserId.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    sId = json['_id'];
    email = json['email'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    name = json['name'];
    lastname = json['lastname'];
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
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (location != null) {
      map['location'] = location!.toJson();
    }
    map['_id'] = sId;
    map['email'] = email;
    map['countryCode'] = countryCode;
    map['phoneNumber'] = phoneNumber;
    map['name'] = name;
    map['lastname'] = lastname;
    map['category'] = category;
    map['isActive'] = isActive;
    map['isDeleted'] = isDeleted;
    map['role'] = role;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = iV;
    map['dob'] = dob;
    map['gender'] = gender;
    map['profilePic'] = profilePic;
    map['level'] = level;
    return map;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates']?.cast<double>();
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}
