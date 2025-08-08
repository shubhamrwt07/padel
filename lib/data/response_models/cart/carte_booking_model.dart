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
  int? totalAmount;
  String? bookingDate;
  String? bookingStatus;
  String? bookingType;
  List<Slot>? slot;
  String? ownerId;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Bookings(
      {this.userId,
        this.registerClubId,
        this.totalAmount,
        this.bookingDate,
        this.bookingStatus,
        this.bookingType,
        this.slot,
        this.ownerId,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Bookings.fromJson(Map<String, dynamic> json) {
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
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
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
