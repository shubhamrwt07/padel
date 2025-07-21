class CarteBookingModel {
  String? message;
  List<Bookings>? bookings;
  int? count;

  CarteBookingModel({this.message, this.bookings, this.count});

  CarteBookingModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['bookings'] != null) {
      bookings = <Bookings>[];
      json['bookings'].forEach((v) {
        bookings!.add(new Bookings.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.bookings != null) {
      data['bookings'] = this.bookings!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class Bookings {
  String? userId;
  String? registerClubId;
  List<Slot>? slot;
  int? totalAmount;
  String? bookingStatus;
  String? bookingDate;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Bookings(
      {this.userId,
        this.registerClubId,
        this.slot,
        this.totalAmount,
        this.bookingStatus,
        this.bookingDate,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Bookings.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    registerClubId = json['register_club_id'];
    if (json['slot'] != null) {
      slot = <Slot>[];
      json['slot'].forEach((v) {
        slot!.add(new Slot.fromJson(v));
      });
    }
    totalAmount = json['totalAmount'];
    bookingStatus = json['bookingStatus'];
    bookingDate = json['bookingDate'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['register_club_id'] = this.registerClubId;
    if (this.slot != null) {
      data['slot'] = this.slot!.map((v) => v.toJson()).toList();
    }
    data['totalAmount'] = this.totalAmount;
    data['bookingStatus'] = this.bookingStatus;
    data['bookingDate'] = this.bookingDate;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Slot {
  String? slotId;
  List<SlotTimes>? slotTimes;
  String? sId;

  Slot({this.slotId, this.slotTimes, this.sId});

  Slot.fromJson(Map<String, dynamic> json) {
    slotId = json['slotId'];
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
    data['slotId'] = this.slotId;
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
  String? sId;

  SlotTimes({this.time, this.amount, this.sId});

  SlotTimes.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    amount = json['amount'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['amount'] = this.amount;
    data['_id'] = this.sId;
    return data;
  }
}
