class AddToCartModel {
  String? message;
  List<Courts>? courts;
  int? successCount;

  AddToCartModel({this.message, this.courts, this.successCount});

  AddToCartModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['courts'] != null) {
      courts = <Courts>[];
      json['courts'].forEach((v) {
        courts!.add(Courts.fromJson(v));
      });
    }
    successCount = json['successCount'];
  }

 }

class Courts {
  String? userId;
  List<CourtData>? courtNames;
  String? registerClubId;
  int? totalAmount;
  String? id;
  int? iV;
  String? createdAt;
  String? updatedAt;

  Courts(
      {this.userId,
        this.courtNames,
        this.registerClubId,
        this.totalAmount,
        this.id,
        this.iV,
        this.createdAt,
        this.updatedAt});

  Courts.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    if (json['courtNames'] != null) {
      courtNames = <CourtData>[];
      json['courtNames'].forEach((v) {
        courtNames!.add(CourtData.fromJson(v));
      });
    }
    registerClubId = json['register_club_id'];
    totalAmount = json['totalAmount'];
    id = json['_id'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

 }

class CourtData {
  String? name;
  String? status;
  String? courtType;
  String? courtId;
  List<SlotTimes>? slotTimes;
  String? id;

  CourtData(
      {this.name,
        this.status,
        this.courtType,
        this.courtId,
        this.slotTimes,
        this.id});

  CourtData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
    courtType = json['courtType'];
    courtId = json['courtId'];
    if (json['slotTimes'] != null) {
      slotTimes = <SlotTimes>[];
      json['slotTimes'].forEach((v) {
        slotTimes!.add(SlotTimes.fromJson(v));
      });
    }
    id = json['_id'];
  }

 }

class SlotTimes {
  String? status;
  String? time;
  int? amount;
  String? id;

  SlotTimes({this.status, this.time, this.amount, this.id});

  SlotTimes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
    amount = json['amount'];
    id = json['_id'];
  }


}
