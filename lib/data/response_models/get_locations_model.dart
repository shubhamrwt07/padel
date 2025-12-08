class GetLocationsModel {
  bool? status;
  String? message;
  List<GetLocationData>? data;

  GetLocationsModel({this.status, this.message, this.data});

  GetLocationsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = List<GetLocationData>.from(
        json['data'].map((x) => GetLocationData.fromJson(x)),
      );
    }
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((x) => x.toJson()).toList(),
      };
}

class GetLocationData {
  String? id;
  String? name;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  int? v;

  GetLocationData({
    this.id,
    this.name,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  GetLocationData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'isActive': isActive,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
      };
}