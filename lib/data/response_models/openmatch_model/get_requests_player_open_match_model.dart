class GetRequestPlayersOpenMatchModel {
  final String? message;
  final List<Requests>? requests;

  GetRequestPlayersOpenMatchModel({
    this.message,
    this.requests,
  });

  factory GetRequestPlayersOpenMatchModel.fromJson(Map<String, dynamic> json) {
    return GetRequestPlayersOpenMatchModel(
      message: json['message'],
      requests: json['requests'] != null
          ? List<Requests>.from(
          json['requests'].map((x) => Requests.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'requests': requests?.map((x) => x.toJson()).toList(),
  };
}

class Requests {
  final String? id;
  final MatchId? matchId;
  final RequesterId? requesterId;
  final String? matchCreatorId;
  final String? preferredTeam;
  final String? status;
  final String? level;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  Requests({
    this.id,
    this.matchId,
    this.requesterId,
    this.matchCreatorId,
    this.preferredTeam,
    this.status,
    this.level,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Requests.fromJson(Map<String, dynamic> json) {
    return Requests(
      id: json['_id'],
      matchId:
      json['matchId'] != null ? MatchId.fromJson(json['matchId']) : null,
      requesterId: json['requesterId'] != null
          ? RequesterId.fromJson(json['requesterId'])
          : null,
      matchCreatorId: json['matchCreatorId'],
      preferredTeam: json['preferredTeam'],
      status: json['status'],
      level: json['level'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'matchId': matchId?.toJson(),
    'requesterId': requesterId?.toJson(),
    'matchCreatorId': matchCreatorId,
    'preferredTeam': preferredTeam,
    'status': status,
    'level': level,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': v,
  };
}

class MatchId {
  final String? id;
  final String? matchDate;
  final List<String>? matchTime;
  final List<TeamA>? teamA;
  final List<TeamB>? teamB;

  MatchId({
    this.id,
    this.matchDate,
    this.matchTime,
    this.teamA,
    this.teamB,
  });

  factory MatchId.fromJson(Map<String, dynamic> json) {
    return MatchId(
      id: json['_id'],
      matchDate: json['matchDate'],
      matchTime: json['matchTime'] != null
          ? List<String>.from(json['matchTime'])
          : null,
      teamA: json['teamA'] != null
          ? List<TeamA>.from(json['teamA'].map((x) => TeamA.fromJson(x)))
          : null,
      teamB: json['teamB'] != null
          ? List<TeamB>.from(json['teamB'].map((x) => TeamB.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'matchDate': matchDate,
    'matchTime': matchTime,
    'teamA': teamA?.map((x) => x.toJson()).toList(),
    'teamB': teamB?.map((x) => x.toJson()).toList(),
  };
}

class TeamA {
  final String? userId;
  final String? joinedAt;
  final String? id;

  TeamA({
    this.userId,
    this.joinedAt,
    this.id,
  });

  factory TeamA.fromJson(Map<String, dynamic> json) {
    return TeamA(
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

class TeamB {
  final String? userId;
  final String? joinedAt;
  final String? id;

  TeamB({
    this.userId,
    this.joinedAt,
    this.id,
  });

  factory TeamB.fromJson(Map<String, dynamic> json) {
    return TeamB(
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

class RequesterId {
  final String? id;
  final String? email;
  final int? phoneNumber;
  final String? name;
  final String? profilePic;
  final String? lastName;

  RequesterId({
    this.id,
    this.email,
    this.phoneNumber,
    this.name,
    this.profilePic,
    this.lastName
  });

  factory RequesterId.fromJson(Map<String, dynamic> json) {
    return RequesterId(
      id: json['_id'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      name: json['name'],
      profilePic: json['profilePic'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'email': email,
    'phoneNumber': phoneNumber,
    'name': name,
    'profilePic': profilePic,
    'lastName': lastName,
  };
}
