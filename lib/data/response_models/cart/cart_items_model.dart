class CartItemsModel {
  int? status;
  int? count;
  String? message;
  List<CartItems>? cartItems;
  int? grandTotal;

  CartItemsModel({
    this.status,
    this.count,
    this.message,
    this.cartItems,
    this.grandTotal,
  });

  CartItemsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    message = json['message'];

    if (json['cartItems'] != null) {
      cartItems = (json['cartItems'] as List)
          .map((e) => CartItems.fromJson(e))
          .toList();
    }

    grandTotal = json['grandTotal'];
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'count': count,
        'message': message,
        'cartItems': cartItems?.map((e) => e.toJson()).toList(),
        'grandTotal': grandTotal,
      };
}

class CartItems {
  String? sId;
  String? userId;
  List<Slot>? slot;
  RegisterClubId? registerClubId;
  int? totalAmount;
  String? courtName;
  String? createdAt;
  String? updatedAt;
  int? iV;

  CartItems({
    this.sId,
    this.userId,
    this.slot,
    this.registerClubId,
    this.totalAmount,
    this.courtName,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  CartItems.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];

    if (json['slot'] != null) {
      slot = (json['slot'] as List).map((e) => Slot.fromJson(e)).toList();
    }

    registerClubId = json['register_club_id'] != null
        ? RegisterClubId.fromJson(json['register_club_id'])
        : null;

    totalAmount = json['totalAmount'];
    courtName = json['courtName'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'userId': userId,
        'slot': slot?.map((e) => e.toJson()).toList(),
        'register_club_id': registerClubId?.toJson(),
        'totalAmount': totalAmount,
        'courtName': courtName,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': iV,
      };
}

class Slot {
  List<SlotTimes>? slotTimes;
  String? sId;
  int? duration;
  int? totalTime;
  String? bookingTime;

  Slot({this.slotTimes, this.sId, this.duration, this.totalTime, this.bookingTime});

  Slot.fromJson(Map<String, dynamic> json) {
    if (json['slotTimes'] != null) {
      slotTimes =
          (json['slotTimes'] as List).map((e) => SlotTimes.fromJson(e)).toList();
    }
    sId = json['_id'];
    duration = json['duration'];
    totalTime = json['totalTime'];
    bookingTime = json['bookingTime'];
  }

  Map<String, dynamic> toJson() => {
        'slotTimes': slotTimes?.map((e) => e.toJson()).toList(),
        '_id': sId,
        'duration': duration,
        'totalTime': totalTime,
        'bookingTime': bookingTime,
      };
}

class SlotTimes {
  String? time;
  int? amount;
  String? slotId;
  String? bookingDate;
  String? sId;
  String? courtName;
  String? courtId;
  int? duration;
  int? totalTime;
  String? bookingTime;

  SlotTimes({
    this.time,
    this.amount,
    this.slotId,
    this.bookingDate,
    this.sId,
    this.courtName,
    this.courtId,
    this.duration,
    this.totalTime,
    this.bookingTime,
  });

  SlotTimes.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    amount = json['amount'];
    slotId = json['slotId'];
    bookingDate = json['bookingDate'];
    sId = json['_id'];
    courtName = json['courtName'];
    courtId = json['courtId'];
    duration = json['duration'];
    totalTime = json['totalTime'];
    bookingTime = json['bookingTime'];
  }

  Map<String, dynamic> toJson() => {
        'time': time,
        'amount': amount,
        'slotId': slotId,
        'bookingDate': bookingDate,
        '_id': sId,
        'courtName': courtName,
        'courtId': courtId,
        'duration': duration,
        'totalTime': totalTime,
        'bookingTime': bookingTime,
      };
}

class RegisterClubId {
  Location? location;
  String? sId;
  String? ownerId;
  String? clubName;
  int? iV;
  String? address;
  List<BusinessHours>? businessHours;
  String? city;
  int? courtCount;
  List<String>? courtImage;
  List<String>? courtType;
  String? createdAt;
  List<String>? features;
  bool? isActive;
  bool? isDeleted;
  bool? isFeatured;
  bool? isVerified;
  String? state;
  String? updatedAt;
  String? zipCode;
  String? description;

  RegisterClubId({
    this.location,
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
    this.state,
    this.updatedAt,
    this.zipCode,
    this.description,
  });

  RegisterClubId.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null ? Location.fromJson(json['location']) : null;

    sId = json['_id'];
    ownerId = json['ownerId'];
    clubName = json['clubName'];
    iV = json['__v'];
    address = json['address'];

    if (json['businessHours'] != null) {
      businessHours =
          (json['businessHours'] as List).map((e) => BusinessHours.fromJson(e)).toList();
    }

    city = json['city'];
    courtCount = json['courtCount'];
    courtImage = (json['courtImage'] as List?)?.cast<String>();

    final ct = json['courtType'];
    courtType = ct is List
        ? ct.whereType<String>().toList()
        : ct is String
            ? [ct]
            : null;

    createdAt = json['createdAt'];
    features = (json['features'] as List?)?.cast<String>();

    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    isFeatured = json['isFeatured'];
    isVerified = json['isVerified'];
    state = json['state'];
    updatedAt = json['updatedAt'];
    zipCode = json['zipCode'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() => {
        'location': location?.toJson(),
        '_id': sId,
        'ownerId': ownerId,
        'clubName': clubName,
        '__v': iV,
        'address': address,
        'businessHours': businessHours?.map((e) => e.toJson()).toList(),
        'city': city,
        'courtCount': courtCount,
        'courtImage': courtImage,
        'courtType': courtType,
        'createdAt': createdAt,
        'features': features,
        'isActive': isActive,
        'isDeleted': isDeleted,
        'isFeatured': isFeatured,
        'isVerified': isVerified,
        'state': state,
        'updatedAt': updatedAt,
        'zipCode': zipCode,
        'description': description,
      };
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = (json['coordinates'] as List?)?.cast<double>();
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
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

  Map<String, dynamic> toJson() => {
        'time': time,
        'day': day,
        '_id': sId,
      };
}
