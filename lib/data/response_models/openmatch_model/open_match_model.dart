class OpenMatchModel {
  String? message;
  Match? match;

  OpenMatchModel({this.message, this.match});

  OpenMatchModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    match = json['match'] != null ? Match.fromJson(json['match']) : null;
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        if (match != null) 'match': match!.toJson(),
      };
}

class Match {
  String? clubId;
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
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Match({
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
    this.sId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Match.fromJson(Map<String, dynamic> json) {
    clubId = json['clubId'];

    slot = json['slot'] != null
        ? (json['slot'] as List).map((e) => Slot.fromJson(e)).toList()
        : null;

    matchType = json['matchType'];
    skillLevel = json['skillLevel'];

    skillDetails = (json['skillDetails'] as List?)?.cast<String>();

    matchDate = json['matchDate'];
    matchTime = json['matchTime'];
    matchStatus = json['matchStatus'];

    teamA = json['teamA'] != null
        ? (json['teamA'] as List).map((e) => TeamA.fromJson(e)).toList()
        : null;

    teamB = json['teamB'] != null
        ? (json['teamB'] as List).map((e) => TeamB.fromJson(e)).toList()
        : null;

    createdBy = json['createdBy'];
    gender = json['gender'];
    status = json['status'];
    adminStatus = json['adminStatus'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() => {
        'clubId': clubId,
        if (slot != null) 'slot': slot!.map((e) => e.toJson()).toList(),
        'matchType': matchType,
        'skillLevel': skillLevel,
        'skillDetails': skillDetails,
        'matchDate': matchDate,
        'matchTime': matchTime,
        'matchStatus': matchStatus,
        if (teamA != null) 'teamA': teamA!.map((e) => e.toJson()).toList(),
        if (teamB != null) 'teamB': teamB!.map((e) => e.toJson()).toList(),
        'createdBy': createdBy,
        'gender': gender,
        'status': status,
        'adminStatus': adminStatus,
        'isActive': isActive,
        'isDeleted': isDeleted,
        '_id': sId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': iV,
      };
}

class Slot {
  String? slotId;
  String? courtName;
  List<SlotTimes>? slotTimes;

  Slot({this.slotId, this.courtName, this.slotTimes});

  Slot.fromJson(Map<String, dynamic> json) {
    slotId = json['slotId'];
    courtName = json['courtName'];

    slotTimes = json['slotTimes'] != null
        ? (json['slotTimes'] as List).map((e) => SlotTimes.fromJson(e)).toList()
        : null;
  }

  Map<String, dynamic> toJson() => {
        'slotId': slotId,
        'courtName': courtName,
        if (slotTimes != null)
          'slotTimes': slotTimes!.map((e) => e.toJson()).toList(),
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

class TeamB {
  String? userId;
  String? joinedAt;
  String? sId;

  TeamB({this.userId, this.joinedAt, this.sId});

  TeamB.fromJson(Map<String, dynamic> json) {
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
