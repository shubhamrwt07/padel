class GetPlayersLevelModel {
  final String? message;
  final int? status;
  final bool? error;
  final List<GetPlayersLevelData>? data;

  GetPlayersLevelModel({
    this.message,
    this.status,
    this.error,
    this.data,
  });

  factory GetPlayersLevelModel.fromJson(Map<String, dynamic> json) {
    return GetPlayersLevelModel(
      message: json['message'],
      status: json['status'],
      error: json['error'],
      data: (json['data'] as List?)
          ?.map((e) => GetPlayersLevelData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'status': status,
    'error': error,
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class GetPlayersLevelData {
  final String? id;
  final String? type;
  final List<LevelIds>? levelIds;

  GetPlayersLevelData({this.id, this.type, this.levelIds});

  factory GetPlayersLevelData.fromJson(Map<String, dynamic> json) {
    return GetPlayersLevelData(
      id: json['_id'],
      type: json['type'],
      levelIds: (json['levelIds'] as List?)
          ?.map((e) => LevelIds.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'type': type,
    'levelIds': levelIds?.map((e) => e.toJson()).toList(),
  };
}

class LevelIds {
  final String? id;
  final String? question;
  final String? code;
  final List<String>? skillLevels;
  final bool? isActive;
  final int? v;
  final String? createdAt;
  final String? updatedAt;

  LevelIds({
    this.id,
    this.question,
    this.code,
    this.skillLevels,
    this.isActive,
    this.v,
    this.createdAt,
    this.updatedAt,
  });

  factory LevelIds.fromJson(Map<String, dynamic> json) {
    return LevelIds(
      id: json['_id'],
      question: json['question'],
      code: json['code'],
      skillLevels: (json['skillLevels'] as List?)?.cast<String>(),
      isActive: json['isActive'],
      v: json['__v'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'question': question,
    'code': code,
    'skillLevels': skillLevels,
    'isActive': isActive,
    '__v': v,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
