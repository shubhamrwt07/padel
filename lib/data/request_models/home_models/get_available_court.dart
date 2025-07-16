class AvailableCourtModel {
  String? status;
  bool? success;
  int? count;
  List<AvailableCourtsData>? data;
  List<String>? allSlotTimes;

  AvailableCourtModel(
      {this.status, this.success, this.count, this.data, this.allSlotTimes});

  AvailableCourtModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    count = json['count'];
    if (json['data'] != null) {
      data = <AvailableCourtsData>[];
      json['data'].forEach((v) {
        data!.add(new AvailableCourtsData.fromJson(v));
      });
    }
    allSlotTimes = json['allSlotTimes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['success'] = success;
    data['count'] = count;
    data['allTimeSlots'] = allTimeSlots;
     final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['count'] = this.count;
     if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['allSlotTimes'] = this.allSlotTimes;
    return data;
  }
}

class AvailableCourtsData {
  String? sId;
  OwnerId? ownerId;
  List<Slot>? slot;
  RegisterClubId? registerClubId;
  int? iV;
  String? createdAt;
  String? updatedAt;

  AvailableCourtsData(
      {this.sId,
        this.ownerId,
        this.slot,
        this.registerClubId,
        this.iV,
        this.createdAt,
        this.updatedAt});

  AvailableCourtsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    ownerId =
    json['ownerId'] != null ? new OwnerId.fromJson(json['ownerId']) : null;
    if (json['slot'] != null) {
      slot = <Slot>[];
      json['slot'].forEach((v) {
        slot!.add(new Slot.fromJson(v));
      });
    }
    registerClubId = json['register_club_id'] != null
        ? new RegisterClubId.fromJson(json['register_club_id'])
        : null;
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.ownerId != null) {
      data['ownerId'] = this.ownerId!.toJson();
    }
    if (this.slot != null) {
      data['slot'] = this.slot!.map((v) => v.toJson()).toList();
    }
    if (this.registerClubId != null) {
      data['register_club_id'] = this.registerClubId!.toJson();
    }
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class OwnerId {
  String? sId;
  String? email;

  OwnerId({this.sId, this.email});

  OwnerId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    return data;
  }
}

class Slot {
  List<BusinessHours>? businessHours;
  List<SlotTimes>? slotTimes;
  String? sId;

  Slot({this.businessHours, this.slotTimes, this.sId});

  Slot.fromJson(Map<String, dynamic> json) {
    if (json['businessHours'] != null) {
      businessHours = <BusinessHours>[];
      json['businessHours'].forEach((v) {
        businessHours!.add(new BusinessHours.fromJson(v));
      });
    }
    if (json['slotTimes'] != null) {
      slotTimes = <SlotTimes>[];
      json['slotTimes'].forEach((v) {
        slotTimes!.add(new SlotTimes.fromJson(v));
      });
    }
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['courtType'] = courtType;
    if (slotTimes != null) {
      data['slotTimes'] = slotTimes!.map((v) => v.toJson()).toList();
    }
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    data['registeredCourtId'] = registeredCourtId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
 
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.businessHours != null) {
      data['businessHours'] =
          this.businessHours!.map((v) => v.toJson()).toList();
    }
    if (this.slotTimes != null) {
      data['slotTimes'] = this.slotTimes!.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    return data;
  }
}

class BusinessHours {
  String? time;
  String? day;
  String? sId;

  BusinessHours({this.time, this.day, this.sId});

  BusinessHours.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    day = json['day'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['day'] = this.day;
    data['_id'] = this.sId;
     return data;
  }
}

class SlotTimes {
  String? status;
  String? time;
  int? amount;
  String? sId;

  SlotTimes({this.status, this.time, this.amount, this.sId});

  SlotTimes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
    amount = json['amount'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['time'] = time;
    data['amount'] = amount;
    data['_id'] = sId;
    return data;
  }
}

class RegisterClubId {
  String? sId;
  String? clubName;

  RegisterClubId({this.sId, this.clubName});

  RegisterClubId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    clubName = json['clubName'];
  }

  Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
     final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['clubName'] = this.clubName;
     return data;
  }
}
