class CreateMatchModel {
  String? message;
  Match? match;

  CreateMatchModel({this.message, this.match});

  CreateMatchModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    match = json['match'] != null ? new Match.fromJson(json['match']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.match != null) {
      data['match'] = this.match!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clubId'] = this.clubId;
    if (this.slot != null) {
      data['slot'] = this.slot!.map((v) => v.toJson()).toList();
    }
    data['matchType'] = this.matchType;
    data['skillLevel'] = this.skillLevel;
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
    data['createdBy'] = this.createdBy;
    data['gender'] = this.gender;
    data['status'] = this.status;
    data['adminStatus'] = this.adminStatus;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['joinedAt'] = this.joinedAt;
    data['_id'] = this.sId;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['joinedAt'] = this.joinedAt;
    data['_id'] = this.sId;
    return data;
  }
}
