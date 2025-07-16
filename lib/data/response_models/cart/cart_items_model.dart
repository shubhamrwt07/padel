class CartItemsModel {
  int? status;
  String? message;
  List<CartItems>? cartItems;

  CartItemsModel({this.status, this.message, this.cartItems});

  CartItemsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['cartItems'] != null) {
      cartItems = <CartItems>[];
      json['cartItems'].forEach((v) {
        cartItems!.add(CartItems.fromJson(v));
      });
    }
  }

 
}

class CartItems {
  String? id;
  String? userId;
  List<Slot>? slot;
  RegisterClubId? registerClubId;
  int? totalAmount;
  String? createdAt;
  String? updatedAt;
  int? iV;

  CartItems(
      {this.id,
        this.userId,
        this.slot,
        this.registerClubId,
        this.totalAmount,
        this.createdAt,
        this.updatedAt,
        this.iV});

  CartItems.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    if (json['slot'] != null) {
      slot = <Slot>[];
      json['slot'].forEach((v) {
        slot!.add(Slot.fromJson(v));
      });
    }
    registerClubId = json['register_club_id'] != null
        ? RegisterClubId.fromJson(json['register_club_id'])
        : null;
    totalAmount = json['totalAmount'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
 
}

class Slot {
  String? slotId;
  List<BusinessHours>? businessHours;
  List<SlotTimes>? slotTimes;
  String? id;

  Slot({this.slotId, this.businessHours, this.slotTimes, this.id});

  Slot.fromJson(Map<String, dynamic> json) {
    slotId = json['slotId'];
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
    id = json['_id'];
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

 
}

class SlotTimes {
  String? time;
  int? amount;
  String? id;

  SlotTimes({this.time, this.amount, this.id});

  SlotTimes.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    amount = json['amount'];
    id = json['_id'];
  }

 
}

class RegisterClubId {
  Location? location;
  String? id;
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

  RegisterClubId(
      {this.location,
        this.id,
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
        this.iV});

  RegisterClubId.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    id = json['_id'];
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
