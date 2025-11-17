class AddGuestPlayerModel {
  final bool? success;
  final String? message;
  final Data? data;

  AddGuestPlayerModel({this.success, this.message, this.data});

  factory AddGuestPlayerModel.fromJson(Map<String, dynamic> json) =>
      AddGuestPlayerModel(
        success: json['success'],
        message: json['message'],
        data: json['data'] != null ? Data.fromJson(json['data']) : null,
      );

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    if (data != null) 'data': data!.toJson(),
  };
}

class Data {
  final TotalScore? totalScore;
  final String? id;
  final String? userId;
  final String? bookingId;
  final String? matchDate;
  final String? matchTime;
  final String? courtName;
  final String? clubName;
  final List<Teams>? teams;
  final String? matchDuration;
  final String? winner; // String? instead of Null?
  final List<dynamic>? sets; // keep dynamic since API provides unknown structure
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  Data({
    this.totalScore,
    this.id,
    this.userId,
    this.bookingId,
    this.matchDate,
    this.matchTime,
    this.courtName,
    this.clubName,
    this.teams,
    this.matchDuration,
    this.winner,
    this.sets,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalScore: json['totalScore'] != null
        ? TotalScore.fromJson(json['totalScore'])
        : null,
    id: json['_id'],
    userId: json['userId'],
    bookingId: json['bookingId'],
    matchDate: json['matchDate'],
    matchTime: json['matchTime'],
    courtName: json['courtName'],
    clubName: json['clubName'],
    teams: json['teams'] != null
        ? (json['teams'] as List)
        .map((e) => Teams.fromJson(e))
        .toList()
        : null,
    matchDuration: json['matchDuration'],
    winner: json['winner'],
    sets: json['sets'], // keep as-is
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
    v: json['__v'],
  );

  Map<String, dynamic> toJson() => {
    if (totalScore != null) 'totalScore': totalScore!.toJson(),
    '_id': id,
    'userId': userId,
    'bookingId': bookingId,
    'matchDate': matchDate,
    'matchTime': matchTime,
    'courtName': courtName,
    'clubName': clubName,
    if (teams != null)
      'teams': teams!.map((t) => t.toJson()).toList(),
    'matchDuration': matchDuration,
    'winner': winner,
    'sets': sets,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': v,
  };
}

class TotalScore {
  final int? teamA;
  final int? teamB;

  TotalScore({this.teamA, this.teamB});

  factory TotalScore.fromJson(Map<String, dynamic> json) => TotalScore(
    teamA: json['teamA'],
    teamB: json['teamB'],
  );

  Map<String, dynamic> toJson() => {
    'teamA': teamA,
    'teamB': teamB,
  };
}

class Teams {
  final String? name;
  final List<Players>? players;
  final int? totalWins;
  final bool? isWinner;
  final String? id;

  Teams({
    this.name,
    this.players,
    this.totalWins,
    this.isWinner,
    this.id,
  });

  factory Teams.fromJson(Map<String, dynamic> json) => Teams(
    name: json['name'],
    players: json['players'] != null
        ? (json['players'] as List)
        .map((e) => Players.fromJson(e))
        .toList()
        : null,
    totalWins: json['totalWins'],
    isWinner: json['isWinner'],
    id: json['_id'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    if (players != null)
      'players': players!.map((p) => p.toJson()).toList(),
    'totalWins': totalWins,
    'isWinner': isWinner,
    '_id': id,
  };
}

class Players {
  final String? playerId;
  final String? name;
  final String? id;

  Players({this.playerId, this.name, this.id});

  factory Players.fromJson(Map<String, dynamic> json) => Players(
    playerId: json['playerId'],
    name: json['name'],
    id: json['_id'],
  );

  Map<String, dynamic> toJson() => {
    'playerId': playerId,
    'name': name,
    '_id': id,
  };
}
