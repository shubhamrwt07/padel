class GetReviewModel {
  String? message;
  List<GetReviewData>? data;

  GetReviewModel({this.message, this.data});

  GetReviewModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <GetReviewData>[];
      json['data'].forEach((v) {
        data!.add(GetReviewData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetReviewData {
  String? registerClubId;
  double? averageRating;
  int? totalReviews;
  List<Reviews>? reviews;

  GetReviewData({
    this.registerClubId,
    this.averageRating,
    this.totalReviews,
    this.reviews,
  });

  GetReviewData.fromJson(Map<String, dynamic> json) {
    registerClubId = json['register_club_id'];
    averageRating = (json['averageRating'] != null)
        ? (json['averageRating'] as num).toDouble()
        : null;
    totalReviews = json['totalReviews'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['register_club_id'] = registerClubId;
    data['averageRating'] = averageRating;
    data['totalReviews'] = totalReviews;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reviews {
  String? sId;
  double? reviewRating;
  String? reviewComment;
  UserId? userId;
  String? registerClubId;
  bool? isActive;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Reviews({
    this.sId,
    this.reviewRating,
    this.reviewComment,
    this.userId,
    this.registerClubId,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Reviews.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    reviewRating = (json['reviewRating'] != null)
        ? (json['reviewRating'] as num).toDouble()
        : null;
    reviewComment = json['reviewComment'];
    userId = json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    registerClubId = json['register_club_id'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['reviewRating'] = reviewRating;
    data['reviewComment'] = reviewComment;
    if (userId != null) {
      data['userId'] = userId!.toJson();
    }
    data['register_club_id'] = registerClubId;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class UserId {
  String? sId;
  String? email;
  String? name;

  UserId({this.sId, this.email, this.name});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['email'] = email;
    data['name'] = name;
    return data;
  }
}
