class AvailableCourtModel {
  String? status;

  bool? success;

  int? count;

  List<AvailableCourtsData>? data;

  List<String>? allSlotTimes;

  AvailableCourtModel({
    this.status,
    this.success,
    this.count,
    this.data,
    this.allSlotTimes,
  });

  AvailableCourtModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    success = json['success'];

    count = json['count'];

    if (json['data'] != null) {
      data = <AvailableCourtsData>[];

      json['data'].forEach((v) {
        data!.add(AvailableCourtsData.fromJson(v));
      });
    }

    allSlotTimes = json['allSlotTimes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['status'] = status;

    data['success'] = success;

    data['count'] = count;

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }

    data['allSlotTimes'] = allSlotTimes;

    return data;
  }
}

class AvailableCourtsData {
  String? sId;

  OwnerId? ownerId;

  List<Slot>? slot;

  RegisterClubId? registerClubId;

  int? iV;

  String? createdAt;

  String? updatedAt;

  AvailableCourtsData({
    this.sId,

    this.ownerId,

    this.slot,

    this.registerClubId,

    this.iV,

    this.createdAt,

    this.updatedAt,
  });

  AvailableCourtsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];

    ownerId = json['ownerId'] != null
        ? OwnerId.fromJson(json['ownerId'])
        : null;

    if (json['slot'] != null) {
      slot = <Slot>[];

      json['slot'].forEach((v) {
        slot!.add(Slot.fromJson(v));
      });
    }

    registerClubId = json['register_club_id'] != null
        ? RegisterClubId.fromJson(json['register_club_id'])
        : null;

    iV = json['__v'];

    createdAt = json['createdAt'];

    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['_id'] = sId;

    if (ownerId != null) {
      data['ownerId'] = ownerId!.toJson();
    }

    if (slot != null) {
      data['slot'] = slot!.map((v) => v.toJson()).toList();
    }

    if (registerClubId != null) {
      data['register_club_id'] = registerClubId!.toJson();
    }

    data['__v'] = iV;

    data['createdAt'] = createdAt;

    data['updatedAt'] = updatedAt;

    return data;
  }
}

class OwnerId {
  String? sId;

  String? email;

  OwnerId({this.sId, this.email});

  OwnerId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];

    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['_id'] = sId;

    data['email'] = email;

    return data;
  }
}

class Slot {
  List<BusinessHours>? businessHours;
  List<SlotTimes>? slotTimes;
  String? sId;

  Slot({this.businessHours, this.slotTimes, this.sId});

  Slot.fromJson(Map<String, dynamic> json) {
    if (json['businessHours'] != null) {
      businessHours = <BusinessHours>[];
      json['businessHours'].forEach((v) {
        businessHours!.add(BusinessHours.fromJson(v));
      });
    }

    if (json['slotTimes'] != null) {
      slotTimes = <SlotTimes>[];

      json['slotTimes'].forEach((v) {
        slotTimes!.add(SlotTimes.fromJson(v));
      });
    }

    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (businessHours != null) {
      data['businessHours'] = businessHours!.map((v) => v.toJson()).toList();
    }

    if (slotTimes != null) {
      data['slotTimes'] = slotTimes!.map((v) => v.toJson()).toList();
    }

    data['_id'] = sId;

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

class SlotTimes {
  String? status;

  String? time;

  int? amount;

  String? sId;

  SlotTimes({this.status, this.time, this.amount, this.sId});

  SlotTimes.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    time = json['time'];

    amount = json['amount'];

    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['status'] = status;

    data['time'] = time;

    data['amount'] = amount;

    data['_id'] = sId;

    return data;
  }
}

class RegisterClubId {
  Location? location;

  String? sId;

  String? ownerId;

  String? clubName;

  String? courtType;

  List<String>? courtImage;

  int? courtCount;

  List<BusinessHours>? businessHours;

  String? description;

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

  RegisterClubId({
    this.location,

    this.sId,

    this.ownerId,

    this.clubName,

    this.courtType,

    this.courtImage,

    this.courtCount,

    this.businessHours,

    this.description,

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
  });

  RegisterClubId.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;

    sId = json['_id'];

    ownerId = json['ownerId'];

    clubName = json['clubName'];

    courtType = json['courtType'];

    courtImage = json['courtImage'].cast<String>();

    courtCount = json['courtCount'];

    if (json['businessHours'] != null) {
      businessHours = <BusinessHours>[];

      json['businessHours'].forEach((v) {
        businessHours!.add(BusinessHours.fromJson(v));
      });
    }

    description = json['description'];

    city = json['city'];

    address = json['address'];

    isActive = json['isActive'];

    isDeleted = json['isDeleted'];

    isVerified = json['isVerified'];

    isFeatured = json['isFeatured'];

    features = json['features'].cast<String>();

    createdAt = json['createdAt'];

    updatedAt = json['updatedAt'];

    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (location != null) {
      data['location'] = location!.toJson();
    }

    data['_id'] = sId;

    data['ownerId'] = ownerId;

    data['clubName'] = clubName;

    data['courtType'] = courtType;

    data['courtImage'] = courtImage;

    data['courtCount'] = courtCount;

    if (businessHours != null) {
      data['businessHours'] = businessHours!.map((v) => v.toJson()).toList();
    }

    data['description'] = description;

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
