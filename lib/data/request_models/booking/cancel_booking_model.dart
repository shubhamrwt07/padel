class CancelUserBooking {
  String? status;
  String? message;
  Booking? booking;

  CancelUserBooking({this.status, this.message, this.booking});

  CancelUserBooking.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    booking =
    json['booking'] != null ? new Booking.fromJson(json['booking']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.booking != null) {
      data['booking'] = this.booking!.toJson();
    }
    return data;
  }
}

class Booking {
  String? sId;
  String? userId;
  String? registerClubId;
  int? totalAmount;
  String? bookingDate;
  String? bookingStatus;
  String? bookingType;
  List<Slot>? slot;
  String? ownerId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? cancellationReason;

  Booking(
      {this.sId,
        this.userId,
        this.registerClubId,
        this.totalAmount,
        this.bookingDate,
        this.bookingStatus,
        this.bookingType,
        this.slot,
        this.ownerId,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.cancellationReason});

  Booking.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    registerClubId = json['register_club_id'];
    totalAmount = json['totalAmount'];
    bookingDate = json['bookingDate'];
    bookingStatus = json['bookingStatus'];
    bookingType = json['bookingType'];
    if (json['slot'] != null) {
      slot = <Slot>[];
      json['slot'].forEach((v) {
        slot!.add(new Slot.fromJson(v));
      });
    }
    ownerId = json['ownerId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    cancellationReason = json['cancellationReason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['register_club_id'] = this.registerClubId;
    data['totalAmount'] = this.totalAmount;
    data['bookingDate'] = this.bookingDate;
    data['bookingStatus'] = this.bookingStatus;
    data['bookingType'] = this.bookingType;
    if (this.slot != null) {
      data['slot'] = this.slot!.map((v) => v.toJson()).toList();
    }
    data['ownerId'] = this.ownerId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['cancellationReason'] = this.cancellationReason;
    return data;
  }
}

class Slot {
  String? slotId;
  String? courtName;
  String? bookingDate;
  List<SlotTimes>? slotTimes;
  List<BusinessHours>? businessHours;

  Slot(
      {this.slotId,
        this.courtName,
        this.bookingDate,
        this.slotTimes,
        this.businessHours});

  Slot.fromJson(Map<String, dynamic> json) {
    slotId = json['slotId'];
    courtName = json['courtName'];
    bookingDate = json['bookingDate'];
    if (json['slotTimes'] != null) {
      slotTimes = <SlotTimes>[];
      json['slotTimes'].forEach((v) {
        slotTimes!.add(new SlotTimes.fromJson(v));
      });
    }
    if (json['businessHours'] != null) {
      businessHours = <BusinessHours>[];
      json['businessHours'].forEach((v) {
        businessHours!.add(new BusinessHours.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slotId'] = this.slotId;
    data['courtName'] = this.courtName;
    data['bookingDate'] = this.bookingDate;
    if (this.slotTimes != null) {
      data['slotTimes'] = this.slotTimes!.map((v) => v.toJson()).toList();
    }
    if (this.businessHours != null) {
      data['businessHours'] =
          this.businessHours!.map((v) => v.toJson()).toList();
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
    time = json['time'];
    amount = json['amount'];
    status = json['status'];
    availabilityStatus = json['availabilityStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['availabilityStatus'] = this.availabilityStatus;
    return data;
  }

}

class BusinessHours {
  String? day;
  String? time;

  BusinessHours({this.day, this.time});

  BusinessHours.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['time'] = this.time;
    return data;
  }
}
