class AvailableCourtModel {
  bool? success;
  int? count;
  List<String>? allTimeSlots;
  List<AvailableCourtsData>? data;

  AvailableCourtModel({this.success, this.count, this.allTimeSlots, this.data});

  AvailableCourtModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    count = json['count'];
    allTimeSlots = json['allTimeSlots'].cast<String>();
    if (json['data'] != null) {
      data = <AvailableCourtsData>[];
      json['data'].forEach((v) {
        data!.add(new AvailableCourtsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['count'] = this.count;
    data['allTimeSlots'] = this.allTimeSlots;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AvailableCourtsData {
  String? id;
  String? name;
  String? status;
  String? courtType;
  List<SlotTimes>? slotTimes;
  Owner? owner;
  String? registeredCourtId;
  String? createdAt;
  String? updatedAt;

  AvailableCourtsData(
      {this.id,
        this.name,
        this.status,
        this.courtType,
        this.slotTimes,
        this.owner,
        this.registeredCourtId,
        this.createdAt,
        this.updatedAt});

  AvailableCourtsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    courtType = json['courtType'];
    if (json['slotTimes'] != null) {
      slotTimes = <SlotTimes>[];
      json['slotTimes'].forEach((v) {
        slotTimes!.add(new SlotTimes.fromJson(v));
      });
    }
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    registeredCourtId = json['registeredCourtId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['courtType'] = this.courtType;
    if (this.slotTimes != null) {
      data['slotTimes'] = this.slotTimes!.map((v) => v.toJson()).toList();
    }
    if (this.owner != null) {
      data['owner'] = this.owner!.toJson();
    }
    data['registeredCourtId'] = this.registeredCourtId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['time'] = this.time;
    data['amount'] = this.amount;
    data['_id'] = this.sId;
    return data;
  }
}

class Owner {
  String? id;
  String? email;

  Owner({this.id, this.email});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    return data;
  }
}