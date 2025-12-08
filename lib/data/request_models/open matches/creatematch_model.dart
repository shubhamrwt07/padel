class CreateMatchModel {
  String? message;
  Match? match;

  CreateMatchModel({this.message, this.match});

  CreateMatchModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    match = json['match'] != null ? Match.fromJson(json['match']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (match != null) 'match': match!.toJson(),
    };
  }
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

    if (json['slot'] != null) {
      slot = [];
      json['slot'].forEach((v) => slot!.add(Slot.fromJson(v)));
    }

    matchType = json['matchType'];
    skillLevel = json['skillLevel'];
    skillDetails = json['skillDetails']?.cast<String>();
    matchDate = json['matchDate'];
    matchTime = json['matchTime'];
    matchStatus = json['matchStatus'];

    if (json['teamA'] != null) {
      teamA = [];
      json['teamA'].forEach((v) => teamA!.add(TeamA.fromJson(v)));
    }

    if (json['teamB'] != null) {
      teamB = [];
      json['teamB'].forEach((v) => teamB!.add(TeamB.fromJson(v)));
    }

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

  Map<String, dynamic> toJson() {
    return {
      'clubId': clubId,
      if (slot != null) 'slot': slot!.map((v) => v.toJson()).toList(),
      'matchType': matchType,
      'skillLevel': skillLevel,
      'skillDetails': skillDetails,
      'matchDate': matchDate,
      'matchTime': matchTime,
      'matchStatus': matchStatus,
      if (teamA != null) 'teamA': teamA!.map((v) => v.toJson()).toList(),
      if (teamB != null) 'teamB': teamB!.map((v) => v.toJson()).toList(),
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
      slotTimes = [];
      json['slotTimes'].forEach((v) => slotTimes!.add(SlotTimes.fromJson(v)));
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'slotId': slotId,
      'courtName': courtName,
      if (slotTimes != null)
        'slotTimes': slotTimes!.map((v) => v.toJson()).toList(),
    };
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
  String? userId;
  String? joinedAt;
  String? sId;

  TeamA({this.userId, this.joinedAt, this.sId});

  TeamA.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    joinedAt = json['joinedAt'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'joinedAt': joinedAt,
      '_id': sId,
    };
  }
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

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'joinedAt': joinedAt,
      '_id': sId,
    };
  }
}