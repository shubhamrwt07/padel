class CourtsModel {
  bool? success;
  String? message;
  Data? data;

  CourtsModel({this.success, this.message, this.data});

  CourtsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  List<Courts>? courts;
  int? currentPage;
  int? totalPages;
  int? totalItems;
  int? itemsPerPage;

  Data({
    this.courts,
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.itemsPerPage,
  });

  Data.fromJson(Map<String, dynamic> json) {
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
  String? clubName;
  String? ownerId;
  int? iV;
  String? address;
  List<BusinessHours>? businessHours;
  String? city;
  int? courtCount;
  List<String>? courtImage;
  List<String>? courtName;
  List<String>? courtType;
  String? createdAt;
  String? description;
  List<String>? features;
  bool? isActive;
  bool? isDeleted;
  bool? isFeatured;
  bool? isVerified;
  Location? location;
  String? updatedAt;
  int? totalAmount;
  String? state;
  String? zipCode;

  Courts({
    this.id,
    this.clubName,
    this.ownerId,
    this.iV,
    this.address,
    this.businessHours,
    this.city,
    this.courtCount,
    this.courtImage,
    this.courtName,
    this.courtType,
    this.createdAt,
    this.description,
    this.features,
    this.isActive,
    this.isDeleted,
    this.isFeatured,
    this.isVerified,
    this.location,
    this.updatedAt,
    this.totalAmount,
    this.state,
    this.zipCode,
  });

  Courts.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    clubName = json['clubName'];
    ownerId = json['ownerId'];
    iV = json['__v'];
    address = json['address'];
    if (json['businessHours'] != null) {
      businessHours = <BusinessHours>[];
      json['businessHours'].forEach((v) {
        businessHours!.add(BusinessHours.fromJson(v));
      });
    }
    city = json['city'];
    courtCount = json['courtCount'];

    // Safe casting with null checks - handles both List and String
    courtImage = _parseStringList(json['courtImage']);
    courtName = _parseStringList(json['courtName']);
    courtType = _parseStringList(json['courtType']);

    createdAt = json['createdAt'];
    description = json['description'];

    features = _parseStringList(json['features']);

    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    isFeatured = json['isFeatured'];
    isVerified = json['isVerified'];
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    updatedAt = json['updatedAt'];
    totalAmount = json['totalAmount'];
    state = json['state'];
    zipCode = json['zipCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['clubName'] = clubName;
    data['ownerId'] = ownerId;
    data['__v'] = iV;
    data['address'] = address;
    if (businessHours != null) {
      data['businessHours'] = businessHours!.map((v) => v.toJson()).toList();
    }
    data['city'] = city;
    data['courtCount'] = courtCount;
    data['courtImage'] = courtImage;
    data['courtName'] = courtName;
    data['courtType'] = courtType;
    data['createdAt'] = createdAt;
    data['description'] = description;
    data['features'] = features;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['isFeatured'] = isFeatured;
    data['isVerified'] = isVerified;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['updatedAt'] = updatedAt;
    data['totalAmount'] = totalAmount;
    data['state'] = state;
    data['zipCode'] = zipCode;
    return data;
  }

  // Helper method to safely parse String lists from JSON
  static List<String>? _parseStringList(dynamic value) {
    if (value == null) return null;

    if (value is List) {
      return List<String>.from(value.map((x) => x?.toString() ?? ''));
    } else if (value is String) {
      return [value]; // Wrap single string in a list
    }

    return null;
  }
}

class BusinessHours {
  String? time;
  String? day;
  String? id;

  BusinessHours({this.time, this.day, this.id});

  BusinessHours.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    day = json['day'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['day'] = day;
    data['_id'] = id;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = _parseDoubleList(json['coordinates']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }

  // Helper method to safely parse double lists from JSON
  static List<double>? _parseDoubleList(dynamic value) {
    if (value == null) return null;

    if (value is List) {
      return List<double>.from(value.map((x) => x?.toDouble() ?? 0.0));
    }

    return null;
  }
}