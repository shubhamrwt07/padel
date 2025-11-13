
class OpenMatchBookingModel {
  bool? success;
  List<OpenMatchBookingData>? data;
  int? currentPage;
  int? totalPages;
  int? totalItems;
  int? itemsPerPage;
  bool? hasNextPage;
  bool? hasPrevPage;

  OpenMatchBookingModel(
      {this.success,
        this.data,
        this.currentPage,
        this.totalPages,
        this.totalItems,
        this.itemsPerPage,
        this.hasNextPage,
        this.hasPrevPage});

  OpenMatchBookingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];

    final dynamic dataJson = json['data'];
    if (dataJson is List) {
      data = dataJson
          .map((dynamic item) => OpenMatchBookingData.fromJson(
              Map<String, dynamic>.from(item as Map)))
          .toList();

      currentPage = json['currentPage'];
      totalPages = json['totalPages'];
      totalItems = json['totalItems'];
      itemsPerPage = json['itemsPerPage'];
      hasNextPage = json['hasNextPage'];
      hasPrevPage = json['hasPrevPage'];
    } else if (dataJson is Map<String, dynamic>) {
      final docs = dataJson['docs'];
      if (docs is List) {
        data = docs
            .map((dynamic item) => OpenMatchBookingData.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList();
      } else {
        data = <OpenMatchBookingData>[];
      }

      currentPage = dataJson['currentPage'] ?? json['currentPage'];
      totalPages = dataJson['totalPages'] ?? json['totalPages'];
      totalItems = dataJson['totalItems'] ?? json['totalItems'];
      itemsPerPage = dataJson['itemsPerPage'] ?? json['itemsPerPage'];
      hasNextPage = dataJson['hasNextPage'] ?? json['hasNextPage'];
      hasPrevPage = dataJson['hasPrevPage'] ?? json['hasPrevPage'];
    } else {
      data = <OpenMatchBookingData>[];
      currentPage = json['currentPage'];
      totalPages = json['totalPages'];
      totalItems = json['totalItems'];
      itemsPerPage = json['itemsPerPage'];
      hasNextPage = json['hasNextPage'];
      hasPrevPage = json['hasPrevPage'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['success'] = success;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    map['currentPage'] = currentPage;
    map['totalPages'] = totalPages;
    map['totalItems'] = totalItems;
    map['itemsPerPage'] = itemsPerPage;
    map['hasNextPage'] = hasNextPage;
    map['hasPrevPage'] = hasPrevPage;
    return map;
  }
}

class OpenMatchBookingData {
  String? sId;
  ClubId? clubId;
  List<Slot>? slot;
  String? matchType;
  String? skillLevel;
  String? playerLevel;
  List<String>? skillDetails;
  String? matchDate;
  String? matchTime;
  String? matchStatus;
  List<TeamA>? teamA;
  List<TeamB>? teamB;
  CreatedBy? createdBy;
  String? gender;
  bool? status;
  bool? adminStatus;
  bool? isActive;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  OpenMatchBookingData(
      {this.sId,
        this.clubId,
        this.slot,
        this.matchType,
        this.skillLevel,
        this.playerLevel,
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

  static String? _asJoinedString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is List) {
      return value.whereType<String>().join(', ').toString();
    }
    return value.toString();
  }

  OpenMatchBookingData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    clubId =
    json['clubId'] != null ? new ClubId.fromJson(json['clubId']) : null;
    if (json['slot'] != null) {
      slot = <Slot>[];
      json['slot'].forEach((v) {
        slot!.add(new Slot.fromJson(v));
      });
    }
    matchType = _asJoinedString(json['matchType']);
    skillLevel = _asJoinedString(json['skillLevel']);
    playerLevel = _asJoinedString(json['playerLevel']);
    skillDetails = json['skillDetails'] != null
        ? List<String>.from(json['skillDetails'])
        : null;
    matchDate = _asJoinedString(json['matchDate']);
    matchTime = _asJoinedString(json['matchTime']);
    matchStatus = _asJoinedString(json['matchStatus']);
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
    createdBy = json['createdBy'] != null
        ? new CreatedBy.fromJson(json['createdBy'])
        : null;
    gender = _asJoinedString(json['gender']);
    status = json['status'];
    adminStatus = json['adminStatus'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    createdAt = _asJoinedString(json['createdAt']);
    updatedAt = _asJoinedString(json['updatedAt']);
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.clubId != null) {
      data['clubId'] = this.clubId!.toJson();
    }
    if (this.slot != null) {
      data['slot'] = this.slot!.map((v) => v.toJson()).toList();
    }
    data['matchType'] = this.matchType;
    data['skillLevel'] = this.skillLevel;
    data['playerLevel'] = this.playerLevel;
    data['skillDetails'] = this.skillDetails;
    data['matchDate'] = this.matchDate;
    data['matchTime'] = this.matchTime;
    data['matchStatus'] = this.matchStatus;
    if (this.teamA != null) {
      data['teamA'] = this.teamA!.map((v) => v.toJson()).toList();
    }
    if (this.teamB != null) {
      data['teamB'] = this.teamB!.map((v) => v.toJson()).toList();
    }
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy!.toJson();
    }
    data['gender'] = this.gender;
    data['status'] = this.status;
    data['adminStatus'] = this.adminStatus;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }

  // Convenience: first player's level code (e.g., "B2").
  // Prefers Team A first player's user level, falls back to match-level playerLevel.
  String get firstPlayerLevelCode {
    final String fromTeamA = (teamA != null && teamA!.isNotEmpty)
        ? (teamA!.first.userId?.level ?? '')
        : '';
    final String source = fromTeamA.isNotEmpty
        ? fromTeamA
        : (playerLevel ?? createdBy?.level ?? skillLevel ?? '');
    return _extractLevelCode(source);
  }

  // Full text for first player's level (e.g., "B2 – Advanced Player").
  String get firstPlayerLevelText {
    final String fromTeamA = (teamA != null && teamA!.isNotEmpty)
        ? (teamA!.first.userId?.level ?? '')
        : '';
    final String source = fromTeamA.isNotEmpty
        ? fromTeamA
        : (playerLevel ?? createdBy?.level ?? skillLevel ?? '');
    return source.isNotEmpty ? source : '-';
  }

  // Level codes for both Team A players (index 0 and 1)
  String get teamAPlayer1LevelCode {
    final String value = (teamA != null && teamA!.isNotEmpty)
        ? (teamA![0].userId?.level ?? '')
        : '';
    return _extractLevelCode(value.isNotEmpty ? value : (playerLevel ?? ''));
  }

  String get teamAPlayer2LevelCode {
    final String value = (teamA != null && teamA!.length > 1)
        ? (teamA![1].userId?.level ?? '')
        : '';
    return _extractLevelCode(value);
  }

  // Level codes for both Team B players (index 0 and 1)
  String get teamBPlayer1LevelCode {
    final String value = (teamB != null && teamB!.isNotEmpty)
        ? (teamB![0].userId?.level ?? '')
        : '';
    return _extractLevelCode(value);
  }

  String get teamBPlayer2LevelCode {
    final String value = (teamB != null && teamB!.length > 1)
        ? (teamB![1].userId?.level ?? '')
        : '';
    return _extractLevelCode(value);
  }

  static String _extractLevelCode(String value) {
    if (value.isEmpty) return '-';
    // Handles formats like "B2 – Advanced Player" or "B2 - Advanced Player"
    final parts = value.split(RegExp(r"\s*[–-]\s*"));
    final code = parts.isNotEmpty ? parts.first.trim() : '';
    return code.isNotEmpty ? code : '-';
  }
}

class ClubId {
  Location? location;
  String? sId;
  String? ownerId;
  String? clubName;
  int? iV;
  String? address;
  List<BusinessHours>? businessHours;
  String? city;
  int? courtCount;
  List<String>? courtImage;
  List<String>? courtName;
  List<String>? courtType;
  String? createdAt;
  List<String>? features;
  bool? isActive;
  bool? isDeleted;
  bool? isFeatured;
  bool? isVerified;
  String? state;
  String? updatedAt;
  String? zipCode;
  String? description;

  ClubId(
      {this.location,
        this.sId,
        this.ownerId,
        this.clubName,
        this.iV,
        this.address,
        this.businessHours,
        this.city,
        this.courtCount,
        this.courtImage,
        this.courtName,
        this.courtType,
        this.createdAt,
        this.features,
        this.isActive,
        this.isDeleted,
        this.isFeatured,
        this.isVerified,
        this.state,
        this.updatedAt,
        this.zipCode,
        this.description});

  ClubId.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    sId = json['_id'];
    ownerId = json['ownerId'];
    clubName = OpenMatchBookingData._asJoinedString(json['clubName']);
    iV = json['__v'];
    address = OpenMatchBookingData._asJoinedString(json['address']);
    if (json['businessHours'] != null) {
      businessHours = <BusinessHours>[];
      json['businessHours'].forEach((v) {
        businessHours!.add(new BusinessHours.fromJson(v));
      });
    }
    city = OpenMatchBookingData._asJoinedString(json['city']);
    courtCount = json['courtCount'];
    courtImage = json['courtImage'] != null
        ? List<String>.from(json['courtImage'])
        : null;
    courtName = json['courtName'] != null
        ? List<String>.from(json['courtName'])
        : null;
    courtType = json['courtType'] != null
        ? List<String>.from(json['courtType'])
        : null;
    createdAt = OpenMatchBookingData._asJoinedString(json['createdAt']);
    features = json['features'] != null
        ? List<String>.from(json['features'])
        : null;
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    isFeatured = json['isFeatured'];
    isVerified = json['isVerified'];
    state = OpenMatchBookingData._asJoinedString(json['state']);
    updatedAt = OpenMatchBookingData._asJoinedString(json['updatedAt']);
    zipCode = OpenMatchBookingData._asJoinedString(json['zipCode']);
    description = OpenMatchBookingData._asJoinedString(json['description']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['_id'] = this.sId;
    data['ownerId'] = this.ownerId;
    data['clubName'] = this.clubName;
    data['__v'] = this.iV;
    data['address'] = this.address;
    if (this.businessHours != null) {
      data['businessHours'] =
          this.businessHours!.map((v) => v.toJson()).toList();
    }
    data['city'] = this.city;
    data['courtCount'] = this.courtCount;
    data['courtImage'] = this.courtImage;
    data['courtName'] = this.courtName;
    data['courtType'] = this.courtType;
    data['createdAt'] = this.createdAt;
    data['features'] = this.features;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['isFeatured'] = this.isFeatured;
    data['isVerified'] = this.isVerified;
    data['state'] = this.state;
    data['updatedAt'] = this.updatedAt;
    data['zipCode'] = this.zipCode;
    data['description'] = this.description;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['coordinates'] != null) {
      coordinates = (json['coordinates'] as List)
          .map((value) => (value as num).toDouble())
          .toList();
    } else {
      coordinates = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

class BusinessHours {
  String? time;
  String? day;
  String? sId;

  BusinessHours({this.time, this.day, this.sId});

  BusinessHours.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    day = json['day'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['day'] = this.day;
    data['_id'] = this.sId;
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
    final dynamic courtNameJson = json['courtName'];
    if (courtNameJson is String) {
      courtName = courtNameJson;
    } else if (courtNameJson is List) {
      // If backend sends an array of names, join them for display
      courtName = courtNameJson.whereType<String>().join(', ');
    } else {
      courtName = null;
    }
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
    final dynamic timeJson = json['time'];
    if (timeJson is String) {
      time = timeJson;
    } else if (timeJson is List) {
      time = timeJson.whereType<String>().join(', ');
    } else {
      time = timeJson?.toString();
    }
    final dynamic amountJson = json['amount'];
    if (amountJson is int) {
      amount = amountJson;
    } else if (amountJson is num) {
      amount = amountJson.toInt();
    } else if (amountJson is String) {
      amount = int.tryParse(amountJson);
    } else {
      amount = null;
    }
    status = OpenMatchBookingData._asJoinedString(json['status']);
    availabilityStatus = OpenMatchBookingData._asJoinedString(json['availabilityStatus']);
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userId != null) {
      data['userId'] = this.userId!.toJson();
    }
    data['joinedAt'] = this.joinedAt;
    data['_id'] = this.sId;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userId != null) {
      data['userId'] = this.userId!.toJson();
    }
    data['joinedAt'] = this.joinedAt;
    data['_id'] = this.sId;
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
  String? level;
  String? lastName;

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
        this.profilePic,
        this.level,
        this.lastName});

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
    level = json['level'];
    lastName = json['lastName'];
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
    data['level'] = this.level;
    data['lastName'] = this.lastName;
    return data;
  }
}



class CreatedBy {
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
  String? level;

  CreatedBy(
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
        this.profilePic,
        this.level});

  CreatedBy.fromJson(Map<String, dynamic> json) {
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
    data['level'] = this.level;
    return data;
  }
}

