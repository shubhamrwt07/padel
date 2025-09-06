class OpenMatchModel {
  String? message;
  Match? match;

  OpenMatchModel({this.message, this.match});

  OpenMatchModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    match = json['match'] != null ? new Match.fromJson(json['match']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (match != null) {
      data['match'] = match!.toJson();
    }
    return data;
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

  Match(
      {this.clubId,
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
        this.iV});

  Match.fromJson(Map<String, dynamic> json) {
    clubId = json['clubId'];
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
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clubId'] = clubId;
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
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['joinedAt'] = joinedAt;
    data['_id'] = sId;
    return data;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['joinedAt'] = joinedAt;
    data['_id'] = sId;
    return data;
  }
}
