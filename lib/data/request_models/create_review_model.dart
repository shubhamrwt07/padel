class CreateReviewModel {
  String? message;
  Review? review;

  CreateReviewModel({this.message, this.review});

  CreateReviewModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    review =
    json['review'] != null ? new Review.fromJson(json['review']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.review != null) {
      data['review'] = this.review!.toJson();
    }
    return data;
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

  Review(
      {this.reviewRating,
        this.reviewComment,
        this.userId,
        this.registerClubId,
        this.isActive,
        this.isDeleted,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reviewRating'] = this.reviewRating;
    data['reviewComment'] = this.reviewComment;
    data['userId'] = this.userId;
    data['register_club_id'] = this.registerClubId;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
