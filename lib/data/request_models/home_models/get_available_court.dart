class AvailableCourtModel {
  bool? success;
  int? count;
  List<AvailableCourtsData>? data;

  AvailableCourtModel({this.success, this.count, this.data});

  AvailableCourtModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    count = json['count'];
    if (json['data'] != null) {
      data = <AvailableCourtsData>[];
      json['data'].forEach((v) {
        data!.add(new AvailableCourtsData.fromJson(v));
      });
    }
  }
}

class AvailableCourtsData {
  String? id;
  String? name;
  String? status;
  String? businessHours;
  int? hourlyRate;
  Owner? owner;
  String? registeredCourtId;
  String? createdAt;
  String? updatedAt;

  AvailableCourtsData({
    this.id,
    this.name,
    this.status,
    this.businessHours,
    this.hourlyRate,
    this.owner,
    this.registeredCourtId,
    this.createdAt,
    this.updatedAt,
  });

  AvailableCourtsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    businessHours = json['businessHours'];
    hourlyRate = json['hourlyRate'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    registeredCourtId = json['registeredCourtId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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
}
