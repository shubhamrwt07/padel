class AvailableCourtModel {
  String? status;
  bool? success;
  int? count;
  List<Data>? data;
  List<String>? allSlotTimes;
  List<String>? allCourtNames;

  AvailableCourtModel(
      {this.status,
        this.success,
        this.count,
        this.data,
        this.allSlotTimes,
        this.allCourtNames});

  AvailableCourtModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    count = json['count'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    allSlotTimes = json['allSlotTimes'].cast<String>();
    allCourtNames = json['allCourtNames'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['allSlotTimes'] = this.allSlotTimes;
    data['allCourtNames'] = this.allCourtNames;
    return data;
  }
}

class Data {
  String? sId;
  RegisterClubId? registerClubId;
  List<Courts>? courts;
  List<Slot>? slot;
  List<String>? allSlotTimes;

  Data(
      {this.sId,
        this.registerClubId,
        this.courts,
        this.slot,
        this.allSlotTimes});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    registerClubId = json['register_club_id'] != null
        ? new RegisterClubId.fromJson(json['register_club_id'])
        : null;
    if (json['courts'] != null) {
      courts = <Courts>[];
      json['courts'].forEach((v) {
        courts!.add(new Courts.fromJson(v));
      });
    }
    if (json['slot'] != null) {
      slot = <Slot>[];
      json['slot'].forEach((v) {
        slot!.add(new Slot.fromJson(v));
      });
    }
    allSlotTimes = json['allSlotTimes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.registerClubId != null) {
      data['register_club_id'] = this.registerClubId!.toJson();
    }
    if (this.courts != null) {
      data['courts'] = this.courts!.map((v) => v.toJson()).toList();
    }
    if (this.slot != null) {
      data['slot'] = this.slot!.map((v) => v.toJson()).toList();
    }
    data['allSlotTimes'] = this.allSlotTimes;
    return data;
  }
}

class RegisterClubId {
  String? sId;
  String? clubName;
  List<BusinessHours>? businessHours;
  List<String>? features;

  RegisterClubId({this.sId, this.clubName, this.businessHours, this.features});

  RegisterClubId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    clubName = json['clubName'];
    if (json['businessHours'] != null) {
      businessHours = <BusinessHours>[];
      json['businessHours'].forEach((v) {
        businessHours!.add(new BusinessHours.fromJson(v));
      });
    }
    features = json['features'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['clubName'] = this.clubName;
    if (this.businessHours != null) {
      data['businessHours'] =
          this.businessHours!.map((v) => v.toJson()).toList();
    }
    data['features'] = this.features;
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

class Courts {
  String? sId;
  String? courtName;

  Courts({this.sId, this.courtName});

  Courts.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    courtName = json['courtName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['courtName'] = this.courtName;
    return data;
  }
}

class Slot {
  String? sId;
  List<BusinessHours>? businessHours;
  List<SlotTimes>? slotTimes;

  Slot({this.sId, this.businessHours, this.slotTimes});

  Slot.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.businessHours != null) {
      data['businessHours'] =
          this.businessHours!.map((v) => v.toJson()).toList();
    }
    if (this.slotTimes != null) {
      data['slotTimes'] = this.slotTimes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SlotTimes {
  String? sId;
  String? time;
  int? amount;
  String? status;
  String? availabilityStatus;

  SlotTimes(
      {this.sId, this.time, this.amount, this.status, this.availabilityStatus});

  SlotTimes.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    time = json['time'];
    amount = json['amount'];
    status = json['status'];
    availabilityStatus = json['availabilityStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['time'] = this.time;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['availabilityStatus'] = this.availabilityStatus;
    return data;
  }
}
