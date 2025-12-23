class OpenMatchModel {
  final int? status;
  final String? message;
  final List<Match>? matches;

  OpenMatchModel({this.status, this.message, this.matches});

  factory OpenMatchModel.fromJson(Map<String, dynamic> json) {
    return OpenMatchModel(
      status: json['status'],
      message: json['message'],
      matches: (json['matches'] as List?)
          ?.map((e) => Match.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'matches': matches?.map((e) => e.toJson()).toList(),
  };
}

class Match {
  final String? clubId;
  final List<Slot>? slot;
  final String? matchType;
  final String? skillLevel;
  final String? matchDate;
  final List<String>? matchTime;
  final String? matchStatus;
  final List<Team>? teamA;
  final List<Team>? teamB;
  final String? createdBy;
  final String? gender;
  final bool? status;
  final bool? adminStatus;
  final bool? isActive;
  final bool? isDeleted;
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final int? version;

  Match({
    this.clubId,
    this.slot,
    this.matchType,
    this.skillLevel,
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
    this.id,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      clubId: json['clubId'],
      slot: (json['slot'] as List?)
          ?.map((e) => Slot.fromJson(e))
          .toList(),
      matchType: json['matchType'],
      skillLevel: json['skillLevel'],
      matchDate: json['matchDate'],
      matchTime: (json['matchTime'] as List?)?.cast<String>(),
      matchStatus: json['matchStatus'],
      teamA: (json['teamA'] as List?)
          ?.map((e) => Team.fromJson(e))
          .toList(),
      teamB: (json['teamB'] as List?)
          ?.map((e) => Team.fromJson(e))
          .toList(),
      createdBy: json['createdBy'],
      gender: json['gender'],
      status: json['status'],
      adminStatus: json['adminStatus'],
      isActive: json['isActive'],
      isDeleted: json['isDeleted'],
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() => {
    'clubId': clubId,
    'slot': slot?.map((e) => e.toJson()).toList(),
    'matchType': matchType,
    'skillLevel': skillLevel,
    'matchDate': matchDate,
    'matchTime': matchTime,
    'matchStatus': matchStatus,
    'teamA': teamA?.map((e) => e.toJson()).toList(),
    'teamB': teamB?.map((e) => e.toJson()).toList(),
    'createdBy': createdBy,
    'gender': gender,
    'status': status,
    'adminStatus': adminStatus,
    'isActive': isActive,
    'isDeleted': isDeleted,
    '_id': id,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': version,
  };
}

class Slot {
  final String? slotId;
  final String? courtName;
  final String? courtId;
  final List<SlotTime>? slotTimes;

  Slot({this.slotId, this.courtName, this.courtId, this.slotTimes});

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      slotId: json['slotId'],
      courtName: json['courtName'],
      courtId: json['courtId'],
      slotTimes: (json['slotTimes'] as List?)
          ?.map((e) => SlotTime.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'slotId': slotId,
    'courtName': courtName,
    'courtId': courtId,
    'slotTimes': slotTimes?.map((e) => e.toJson()).toList(),
  };
}

class SlotTime {
  final String? time;
  final int? amount;
  final String? status;
  final String? availabilityStatus;

  SlotTime({this.time, this.amount, this.status, this.availabilityStatus});

  factory SlotTime.fromJson(Map<String, dynamic> json) {
    return SlotTime(
      time: json['time'],
      amount: json['amount'],
      status: json['status'],
      availabilityStatus: json['availabilityStatus'],
    );
  }

  Map<String, dynamic> toJson() => {
    'time': time,
    'amount': amount,
    'status': status,
    'availabilityStatus': availabilityStatus,
  };
}

class Team {
  final String? userId;
  final String? joinedAt;
  final String? id;

  Team({this.userId, this.joinedAt, this.id});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      userId: json['userId'],
      joinedAt: json['joinedAt'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'joinedAt': joinedAt,
    '_id': id,
  };
}
