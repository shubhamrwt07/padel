class CourtsModel {
  bool? success;
  String? message;
  CourtsData? data;

  CourtsModel({this.success, this.message, this.data});

  CourtsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new CourtsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CourtsData {
  List<Courts>? courts;
  int? currentPage;
  int? totalPages;
  int? totalItems;
  int? itemsPerPage;

  CourtsData(
      {this.courts,
        this.currentPage,
        this.totalPages,
        this.totalItems,
        this.itemsPerPage});

  CourtsData.fromJson(Map<String, dynamic> json) {
    if (json['courts'] != null) {
      courts = <Courts>[];
      json['courts'].forEach((v) {
        courts!.add(new Courts.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalItems = json['totalItems'];
    itemsPerPage = json['itemsPerPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.courts != null) {
      data['courts'] = this.courts!.map((v) => v.toJson()).toList();
    }
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    data['totalItems'] = this.totalItems;
    data['itemsPerPage'] = this.itemsPerPage;
    return data;
  }
}

class Courts {
  String? id;
  String? ownerId;
  String? clubName;
  String? courtType;
  List<String>? courtImage;
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
  List<String>? features;
  bool? publicHolidayStatus;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? totalAmount;

  Courts(
      {this.id,
        this.ownerId,
        this.clubName,
        this.courtType,
        this.courtImage,
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
        this.features,
        this.publicHolidayStatus,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.totalAmount});

  Courts.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    ownerId = json['ownerId'];
    clubName = json['clubName'];
    courtType = json['courtType'];

    // Safely handle both List and single String
    courtImage = json['courtImage'] is List
        ? List<String>.from(json['courtImage'])
        : (json['courtImage'] != null ? [json['courtImage']] : []);

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

    // Same handling for features
    features = json['features'] is List
        ? List<String>.from(json['features'])
        : (json['features'] != null ? [json['features']] : []);

    publicHolidayStatus = json['publicHolidayStatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['ownerId'] = this.ownerId;
    data['clubName'] = this.clubName;
    data['courtType'] = this.courtType;
    data['courtImage'] = this.courtImage;
    data['courtCount'] = this.courtCount;
    data['businessHours'] = this.businessHours;
    data['description'] = this.description;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['city'] = this.city;
    data['address'] = this.address;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['isVerified'] = this.isVerified;
    data['isFeatured'] = this.isFeatured;
    data['features'] = this.features;
    data['publicHolidayStatus'] = this.publicHolidayStatus;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['totalAmount'] = this.totalAmount;
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}
