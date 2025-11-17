class GetScoreBoardModel {
  int? status;
  bool? success;
  String? message;
  List<Data>? data;

  GetScoreBoardModel({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  GetScoreBoardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? (json['data'] as List).map((e) => Data.fromJson(e)).toList()
        : null;
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'success': success,
    'message': message,
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class Data {
  String? sId;
  UserId? userId;
  BookingId? bookingId;
  String? matchDate;
  String? matchTime;
  String? courtName;
  String? clubName;
  List<Teams>? teams;
  TotalScore? totalScore;
  String? matchDuration;
  dynamic winner;                   // Winner may be string / object / null → dynamic
  List<dynamic>? sets;              // Sets can be any list → dynamic
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data({
    this.sId,
    this.userId,
    this.bookingId,
    this.matchDate,
    this.matchTime,
    this.courtName,
    this.clubName,
    this.teams,
    this.totalScore,
    this.matchDuration,
    this.winner,
    this.sets,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId =
    json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    bookingId =
    json['bookingId'] != null ? BookingId.fromJson(json['bookingId']) : null;

    matchDate = json['matchDate'];
    matchTime = json['matchTime'];
    courtName = json['courtName'];
    clubName = json['clubName'];

    teams = json['teams'] != null
        ? (json['teams'] as List).map((e) => Teams.fromJson(e)).toList()
        : null;

    totalScore = json['totalScore'] != null
        ? TotalScore.fromJson(json['totalScore'])
        : null;

    matchDuration = json['matchDuration'];
    winner = json['winner'];              // keep as-is (null/string/object)

    sets = json['sets'];                  // keep raw list

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() => {
    '_id': sId,
    'userId': userId?.toJson(),
    'bookingId': bookingId?.toJson(),
    'matchDate': matchDate,
    'matchTime': matchTime,
    'courtName': courtName,
    'clubName': clubName,
    'teams': teams?.map((e) => e.toJson()).toList(),
    'totalScore': totalScore?.toJson(),
    'matchDuration': matchDuration,
    'winner': winner,
    'sets': sets,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': iV,
  };
}

class UserId {
  String? sId;
  String? name;
  String? profilePic;

  UserId({this.sId, this.name, this.profilePic});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profilePic = json['profilePic'];
  }

  Map<String, dynamic> toJson() => {
    '_id': sId,
    'name': name,
    'profilePic': profilePic,
  };
}

class BookingId {
  String? sId;
  String? userId;
  String? registerClubId;
  int? totalAmount;
  String? bookingDate;
  String? bookingStatus;
  String? bookingType;
  String? createdAt;
  String? ownerId;
  String? updatedAt;
  int? iV;

  BookingId({
    this.sId,
    this.userId,
    this.registerClubId,
    this.totalAmount,
    this.bookingDate,
    this.bookingStatus,
    this.bookingType,
    this.createdAt,
    this.ownerId,
    this.updatedAt,
    this.iV,
  });

  BookingId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    registerClubId = json['register_club_id'];
    totalAmount = json['totalAmount'];
    bookingDate = json['bookingDate'];
    bookingStatus = json['bookingStatus'];
    bookingType = json['bookingType'];
    createdAt = json['createdAt'];
    ownerId = json['ownerId'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() => {
    '_id': sId,
    'userId': userId,
    'register_club_id': registerClubId,
    'totalAmount': totalAmount,
    'bookingDate': bookingDate,
    'bookingStatus': bookingStatus,
    'bookingType': bookingType,
    'createdAt': createdAt,
    'ownerId': ownerId,
    'updatedAt': updatedAt,
    '__v': iV,
  };
}

class Teams {
  String? name;
  List<Players>? players;
  int? totalWins;
  bool? isWinner;
  String? sId;

  Teams({
    this.name,
    this.players,
    this.totalWins,
    this.isWinner,
    this.sId,
  });

  Teams.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    players = json['players'] != null
        ? (json['players'] as List).map((e) => Players.fromJson(e)).toList()
        : null;
    totalWins = json['totalWins'];
    isWinner = json['isWinner'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'players': players?.map((e) => e.toJson()).toList(),
    'totalWins': totalWins,
    'isWinner': isWinner,
    '_id': sId,
  };
}

class Players {
  UserId? playerId;
  String? name;
  String? sId;

  Players({this.playerId, this.name, this.sId});

  Players.fromJson(Map<String, dynamic> json) {
    playerId =
    json['playerId'] != null ? UserId.fromJson(json['playerId']) : null;
    name = json['name'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() => {
    'playerId': playerId?.toJson(),
    'name': name,
    '_id': sId,
  };
}

class TotalScore {
  int? teamA;
  int? teamB;

  TotalScore({this.teamA, this.teamB});

  TotalScore.fromJson(Map<String, dynamic> json) {
    teamA = json['teamA'];
    teamB = json['teamB'];
  }

  Map<String, dynamic> toJson() => {
    'teamA': teamA,
    'teamB': teamB,
  };
}
