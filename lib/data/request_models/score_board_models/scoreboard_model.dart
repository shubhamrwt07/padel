class CreateScoreBoardModel {
  int? status;
  bool? success;
  String? message;
  Data? data;

  CreateScoreBoardModel({this.status, this.success, this.message, this.data});

  CreateScoreBoardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) data['data'] = this.data!.toJson();
    return data;
  }
}

class Data {
  String? userId;
  String? bookingId;
  String? matchDate;
  String? matchTime;
  String? courtName;
  String? clubName;
  List<Teams>? teams;
  TotalScore? totalScore;
  String? matchDuration;
  String? winner;
  String? sId;
  List<dynamic>? sets; // kept as dynamic list since actual type is unknown
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data({
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
    this.sId,
    this.sets,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    bookingId = json['bookingId'];
    matchDate = json['matchDate'];
    matchTime = json['matchTime'];
    courtName = json['courtName'];
    clubName = json['clubName'];

    if (json['teams'] != null) {
      teams = List<Teams>.from(json['teams'].map((v) => Teams.fromJson(v)));
    }

    totalScore =
        json['totalScore'] != null ? TotalScore.fromJson(json['totalScore']) : null;

    matchDuration = json['matchDuration'];
    winner = json['winner'];
    sId = json['_id'];

    // since sets type is unknown, keep dynamic
    sets = json['sets'] != null ? List<dynamic>.from(json['sets']) : null;

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    data['bookingId'] = bookingId;
    data['matchDate'] = matchDate;
    data['matchTime'] = matchTime;
    data['courtName'] = courtName;
    data['clubName'] = clubName;
    if (teams != null) data['teams'] = teams!.map((v) => v.toJson()).toList();
    if (totalScore != null) data['totalScore'] = totalScore!.toJson();
    data['matchDuration'] = matchDuration;
    data['winner'] = winner;
    data['_id'] = sId;
    if (sets != null) data['sets'] = sets;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
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

    if (json['players'] != null) {
      players = List<Players>.from(json['players'].map((v) => Players.fromJson(v)));
    }

    totalWins = json['totalWins'];
    isWinner = json['isWinner'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    if (players != null) data['players'] = players!.map((v) => v.toJson()).toList();
    data['totalWins'] = totalWins;
    data['isWinner'] = isWinner;
    data['_id'] = sId;
    return data;
  }
}

class Players {
  String? playerId;
  String? sId;

  Players({this.playerId, this.sId});

  Players.fromJson(Map<String, dynamic> json) {
    playerId = json['playerId'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['playerId'] = playerId;
    data['_id'] = sId;
    return data;
  }
}

class TotalScore {
  int? teamA;
  int? teamB;

  TotalScore({this.teamA, this.teamB});

  TotalScore.fromJson(Map<String, dynamic> json) {
    teamA = json['teamA'];
    teamB = json['teamB'];
  }

  Map<String, dynamic> toJson() {
    return {
      'teamA': teamA,
      'teamB': teamB,
    };
  }
}
