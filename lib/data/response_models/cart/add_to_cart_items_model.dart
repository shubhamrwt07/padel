class AddToCartModel {
  String? message;
  Cart? cart;
  bool? isNewCart;

  AddToCartModel({this.message, this.cart, this.isNewCart});

  AddToCartModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    cart = json['cart'] != null ? new Cart.fromJson(json['cart']) : null;
    isNewCart = json['isNewCart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.cart != null) {
      data['cart'] = this.cart!.toJson();
    }
    data['isNewCart'] = this.isNewCart;
    return data;
  }
}

class Cart {
  String? userId;
  List<Slot>? slot;
  String? registerClubId;
  int? totalAmount;
  String? courtName;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Cart(
      {this.userId,
        this.slot,
        this.registerClubId,
        this.totalAmount,
        this.courtName,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Cart.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    if (json['slot'] != null) {
      slot = <Slot>[];
      json['slot'].forEach((v) {
        slot!.add(new Slot.fromJson(v));
      });
    }
    registerClubId = json['register_club_id'];
    totalAmount = json['totalAmount'];
    courtName = json['courtName'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    if (this.slot != null) {
      data['slot'] = this.slot!.map((v) => v.toJson()).toList();
    }
    data['register_club_id'] = this.registerClubId;
    data['totalAmount'] = this.totalAmount;
    data['courtName'] = this.courtName;
    data['_id'] = this.sId;
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
