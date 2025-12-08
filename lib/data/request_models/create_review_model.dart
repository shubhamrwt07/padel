class CreateReviewModel {
  String? message;
  Review? review;

  CreateReviewModel({this.message, this.review});

  CreateReviewModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    review = json['review'] != null ? Review.fromJson(json['review']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (review != null) 'review': review!.toJson(),
    };
  }
}

class Review {
  int? reviewRating;
  String? reviewComment;
  String? userId;
  String? registerClubId;
  bool? isActive;
  bool? isDeleted;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Review({
    this.reviewRating,
    this.reviewComment,
    this.userId,
    this.registerClubId,
    this.isActive,
    this.isDeleted,
    this.sId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Review.fromJson(Map<String, dynamic> json) {
    reviewRating = json['reviewRating'];
    reviewComment = json['reviewComment'];
    userId = json['userId'];
    registerClubId = json['register_club_id'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewRating': reviewRating,
      'reviewComment': reviewComment,
      'userId': userId,
      'register_club_id': registerClubId,
      'isActive': isActive,
      'isDeleted': isDeleted,
      '_id': sId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
    };
  }
}