class AvailableCourtModel {
  String? status;
  bool? success;
  int? count;
  List<String>? allTimeSlots;
  List<AvailableCourtsData>? data;

  AvailableCourtModel(
      {this.status, this.success, this.count, this.allTimeSlots, this.data});

  AvailableCourtModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['success'] = success;
    data['count'] = count;
    data['allTimeSlots'] = allTimeSlots;
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

class Owner {
  String? id;
  String? email;

  Owner({this.id, this.email});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    return data;
  }
}
