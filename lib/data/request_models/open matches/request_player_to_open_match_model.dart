class RequestPlayerToOpenMatchModel {
  String? message;
  Match? match;

  RequestPlayerToOpenMatchModel({this.message, this.match});

  RequestPlayerToOpenMatchModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    match = json['match'] != null ? Match.fromJson(json['match']) : null;
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'match': match?.toJson(),
  };
}

class Match {
  String? sId;
  String? clubId;
  List<Slot>? slot;
  String? matchType;
  String? skillLevel;
  List<dynamic>? skillDetails;
  String? matchDate;
  List<String>? matchTime;
  String? matchStatus;
  List<TeamA>? teamA;
  List<dynamic>? teamB;
  String? createdBy;
  String? gender;
  bool? status;
  bool? adminStatus;
  bool? isActive;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Match({
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

  Match.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    clubId = json['clubId'];

    slot = json['slot'] == null
        ? null
        : List<Slot>.from(json['slot'].map((x) => Slot.fromJson(x)));

    matchType = json['matchType'];
    skillLevel = json['skillLevel'];

    skillDetails = json['skillDetails']?.cast<dynamic>();

    matchDate = json['matchDate'];
    matchTime = json['matchTime']?.cast<String>();
    matchStatus = json['matchStatus'];

    teamA = json['teamA'] == null
        ? null
        : List<TeamA>.from(json['teamA'].map((x) => TeamA.fromJson(x)));

    teamB = json['teamB']?.cast<dynamic>();

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

  Map<String, dynamic> toJson() => {
    '_id': sId,
    'clubId': clubId,
    'slot': slot?.map((x) => x.toJson()).toList(),
    'matchType': matchType,
    'skillLevel': skillLevel,
    'skillDetails': skillDetails,
    'matchDate': matchDate,
    'matchTime': matchTime,
    'matchStatus': matchStatus,
    'teamA': teamA?.map((x) => x.toJson()).toList(),
    'teamB': teamB,
    'createdBy': createdBy,
    'gender': gender,
    'status': status,
    'adminStatus': adminStatus,
    'isActive': isActive,
    'isDeleted': isDeleted,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': iV,
  };
}

class Slot {
  String? slotId;
  String? courtName;
  String? courtId;
  List<SlotTimes>? slotTimes;

  Slot({this.slotId, this.courtName, this.courtId, this.slotTimes});

  Slot.fromJson(Map<String, dynamic> json) {
    slotId = json['slotId'];
    courtName = json['courtName'];
    courtId = json['courtId'];

    slotTimes = json['slotTimes'] == null
        ? null
        : List<SlotTimes>.from(json['slotTimes'].map((x) => SlotTimes.fromJson(x)));
  }

  Map<String, dynamic> toJson() => {
    'slotId': slotId,
    'courtName': courtName,
    'courtId': courtId,
    'slotTimes': slotTimes?.map((x) => x.toJson()).toList(),
  };
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

  Map<String, dynamic> toJson() => {
    'time': time,
    'amount': amount,
    'status': status,
    'availabilityStatus': availabilityStatus,
  };
}

class TeamA {
  String? userId;
  String? joinedAt;
  String? sId;

  TeamA({this.userId, this.joinedAt, this.sId});

  TeamA.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    joinedAt = json['joinedAt'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'joinedAt': joinedAt,
    '_id': sId,
  };
}
