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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    if (courts != null) {
      data['courts'] = courts!.map((v) => v.toJson()).toList();
    }
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['totalItems'] = totalItems;
    data['itemsPerPage'] = itemsPerPage;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['ownerId'] = ownerId;
    data['clubName'] = clubName;
    data['courtType'] = courtType;
    data['courtImage'] = courtImage;
    data['courtCount'] = courtCount;
    data['businessHours'] = businessHours;
    data['description'] = description;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['city'] = city;
    data['address'] = address;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['isVerified'] = isVerified;
    data['isFeatured'] = isFeatured;
    data['features'] = features;
    data['publicHolidayStatus'] = publicHolidayStatus;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['totalAmount'] = totalAmount;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}
