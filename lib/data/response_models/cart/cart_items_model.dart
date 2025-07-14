class CartItemsModel {
  String? message;
  List<CartItems>? cartItems;

  CartItemsModel({this.message, this.cartItems});

  CartItemsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['cartItems'] != null) {
      cartItems = <CartItems>[];
      json['cartItems'].forEach((v) {
        cartItems!.add(new CartItems.fromJson(v));
      });
    }
  }
}

class CartItems {
  String? id;
  String? userId;
  List<CourtData>? courtNames;
  RegisterClubId? registerClubId;
  int? totalAmount;
  int? iV;
  String? createdAt;
  String? updatedAt;

  CartItems({
    this.id,
    this.userId,
    this.courtNames,
    this.registerClubId,
    this.totalAmount,
    this.iV,
    this.createdAt,
    this.updatedAt,
  });

  CartItems.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    if (json['courtNames'] != null) {
      courtNames = <CourtData>[];
      json['courtNames'].forEach((v) {
        courtNames!.add(new CourtData.fromJson(v));
      });
    }
    registerClubId = json['register_club_id'] != null
        ? new RegisterClubId.fromJson(json['register_club_id'])
        : null;
    totalAmount = json['totalAmount'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}

class CourtData {
  String? name;
  String? status;
  String? courtType;
  String? courtId;
  List<SlotTimes>? slotTimes;
  String? id;

  CourtData({
    this.name,
    this.status,
    this.courtType,
    this.courtId,
    this.slotTimes,
    this.id,
  });

  CourtData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
    courtType = json['courtType'];
    courtId = json['courtId'];
    if (json['slotTimes'] != null) {
      slotTimes = <SlotTimes>[];
      json['slotTimes'].forEach((v) {
        slotTimes!.add(new SlotTimes.fromJson(v));
      });
    }
    id = json['_id'];
  }
}

class SlotTimes {
  String? status;
  String? time;
  int? amount;
  String? id;

  SlotTimes({this.status, this.time, this.amount, this.id});

  SlotTimes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
  String? businessHours;
  String? description;
  String? city;
  String? address;
  bool? isActive;
  bool? isDeleted;
  bool? isVerified;
  bool? isFeatured;
  String? features;
  String? createdAt;
  String? updatedAt;
  int? iV;

  RegisterClubId({
    this.location,
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
    this.iV,
  });

  RegisterClubId.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    id = json['_id'];
    ownerId = json['ownerId'];
    clubName = json['clubName'];
    courtType = json['courtType'];
    courtImage = json['courtImage'].cast<String>();
    courtCount = json['courtCount'];
    businessHours = json['businessHours'];
    description = json['description'];
    city = json['city'];
    address = json['address'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    isVerified = json['isVerified'];
    isFeatured = json['isFeatured'];
    features = json['features'];
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
