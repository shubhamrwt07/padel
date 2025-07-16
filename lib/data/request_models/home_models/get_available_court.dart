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

    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['status'] = this.status;

    data['time'] = this.time;

    data['amount'] = this.amount;

    data['_id'] = this.sId;

    return data;

  }

}



class RegisterClubId {

  Location? location;

  String? sId;

  String? ownerId;

  String? clubName;

  String? courtType;

  List<String>? courtImage;

  int? courtCount;

  List<BusinessHours>? businessHours;

  String? description;

  String? city;

  String? address;

  bool? isActive;

  bool? isDeleted;

  bool? isVerified;

  bool? isFeatured;

  List<String>? features;

  String? createdAt;

  String? updatedAt;

  int? iV;



  RegisterClubId(

      {this.location,

        this.sId,

        this.ownerId,

        this.clubName,

        this.courtType,

        this.courtImage,

        this.courtCount,

        this.businessHours,

        this.description,

        this.city,

        this.address,

        this.isActive,

        this.isDeleted,

        this.isVerified,

        this.isFeatured,

        this.features,

        this.createdAt,

        this.updatedAt,

        this.iV});



  RegisterClubId.fromJson(Map<String, dynamic> json) {

    location = json['location'] != null

        ? new Location.fromJson(json['location'])

        : null;

    sId = json['_id'];

    ownerId = json['ownerId'];

    clubName = json['clubName'];

    courtType = json['courtType'];

    courtImage = json['courtImage'].cast<String>();

    courtCount = json['courtCount'];

    if (json['businessHours'] != null) {

      businessHours = <BusinessHours>[];

      json['businessHours'].forEach((v) {

        businessHours!.add(new BusinessHours.fromJson(v));

      });

    }

    description = json['description'];

    city = json['city'];

    address = json['address'];

    isActive = json['isActive'];

    isDeleted = json['isDeleted'];

    isVerified = json['isVerified'];

    isFeatured = json['isFeatured'];

    features = json['features'].cast<String>();

    createdAt = json['createdAt'];

    updatedAt = json['updatedAt'];

    iV = json['__v'];

  }



  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.location != null) {

      data['location'] = this.location!.toJson();

    }

    data['_id'] = this.sId;

    data['ownerId'] = this.ownerId;

    data['clubName'] = this.clubName;

    data['courtType'] = this.courtType;

    data['courtImage'] = this.courtImage;

    data['courtCount'] = this.courtCount;

    if (this.businessHours != null) {

      data['businessHours'] =

          this.businessHours!.map((v) => v.toJson()).toList();

    }

    data['description'] = this.description;

    data['city'] = this.city;

    data['address'] = this.address;

    data['isActive'] = this.isActive;

    data['isDeleted'] = this.isDeleted;

    data['isVerified'] = this.isVerified;

    data['isFeatured'] = this.isFeatured;

    data['features'] = this.features;

    data['createdAt'] = this.createdAt;

    data['updatedAt'] = this.updatedAt;

    data['__v'] = this.iV;

    return data;

  }

}



class Location {

  String? type;

  List<double>? coordinates;



  Location({this.type, this.coordinates});



  Location.fromJson(Map<String, dynamic> json) {

    type = json['type'];

    coordinates = json['coordinates'].cast<double>();

  }



  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['type'] = this.type;

    data['coordinates'] = this.coordinates;

    return data;

  }

}



