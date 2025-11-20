class BookingConfirmationModel {
  String? status;
  String? message;
  Booking? booking;

  BookingConfirmationModel({this.status, this.message, this.booking});

  BookingConfirmationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    booking = json['booking'] != null
        ? Booking.fromJson(json['booking'])
        : null;
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        if (booking != null) 'booking': booking!.toJson(),
      };
}

class Booking {
  String? sId;
  UserId? userId;
  RegisterClubId? registerClubId;
  int? totalAmount;
  String? bookingDate;
  String? bookingStatus;
  String? bookingType;
  List<Slot>? slot;
  String? createdAt;
  String? ownerId;
  String? updatedAt;
  int? iV;
  String? cancellationDate;
  String? cancellationReason;
  int? refundAmount;
  String? refundDate;

  Booking({
    this.sId,
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
    this.iV,
    this.cancellationDate,
    this.cancellationReason,
    this.refundAmount,
    this.refundDate,  
  });

  Booking.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    registerClubId = json['register_club_id'] != null
        ? RegisterClubId.fromJson(json['register_club_id'])
        : null;
    totalAmount = json['totalAmount'];
    bookingDate = json['bookingDate'];
    bookingStatus = json['bookingStatus'];
    bookingType = json['bookingType'];
    slot = json['slot'] != null
        ? (json['slot'] as List).map((e) => Slot.fromJson(e)).toList()
        : null;
    createdAt = json['createdAt'];
    ownerId = json['ownerId'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    cancellationDate = json['cancellationDate'];
    cancellationReason = json['cancellationReason'];
    refundAmount = json['refundAmount'];
    refundDate = json['refundDate'];
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        if (userId != null) 'userId': userId!.toJson(),
        if (registerClubId != null) 'register_club_id': registerClubId!.toJson(),
        'totalAmount': totalAmount,
        'bookingDate': bookingDate,
        'bookingStatus': bookingStatus,
        'bookingType': bookingType,
        if (slot != null) 'slot': slot!.map((e) => e.toJson()).toList(),
        'createdAt': createdAt,
        'ownerId': ownerId,
        'updatedAt': updatedAt,
        '__v': iV,
        'cancellationDate': cancellationDate,
        'cancellationReason': cancellationReason,
        'refundAmount': refundAmount,
        'refundDate': refundDate,
      };
}

class UserId {
  String? sId;
  String? email;
  String? countryCode;
  int? phoneNumber;
  String? name;
  String? lastName;
  String? password;
  Location? location;
  String? city;
  bool? agreeTermsAndCondition;
  String? category;
  bool? isActive;
  bool? isDeleted;
  String? role;
  List<String>? fcmTokens;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? customerAge;
  String? customerRacketSport;
  String? customerScale;
  String? playerLevel;
  String? reboundSkills;
  String? receivingTP;
  String? volleyNetPositioning;
  String? dob;
  String? gender;

  UserId({
    this.sId,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.name,
    this.lastName,
    this.password,
    this.location,
    this.city,
    this.agreeTermsAndCondition,
    this.category,
    this.isActive,
    this.isDeleted,
    this.role,
    this.fcmTokens,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.customerAge,
    this.customerRacketSport,
    this.customerScale,
    this.playerLevel,
    this.reboundSkills,
    this.receivingTP,
    this.volleyNetPositioning,
    this.dob,
    this.gender,
  });

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    name = json['name'];
    lastName = json['lastName'];
    password = json['password'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    city = json['city'];
    agreeTermsAndCondition = json['agreeTermsAndCondition'];
    category = json['category'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    role = json['role'];
    fcmTokens = json['fcmTokens'] != null ? List<String>.from(json['fcmTokens']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    customerAge = json['customerAge'];
    customerRacketSport = json['customerRacketSport'];
    customerScale = json['customerScale'];
    playerLevel = json['playerLevel'];
    reboundSkills = json['reboundSkills'];
    receivingTP = json['receivingTP'];
    volleyNetPositioning = json['volleyNetPositioning'];
    dob = json['dob'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'email': email,
        'countryCode': countryCode,
        'phoneNumber': phoneNumber,
        'name': name,
        'lastName': lastName,
        'password': password,
        if (location != null) 'location': location!.toJson(),
        'city': city,
        'agreeTermsAndCondition': agreeTermsAndCondition,
        'category': category,
        'isActive': isActive,
        'isDeleted': isDeleted,
        'role': role,
        'fcmTokens': fcmTokens,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': iV,
        'customerAge': customerAge,
        'customerRacketSport': customerRacketSport,
        'customerScale': customerScale,
        'playerLevel': playerLevel,
        'reboundSkills': reboundSkills,
        'receivingTP': receivingTP,
        'volleyNetPositioning': volleyNetPositioning,
        'dob': dob,
        'gender': gender,
      };
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'] != null
        ? List<double>.from(json['coordinates'])
        : null;
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}

class RegisterClubId {
  String? sId;
  List<String>? courtImage;

  RegisterClubId({this.sId, this.courtImage});

  RegisterClubId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    courtImage = json['courtImage'] != null
        ? List<String>.from(json['courtImage'])
        : null;
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'courtImage': courtImage,
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
    slotTimes = json['slotTimes'] != null
        ? (json['slotTimes'] as List)
            .map((e) => SlotTimes.fromJson(e))
            .toList()
        : null;
    businessHours = json['businessHours'] != null
        ? (json['businessHours'] as List)
            .map((e) => BusinessHours.fromJson(e))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() => {
        'slotId': slotId,
        'courtName': courtName,
        'courtId': courtId,
        'bookingDate': bookingDate,
        if (slotTimes != null) 'slotTimes': slotTimes!.map((e) => e.toJson()).toList(),
        if (businessHours != null) 'businessHours': businessHours!.map((e) => e.toJson()).toList(),
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
