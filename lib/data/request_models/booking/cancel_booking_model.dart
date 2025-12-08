class CancelUserBooking {
  String? status;
  String? message;
  Booking? booking;

  CancelUserBooking({this.status, this.message, this.booking});

  CancelUserBooking.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    booking =
        json['booking'] != null ? Booking.fromJson(json['booking']) : null;
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        if (booking != null) 'booking': booking!.toJson(),
      };
}

class Booking {
  String? id;
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
  int? v;
  String? cancellationDate;
  String? cancellationReason;

  Booking({
    this.id,
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
    this.v,
    this.cancellationDate,
    this.cancellationReason,
  });

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    registerClubId = json['register_club_id'];
    totalAmount = json['totalAmount'];
    bookingDate = json['bookingDate'];
    bookingStatus = json['bookingStatus'];
    bookingType = json['bookingType'];

    if (json['slot'] != null) {
      slot = List.from(json['slot'].map((x) => Slot.fromJson(x)));
    }

    createdAt = json['createdAt'];
    ownerId = json['ownerId'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    cancellationDate = json['cancellationDate'];
    cancellationReason = json['cancellationReason'];
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'register_club_id': registerClubId,
        'totalAmount': totalAmount,
        'bookingDate': bookingDate,
        'bookingStatus': bookingStatus,
        'bookingType': bookingType,
        if (slot != null) 'slot': slot!.map((v) => v.toJson()).toList(),
        'createdAt': createdAt,
        'ownerId': ownerId,
        'updatedAt': updatedAt,
        '__v': v,
        'cancellationDate': cancellationDate,
        'cancellationReason': cancellationReason,
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

    if (json['slotTimes'] != null) {
      slotTimes =
          List.from(json['slotTimes'].map((x) => SlotTimes.fromJson(x)));
    }

    if (json['businessHours'] != null) {
      businessHours =
          List.from(json['businessHours'].map((x) => BusinessHours.fromJson(x)));
    }
  }

  Map<String, dynamic> toJson() => {
        'slotId': slotId,
        'courtName': courtName,
        'courtId': courtId,
        'bookingDate': bookingDate,
        if (slotTimes != null)
          'slotTimes': slotTimes!.map((v) => v.toJson()).toList(),
        if (businessHours != null)
          'businessHours': businessHours!.map((v) => v.toJson()).toList(),
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