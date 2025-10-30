class BookingHistoryModel {
  bool? success;
  String? message;
  List<BookingHistoryData>? data;
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  BookingHistoryModel({
    this.success,
    this.message,
    this.data,
    this.total,
    this.page,
    this.limit,
    this.totalPages,
  });

  BookingHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BookingHistoryData>[];
      json['data'].forEach((v) {
        data!.add(BookingHistoryData.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    return data;
  }
}

class BookingHistoryData {
  String? sId;
  String? userId;
  RegisterClubId? registerClubId;
  int? totalAmount;
  String? bookingDate;
  String? bookingStatus;
  String? bookingType;
  List<Slot>? slot;
  String? createdAt;
  String? ownerId;
  String? updatedAt;
  int? iV;
  dynamic customerReview;

  BookingHistoryData({
    this.sId,
    this.userId,
    this.registerClubId,
    this.totalAmount,
    this.bookingDate,
    this.bookingStatus,
    this.bookingType,
    this.slot,
    this.createdAt,
    this.ownerId,
    this.updatedAt,
    this.iV,
    this.customerReview,
  });

  BookingHistoryData.fromJson(Map<String, dynamic> json) {
    sId = json['_id']?.toString();
    userId = json['userId']?.toString();
    registerClubId = json['register_club_id'] != null
        ? RegisterClubId.fromJson(json['register_club_id'])
        : null;
    totalAmount = json['totalAmount'];
    bookingDate = json['bookingDate']?.toString();
    bookingStatus = json['bookingStatus']?.toString();
    bookingType = json['bookingType']?.toString();
    if (json['slot'] != null) {
      slot = <Slot>[];
      json['slot'].forEach((v) {
        slot!.add(Slot.fromJson(v));
      });
    }
    createdAt = json['createdAt']?.toString();
    ownerId = json['ownerId']?.toString();
    updatedAt = json['updatedAt']?.toString();
    iV = json['__v'];
    customerReview = json['customerReview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['userId'] = userId;
    if (registerClubId != null) {
      data['register_club_id'] = registerClubId!.toJson();
    }
    data['totalAmount'] = totalAmount;
    data['bookingDate'] = bookingDate;
    data['bookingStatus'] = bookingStatus;
    data['bookingType'] = bookingType;
    if (slot != null) {
      data['slot'] = slot!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['ownerId'] = ownerId;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['customerReview'] = customerReview;
    return data;
  }
}

class RegisterClubId {
  String? sId;
  String? ownerId;
  String? clubName;
  int? iV;
  String? address;
  List<BusinessHours>? businessHours;
  String? city;
  int? courtCount;
  List<String>? courtImage;
  String? courtType;
  String? createdAt;
  List<String>? features;
  bool? isActive;
  bool? isDeleted;
  bool? isFeatured;
  bool? isVerified;
  Location? location;
  String? state;
  String? updatedAt;
  String? zipCode;
  String? description;

  RegisterClubId({
    this.sId,
    this.ownerId,
    this.clubName,
    this.iV,
    this.address,
    this.businessHours,
    this.city,
    this.courtCount,
    this.courtImage,
    this.courtType,
    this.createdAt,
    this.features,
    this.isActive,
    this.isDeleted,
    this.isFeatured,
    this.isVerified,
    this.location,
    this.state,
    this.updatedAt,
    this.zipCode,
    this.description,
  });

  RegisterClubId.fromJson(Map<String, dynamic> json) {
    sId = json['_id']?.toString();
    ownerId = json['ownerId']?.toString();
    clubName = json['clubName']?.toString();
    iV = json['__v'];

    // ✅ Safe conversion for address (can be List or String)
    var addr = json['address'];
    if (addr is List) {
      address = addr.join(' ');
    } else {
      address = addr?.toString();
    }

    if (json['businessHours'] != null) {
      businessHours = <BusinessHours>[];
      json['businessHours'].forEach((v) {
        businessHours!.add(BusinessHours.fromJson(v));
      });
    }

    city = json['city']?.toString();
    courtCount = json['courtCount'];

    // ✅ Safe conversion for courtImage and features
    courtImage = json['courtImage'] != null
        ? List<String>.from(json['courtImage'].map((e) => e.toString()))
        : [];

    courtType = json['courtType']?.toString();
    createdAt = json['createdAt']?.toString();

    features = json['features'] != null
        ? List<String>.from(json['features'].map((e) => e.toString()))
        : [];

    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    isFeatured = json['isFeatured'];
    isVerified = json['isVerified'];

    location =
    json['location'] != null ? Location.fromJson(json['location']) : null;

    state = json['state']?.toString();
    updatedAt = json['updatedAt']?.toString();
    zipCode = json['zipCode']?.toString();
    description = json['description']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['ownerId'] = ownerId;
    data['clubName'] = clubName;
    data['__v'] = iV;
    data['address'] = address;
    if (businessHours != null) {
      data['businessHours'] = businessHours!.map((v) => v.toJson()).toList();
    }
    data['city'] = city;
    data['courtCount'] = courtCount;
    data['courtImage'] = courtImage;
    data['courtType'] = courtType;
    data['createdAt'] = createdAt;
    data['features'] = features;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['isFeatured'] = isFeatured;
    data['isVerified'] = isVerified;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['state'] = state;
    data['updatedAt'] = updatedAt;
    data['zipCode'] = zipCode;
    data['description'] = description;
    return data;
  }
}

class BusinessHours {
  String? time;
  String? day;
  String? sId;

  BusinessHours({this.time, this.day, this.sId});

  BusinessHours.fromJson(Map<String, dynamic> json) {
    time = json['time']?.toString();
    day = json['day']?.toString();
    sId = json['_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
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
    type = json['type']?.toString();
    if (json['coordinates'] != null) {
      coordinates = List<double>.from(
        json['coordinates'].map((e) => double.tryParse(e.toString()) ?? 0.0),
      );
    } else {
      coordinates = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class Slot {
  String? slotId;
  String? courtName;
  String? courtId;
  String? bookingDate;
  List<SlotTimes>? slotTimes;
  List<BusinessHours>? businessHours;

  Slot({
    this.slotId,
    this.courtName,
    this.courtId,
    this.bookingDate,
    this.slotTimes,
    this.businessHours,
  });

  Slot.fromJson(Map<String, dynamic> json) {
    slotId = json['slotId']?.toString();
    courtName = json['courtName']?.toString();
    courtId = json['courtId']?.toString();
    bookingDate = json['bookingDate']?.toString();

    if (json['slotTimes'] != null) {
      slotTimes = <SlotTimes>[];
      json['slotTimes'].forEach((v) {
        slotTimes!.add(SlotTimes.fromJson(v));
      });
    }

    if (json['businessHours'] != null) {
      businessHours = <BusinessHours>[];
      json['businessHours'].forEach((v) {
        businessHours!.add(BusinessHours.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['slotId'] = slotId;
    data['courtName'] = courtName;
    data['courtId'] = courtId;
    data['bookingDate'] = bookingDate;
    if (slotTimes != null) {
      data['slotTimes'] = slotTimes!.map((v) => v.toJson()).toList();
    }
    if (businessHours != null) {
      data['businessHours'] = businessHours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SlotTimes {
  String? time;
  int? amount;
  String? status;
  String? availabilityStatus;

  SlotTimes({this.time, this.amount, this.status, this.availabilityStatus});

  SlotTimes.fromJson(Map<String, dynamic> json) {
    time = json['time']?.toString();
    amount = json['amount'];
    status = json['status']?.toString();
    availabilityStatus = json['availabilityStatus']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['time'] = time;
    data['amount'] = amount;
    data['status'] = status;
    data['availabilityStatus'] = availabilityStatus;
    return data;
  }
}
