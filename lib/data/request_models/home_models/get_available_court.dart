
class GetAllActiveCourtsForSlotWiseModel {
  String? status;
  bool? success;
  int? count;
  List<Data>? data;
  GetAllActiveCourtsForSlotWiseModel(
      {this.status, this.success, this.count, this.data});
  GetAllActiveCourtsForSlotWiseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    count = json['count'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Data {
  String? sId;
  String? clubName;
  RegisterClubId? registerClubId;
  String? courtName;
  List<Slots>? slots;
  Data(
      {this.sId,
        this.clubName,
        this.registerClubId,
        this.courtName,
        this.slots});
  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    clubName = json['clubName'];
    registerClubId = json['register_club_id'] != null
        ? new RegisterClubId.fromJson(json['register_club_id'])
        : null;
    courtName = json['courtName'];
    if (json['slots'] != null) {
      slots = <Slots>[];
      json['slots'].forEach((v) {
        slots!.add(new Slots.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['clubName'] = this.clubName;
    if (this.registerClubId != null) {
      data['register_club_id'] = this.registerClubId!.toJson();
    }
    data['courtName'] = this.courtName;
    if (this.slots != null) {
      data['slots'] = this.slots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class RegisterClubId {
  String? sId;
  String? clubName;
  String? courtType;
  RegisterClubId({this.sId, this.clubName, this.courtType});
  RegisterClubId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    clubName = json['clubName'];
    courtType = json['courtType'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['clubName'] = this.clubName;
    data['courtType'] = this.courtType;
    return data;
  }
}
class Slots {
  String? sId;
  String? time;
  int? amount;
  String? status;
  String? availabilityStatus;
  List<BusinessHours>? businessHours;
  Slots(
      {this.sId,
        this.time,
        this.amount,
        this.status,
        this.availabilityStatus,
        this.businessHours});
  Slots.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    time = json['time'];
    amount = json['amount'];
    status = json['status'];
    availabilityStatus = json['availabilityStatus'];
    if (json['businessHours'] != null) {
      businessHours = <BusinessHours>[];
      json['businessHours'].forEach((v) {
        businessHours!.add(new BusinessHours.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['time'] = this.time;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['availabilityStatus'] = this.availabilityStatus;
    if (this.businessHours != null) {
      data['businessHours'] =
          this.businessHours!.map((v) => v.toJson()).toList();
    }
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
 
 