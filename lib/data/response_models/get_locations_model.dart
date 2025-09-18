class GetLocationsModel {
  bool? status;
  String? message;
  List<GetLocationData>? data;

  GetLocationsModel({this.status, this.message, this.data});

  GetLocationsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetLocationData>[];
      json['data'].forEach((v) {
        data!.add(new GetLocationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetLocationData {
  String? sId;
  String? name;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  int? iV;

  GetLocationData(
      {this.sId,
      this.name,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.iV});

  GetLocationData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
