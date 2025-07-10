class CourtsModel {
  bool? success;
  String? message;
  CourtsData? data;

  CourtsModel({this.success, this.message, this.data});

  CourtsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? CourtsData.fromJson(json['data']) : null;
  }
}

class CourtsData {
  List<Courts>? courts;
  int? currentPage;
  int? totalPages;
  int? totalItems;
  int? itemsPerPage;

  CourtsData({
    this.courts,
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.itemsPerPage,
  });

  CourtsData.fromJson(Map<String, dynamic> json) {
    if (json['courts'] != null) {
      courts = <Courts>[];
      json['courts'].forEach((v) {
        courts!.add(Courts.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalItems = json['totalItems'];
    itemsPerPage = json['itemsPerPage'];
  }
}

class Courts {
  String? id;
  String? ownerId;
  String? clubName;
  String? courtType;
  int? courtCount;
  String? businessHours;
  String? description;
  Location? location;
  String? city;
  String? address;
  bool? isActive;
  bool? isDeleted;
  bool? isVerified;
  bool? isFeatured;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Courts({
    this.id,
    this.ownerId,
    this.clubName,
    this.courtType,
    this.courtCount,
    this.businessHours,
    this.description,
    this.location,
    this.city,
    this.address,
    this.isActive,
    this.isDeleted,
    this.isVerified,
    this.isFeatured,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Courts.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    ownerId = json['ownerId'];
    clubName = json['clubName'];
    courtType = json['courtType'];
    courtCount = json['courtCount'];
    businessHours = json['businessHours'];
    description = json['description'];
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    city = json['city'];
    address = json['address'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    isVerified = json['isVerified'];
    isFeatured = json['isFeatured'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }
}
