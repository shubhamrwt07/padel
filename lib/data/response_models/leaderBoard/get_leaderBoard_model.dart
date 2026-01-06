class GetLeaderBoardModel {
  final bool? success;
  final LeaderboardData? data;

  GetLeaderBoardModel({this.success, this.data});

  factory GetLeaderBoardModel.fromJson(Map<String, dynamic> json) {
    return GetLeaderBoardModel(
      success: json['success'],
      data:
      json['data'] != null ? LeaderboardData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    if (data != null) 'data': data!.toJson(),
  };
}

class LeaderboardData {
  final List<TopThree>? topThree;
  final List<Leaderboard>? leaderboard;
  final Pagination? pagination;
  final Leaderboard? myRank;

  LeaderboardData({
    this.topThree,
    this.leaderboard,
    this.pagination,
    this.myRank,
  });

  factory LeaderboardData.fromJson(Map<String, dynamic> json) {
    return LeaderboardData(
      topThree: (json['topThree'] as List?)
          ?.map((e) => TopThree.fromJson(e))
          .toList(),
      leaderboard: (json['leaderboard'] as List?)
          ?.map((e) => Leaderboard.fromJson(e))
          .toList(),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      myRank: json['myRank'] != null
          ? Leaderboard.fromJson(json['myRank'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (topThree != null)
      'topThree': topThree!.map((e) => e.toJson()).toList(),
    if (leaderboard != null)
      'leaderboard': leaderboard!.map((e) => e.toJson()).toList(),
    if (pagination != null) 'pagination': pagination!.toJson(),
    if (myRank != null) 'myRank': myRank!.toJson(),
  };
}

class TopThree {
  final int? rank;
  final String? playerId;
  final String? name;
  final String? profilePic;
  final int? xpPoints;

  TopThree({
    this.rank,
    this.playerId,
    this.name,
    this.profilePic,
    this.xpPoints,
  });

  factory TopThree.fromJson(Map<String, dynamic> json) {
    return TopThree(
      rank: json['rank'],
      playerId: json['playerId'],
      name: json['name'],
      profilePic: json['profilePic'],
      xpPoints: json['xpPoints'],
    );
  }

  Map<String, dynamic> toJson() => {
    'rank': rank,
    'playerId': playerId,
    'name': name,
    'profilePic': profilePic,
    'xpPoints': xpPoints,
  };
}

class Leaderboard {
  final int? rank;
  final String? playerId;
  final String? name;
  final String? profilePic;
  final int? xpPoints;
  final int? wins;
  final int? matches;
  final int? losses;
  final int? currentWinStreak;
  final int? winRatio;
  final bool? isYou;

  Leaderboard({
    this.rank,
    this.playerId,
    this.name,
    this.profilePic,
    this.xpPoints,
    this.wins,
    this.matches,
    this.losses,
    this.currentWinStreak,
    this.winRatio,
    this.isYou,
  });

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    return Leaderboard(
      rank: json['rank'],
      playerId: json['playerId'],
      name: json['name'],
      profilePic: json['profilePic'],
      xpPoints: json['xpPoints'],
      wins: json['wins'],
      matches: json['matches'],
      losses: json['losses'],
      currentWinStreak: json['currentWinStreak'],
      winRatio: json['winRatio'],
      isYou: json['isYou'],
    );
  }

  Map<String, dynamic> toJson() => {
    'rank': rank,
    'playerId': playerId,
    'name': name,
    'profilePic': profilePic,
    'xpPoints': xpPoints,
    'wins': wins,
    'matches': matches,
    'losses': losses,
    'currentWinStreak': currentWinStreak,
    'winRatio': winRatio,
    'isYou': isYou,
  };
}

class Pagination {
  final int? page;
  final int? limit;
  final int? totalPlayers;
  final int? totalPages;

  Pagination({
    this.page,
    this.limit,
    this.totalPlayers,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      limit: json['limit'],
      totalPlayers: json['totalPlayers'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    'totalPlayers': totalPlayers,
    'totalPages': totalPages,
  };
}
