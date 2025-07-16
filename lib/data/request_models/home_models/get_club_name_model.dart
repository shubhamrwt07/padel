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
  List<BusinessHours>? businessHours;
  String? description;
  Location? location;
  String? city;
  String? address;
  bool? isActive;
  bool? isDeleted;
  bool? isVerified;
  bool? isFeatured;
  List<String>? features;
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
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.totalAmount});

  Courts.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    ownerId = json['ownerId'];
    clubName = json['clubName'];
    courtType = json['courtType'];

    // Safely cast to List<String> or wrap single String in a List
    var imageData = json['courtImage'];
    if (imageData is List) {
      courtImage = imageData.cast<String>();
    } else if (imageData is String) {
      courtImage = [imageData];
    } else {
      courtImage = [];
    }

    courtCount = json['courtCount'];

    // Ensure businessHours is a list before iterating
    if (json['businessHours'] is List) {
      businessHours = (json['businessHours'] as List)
          .map((v) => BusinessHours.fromJson(v))
          .toList();
    } else {
      businessHours = [];
    }

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

    // Safely cast to List<String> or wrap single String in a List
    var featuresData = json['features'];
    if (featuresData is List) {
      features = featuresData.cast<String>();
    } else if (featuresData is String) {
      features = [featuresData];
    } else {
      features = [];
    }

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    totalAmount = json['totalAmount'];
  }
  ///
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['ownerId'] = ownerId;
    data['clubName'] = clubName;
    data['courtType'] = courtType;
    data['courtImage'] = courtImage;
    data['courtCount'] = courtCount;
    if (businessHours != null) {
      data['businessHours'] =
          businessHours!.map((v) => v.toJson()).toList();
    }
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
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['totalAmount'] = totalAmount;
    return data;
  }
}

class BusinessHours {
  String? time;
  String? day;
  String? sId;

  BusinessHours({this.time, this.day, this.sId});

  BusinessHours.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    day = json['day'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['day'] = day;
    data['_id'] = sId;
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