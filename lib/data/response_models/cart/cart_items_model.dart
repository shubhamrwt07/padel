class CartItemsModel {
  int? status;
  int? count;
  String? message;
  List<CartItems>? cartItems;
  int? grandTotal;

  CartItemsModel(
      {this.status, this.count, this.message, this.cartItems, this.grandTotal});

  CartItemsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    message = json['message'];
    if (json['cartItems'] != null) {
      cartItems = <CartItems>[];
      json['cartItems'].forEach((v) {
        cartItems!.add(new CartItems.fromJson(v));
      });
    }
    grandTotal = json['grandTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['count'] = this.count;
    data['message'] = this.message;
    if (this.cartItems != null) {
      data['cartItems'] = this.cartItems!.map((v) => v.toJson()).toList();
    }
    data['grandTotal'] = this.grandTotal;
    return data;
  }
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

  CartItems(
      {this.sId,
        this.userId,
        this.slot,
        this.registerClubId,
        this.totalAmount,
        this.courtName,
        this.createdAt,
        this.updatedAt,
        this.iV});

  CartItems.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    if (json['slot'] != null) {
      slot = <Slot>[];
      json['slot'].forEach((v) {
        slot!.add(new Slot.fromJson(v));
      });
    }
    registerClubId = json['register_club_id'] != null
        ? new RegisterClubId.fromJson(json['register_club_id'])
        : null;
    totalAmount = json['totalAmount'];
    courtName = json['courtName'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    if (this.slot != null) {
      data['slot'] = this.slot!.map((v) => v.toJson()).toList();
    }
    if (this.registerClubId != null) {
      data['register_club_id'] = this.registerClubId!.toJson();
    }
    data['totalAmount'] = this.totalAmount;
    data['courtName'] = this.courtName;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Slot {
  List<SlotTimes>? slotTimes;
  String? sId;

  Slot({this.slotTimes, this.sId});

  Slot.fromJson(Map<String, dynamic> json) {
    if (json['slotTimes'] != null) {
      slotTimes = <SlotTimes>[];
      json['slotTimes'].forEach((v) {
        slotTimes!.add(new SlotTimes.fromJson(v));
      });
    }
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.slotTimes != null) {
      data['slotTimes'] = this.slotTimes!.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    return data;
  }
}

class SlotTimes {
  String? time;
  int? amount;
  String? slotId;
  String? bookingDate;
  String? sId;

  SlotTimes({this.time, this.amount, this.slotId, this.bookingDate, this.sId});

  SlotTimes.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    amount = json['amount'];
    slotId = json['slotId'];
    bookingDate = json['bookingDate'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['amount'] = this.amount;
    data['slotId'] = this.slotId;
    data['bookingDate'] = this.bookingDate;
    data['_id'] = this.sId;
    return data;
  }
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
  String? courtType;
  String? createdAt;
  List<String>? features;
  bool? isActive;
  bool? isDeleted;
  bool? isFeatured;
  bool? isVerified;
  String? state;
  String? updatedAt;
  String? zipCode;

  RegisterClubId(
      {this.location,
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
        this.zipCode});

  RegisterClubId.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    sId = json['_id'];
    ownerId = json['ownerId'];
    clubName = json['clubName'];
    iV = json['__v'];
    address = json['address'];
    if (json['businessHours'] != null) {
      businessHours = <BusinessHours>[];
      json['businessHours'].forEach((v) {
        businessHours!.add(new BusinessHours.fromJson(v));
      });
    }
    city = json['city'];
    courtCount = json['courtCount'];
    courtImage = json['courtImage'].cast<String>();
    courtType = json['courtType'];
    createdAt = json['createdAt'];
    features = json['features'].cast<String>();
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    isFeatured = json['isFeatured'];
    isVerified = json['isVerified'];
    state = json['state'];
    updatedAt = json['updatedAt'];
    zipCode = json['zipCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['_id'] = this.sId;
    data['ownerId'] = this.ownerId;
    data['clubName'] = this.clubName;
    data['__v'] = this.iV;
    data['address'] = this.address;
    if (this.businessHours != null) {
      data['businessHours'] =
          this.businessHours!.map((v) => v.toJson()).toList();
    }
    data['city'] = this.city;
    data['courtCount'] = this.courtCount;
    data['courtImage'] = this.courtImage;
    data['courtType'] = this.courtType;
    data['createdAt'] = this.createdAt;
    data['features'] = this.features;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['isFeatured'] = this.isFeatured;
    data['isVerified'] = this.isVerified;
    data['state'] = this.state;
    data['updatedAt'] = this.updatedAt;
    data['zipCode'] = this.zipCode;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['day'] = this.day;
    data['_id'] = this.sId;
    return data;
  }
}
