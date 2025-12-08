class OpenMatchDetailsModel {
  String? message;
  Data? data;

  OpenMatchDetailsModel({this.message, this.data});

  OpenMatchDetailsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        if (data != null) 'data': data!.toJson(),
      };
}

class Data {
  String? id;
  ClubId? clubId;
  List<Slot>? slot;
  String? matchType;
  String? skillLevel;
  List<String>? skillDetails;
  String? matchDate;
  String? matchTime;
  String? matchStatus;
  List<TeamA>? teamA;
  List<TeamB>? teamB;
  String? createdBy;
  String? gender;
  bool? status;
  bool? adminStatus;
  bool? isActive;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? v;

  Data({
    this.id,
    this.clubId,
    this.slot,
    this.matchType,
    this.skillLevel,
    this.skillDetails,
    this.matchDate,
    this.matchTime,
    this.matchStatus,
    this.teamA,
    this.teamB,
    this.createdBy,
    this.gender,
    this.status,
    this.adminStatus,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    clubId = json['clubId'] != null ? ClubId.fromJson(json['clubId']) : null;

    if (json['slot'] != null) {
      slot = (json['slot'] as List)
          .map((e) => Slot.fromJson(e))
          .toList();
    }

    matchType = json['matchType'];
    skillLevel = json['skillLevel'];
    skillDetails =
        json['skillDetails'] != null ? List<String>.from(json['skillDetails']) : null;
    matchDate = json['matchDate'];
    matchTime = json['matchTime'];
    matchStatus = json['matchStatus'];

    if (json['teamA'] != null) {
      teamA = (json['teamA'] as List)
          .map((e) => TeamA.fromJson(e))
          .toList();
    }

    if (json['teamB'] != null) {
      teamB = (json['teamB'] as List)
          .map((e) => TeamB.fromJson(e))
          .toList();
    }

    createdBy = json['createdBy'];
    gender = json['gender'];
    status = json['status'];
    adminStatus = json['adminStatus'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        if (clubId != null) 'clubId': clubId!.toJson(),
        if (slot != null) 'slot': slot!.map((e) => e.toJson()).toList(),
        'matchType': matchType,
        'skillLevel': skillLevel,
        'skillDetails': skillDetails,
        'matchDate': matchDate,
        'matchTime': matchTime,
        'matchStatus': matchStatus,
        if (teamA != null) 'teamA': teamA!.map((e) => e.toJson()).toList(),
        if (teamB != null) 'teamB': teamB!.map((e) => e.toJson()).toList(),
        'createdBy': createdBy,
        'gender': gender,
        'status': status,
        'adminStatus': adminStatus,
        'isActive': isActive,
        'isDeleted': isDeleted,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
      };
}

class ClubId {
  String? id;
  String? clubName;
  String? address;

  ClubId({this.id, this.clubName, this.address});

  ClubId.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    clubName = json['clubName'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'clubName': clubName,
        'address': address,
      };
}

class Slot {
  String? slotId;
  String? courtName;
  List<SlotTimes>? slotTimes;

  Slot({this.slotId, this.courtName, this.slotTimes});

  Slot.fromJson(Map<String, dynamic> json) {
    slotId = json['slotId'];
    courtName = json['courtName'];
    if (json['slotTimes'] != null) {
      slotTimes = (json['slotTimes'] as List)
          .map((e) => SlotTimes.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() => {
        'slotId': slotId,
        'courtName': courtName,
        if (slotTimes != null)
          'slotTimes': slotTimes!.map((e) => e.toJson()).toList(),
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

class TeamA {
  UserId? userId;
  String? joinedAt;
  String? id;

  TeamA({this.userId, this.joinedAt, this.id});

  TeamA.fromJson(Map<String, dynamic> json) {
    userId = json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    joinedAt = json['joinedAt'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() => {
        if (userId != null) 'userId': userId!.toJson(),
        'joinedAt': joinedAt,
        '_id': id,
      };
}

class TeamB {
  UserId? userId;
  String? joinedAt;
  String? id;

  TeamB({this.userId, this.joinedAt, this.id});

  TeamB.fromJson(Map<String, dynamic> json) {
    userId = json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    joinedAt = json['joinedAt'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() => {
        if (userId != null) 'userId': userId!.toJson(),
        'joinedAt': joinedAt,
        '_id': id,
      };
}

class UserId {
  Location? location;
  String? id;
  String? email;
  String? countryCode;
  int? phoneNumber;
  String? name;
  String? lastname;
  String? password;
  String? city;
  bool? agreeTermsAndCondition;
  String? category;
  bool? isActive;
  bool? isDeleted;
  String? role;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? dob;
  String? gender;
  String? profilePic;

  UserId({
    this.location,
    this.id,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.name,
    this.lastname,
    this.password,
    this.city,
    this.agreeTermsAndCondition,
    this.category,
    this.isActive,
    this.isDeleted,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.dob,
    this.gender,
    this.profilePic,
  });

  UserId.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    id = json['_id'];
    email = json['email'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    name = json['name'];
    lastname = json['lastname'];
    password = json['password'];
    city = json['city'];
    agreeTermsAndCondition = json['agreeTermsAndCondition'];
    category = json['category'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    role = json['role'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    dob = json['dob'];
    gender = json['gender'];
    profilePic = json['profilePic'];
  }

  Map<String, dynamic> toJson() => {
        if (location != null) 'location': location!.toJson(),
        '_id': id,
        'email': email,
        'countryCode': countryCode,
        'phoneNumber': phoneNumber,
        'name': name,
        'lastname': lastname,
        'password': password,
        'city': city,
        'agreeTermsAndCondition': agreeTermsAndCondition,
        'category': category,
        'isActive': isActive,
        'isDeleted': isDeleted,
        'role': role,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
        'dob': dob,
        'gender': gender,
        'profilePic': profilePic,
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