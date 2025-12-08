class CarteBookingModel {
  String? message;
  List<Bookings>? bookings;
  int? count;

  CarteBookingModel({this.message, this.bookings, this.count});

  CarteBookingModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    bookings = (json['bookings'] as List?)
        ?.map((e) => Bookings.fromJson(e))
        .toList();
    count = json['count'];
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'bookings': bookings?.map((e) => e.toJson()).toList(),
        'count': count,
      };
}

class Bookings {
  String? userId;
  String? registerClubId;
  int? totalAmount;
  String? bookingDate;
  String? bookingStatus;
  String? bookingType;
  List<Slot>? slot;
  String? createdAt;
  String? ownerId;
  String? updatedAt;
  String? sId;
  int? iV;

  Bookings({
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
    this.sId,
    this.iV,
  });

  Bookings.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    registerClubId = json['register_club_id'];
    totalAmount = json['totalAmount'];
    bookingDate = json['bookingDate'];
    bookingStatus = json['bookingStatus'];
    bookingType = json['bookingType'];
    slot = (json['slot'] as List?)?.map((e) => Slot.fromJson(e)).toList();
    createdAt = json['createdAt'];
    ownerId = json['ownerId'];
    updatedAt = json['updatedAt'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'register_club_id': registerClubId,
        'totalAmount': totalAmount,
        'bookingDate': bookingDate,
        'bookingStatus': bookingStatus,
        'bookingType': bookingType,
        'slot': slot?.map((e) => e.toJson()).toList(),
        'createdAt': createdAt,
        'ownerId': ownerId,
        'updatedAt': updatedAt,
        '_id': sId,
        '__v': iV,
      };
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
    slotId = json['slotId'];
    courtName = json['courtName'];
    courtId = json['courtId'];
    bookingDate = json['bookingDate'];
    slotTimes =
        (json['slotTimes'] as List?)?.map((e) => SlotTimes.fromJson(e)).toList();
    businessHours = (json['businessHours'] as List?)
        ?.map((e) => BusinessHours.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'slotId': slotId,
        'courtName': courtName,
        'courtId': courtId,
        'bookingDate': bookingDate,
        'slotTimes': slotTimes?.map((e) => e.toJson()).toList(),
        'businessHours': businessHours?.map((e) => e.toJson()).toList(),
      };
}

class SlotTimes {
  String? time;
  int? amount;
  String? status;
  String? availabilityStatus;

  SlotTimes({this.time, this.amount, this.status, this.availabilityStatus});

  SlotTimes.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    amount = json['amount'];
    status = json['status'];
    availabilityStatus = json['availabilityStatus'];
  }

  Map<String, dynamic> toJson() => {
        'time': time,
        'amount': amount,
        'status': status,
        'availabilityStatus': availabilityStatus,
      };
}

class BusinessHours {
  String? day;
  String? time;

  BusinessHours({this.day, this.time});

  BusinessHours.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'time': time,
      };
}