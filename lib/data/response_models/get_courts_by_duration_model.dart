class GetCourtsByDurationModel {
  bool? success;
  List<String>? requestedTimes;
  int? requestedDuration;
  int? consecutiveSlots;
  int? page;
  int? limit;
  int? totalCount;
  bool? hasNextPage;
  bool? hasPrevPage;
  String? date;
  List<GetCourtsByDurationData>? data;

  GetCourtsByDurationModel(
      {this.success,
        this.requestedTimes,
        this.requestedDuration,
        this.consecutiveSlots,
        this.page,
        this.limit,
        this.totalCount,
        this.hasNextPage,
        this.hasPrevPage,
        this.date,
        this.data});

  GetCourtsByDurationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    requestedTimes = json['requestedTimes'].cast<String>();
    requestedDuration = json['requestedDuration'];
    consecutiveSlots = json['consecutiveSlots'];
    page = json['page'];
    limit = json['limit'];
    totalCount = json['totalCount'];
    hasNextPage = json['hasNextPage'];
    hasPrevPage = json['hasPrevPage'];
    date = json['date'];
    if (json['data'] != null) {
      data = <GetCourtsByDurationData>[];
      json['data'].forEach((v) {
        data!.add(new GetCourtsByDurationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['requestedTimes'] = this.requestedTimes;
    data['requestedDuration'] = this.requestedDuration;
    data['consecutiveSlots'] = this.consecutiveSlots;
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['totalCount'] = this.totalCount;
    data['hasNextPage'] = this.hasNextPage;
    data['hasPrevPage'] = this.hasPrevPage;
    data['date'] = this.date;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetCourtsByDurationData {
  String? clubId;
  String? ownerId;
  String? clubName;
  String? address;
  String? city;
  String? state;
  String? zipCode;
  List<String>? courtImage;
  List<BusinessHours>? businessHours;
  List<GetCourtsbyDurationCourt>? courts;

  GetCourtsByDurationData(
      {this.clubId,
        this.ownerId,
        this.clubName,
        this.address,
        this.city,
        this.state,
        this.zipCode,
        this.courtImage,
        this.businessHours,
        this.courts});

  GetCourtsByDurationData.fromJson(Map<String, dynamic> json) {
    clubId = json['clubId'];
    ownerId = json['ownerId'];
    clubName = json['clubName'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zipCode'];
    courtImage = json['courtImage'].cast<String>();
    if (json['businessHours'] != null) {
      businessHours = <BusinessHours>[];
      json['businessHours'].forEach((v) {
        businessHours!.add(new BusinessHours.fromJson(v));
      });
    }
    if (json['courts'] != null) {
      courts = <GetCourtsbyDurationCourt>[];
      json['courts'].forEach((v) {
        courts!.add(new GetCourtsbyDurationCourt.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clubId'] = this.clubId;
    data['ownerId'] = this.ownerId;
    data['clubName'] = this.clubName;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zipCode'] = this.zipCode;
    data['courtImage'] = this.courtImage;
    if (this.businessHours != null) {
      data['businessHours'] =
          this.businessHours!.map((v) => v.toJson()).toList();
    }
    if (this.courts != null) {
      data['courts'] = this.courts!.map((v) => v.toJson()).toList();
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

class GetCourtsbyDurationCourt {
  String? courtId;
  String? courtName;
  List<String>? courtType;
  List<AvailabilityByTime>? availabilityByTime;

  GetCourtsbyDurationCourt(
      {this.courtId, this.courtName, this.courtType, this.availabilityByTime});

  GetCourtsbyDurationCourt.fromJson(Map<String, dynamic> json) {
    courtId = json['courtId'];
    courtName = json['courtName'];
    courtType = json['courtType'].cast<String>();
    if (json['availabilityByTime'] != null) {
      availabilityByTime = <AvailabilityByTime>[];
      json['availabilityByTime'].forEach((v) {
        availabilityByTime!.add(new AvailabilityByTime.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courtId'] = this.courtId;
    data['courtName'] = this.courtName;
    data['courtType'] = this.courtType;
    if (this.availabilityByTime != null) {
      data['availabilityByTime'] =
          this.availabilityByTime!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AvailabilityByTime {
  String? requestedTime;
  String? startTime;
  int? duration;
  int? totalAmount;
  List<Slots>? slots;

  AvailabilityByTime(
      {this.requestedTime,
        this.startTime,
        this.duration,
        this.totalAmount,
        this.slots});

  AvailabilityByTime.fromJson(Map<String, dynamic> json) {
    requestedTime = json['requestedTime'];
    startTime = json['startTime'];
    duration = json['duration'];
    totalAmount = json['totalAmount'];
    if (json['slots'] != null) {
      slots = <Slots>[];
      json['slots'].forEach((v) {
        slots!.add(new Slots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestedTime'] = this.requestedTime;
    data['startTime'] = this.startTime;
    data['duration'] = this.duration;
    data['totalAmount'] = this.totalAmount;
    if (this.slots != null) {
      data['slots'] = this.slots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slots {
  String? sId;
  String? time;
  int? slotSequence;
  int? amount;
  int? duration;
  int? usedDuration;
  String? status;
  List<BusinessHours>? businessHours;

  Slots(
      {this.sId,
        this.time,
        this.slotSequence,
        this.amount,
        this.duration,
        this.usedDuration,
        this.status,
        this.businessHours});

  Slots.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    time = json['time'];
    slotSequence = json['slotSequence'];
    amount = json['amount'];
    duration = json['duration'];
    usedDuration = json['usedDuration'];
    status = json['status'];
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
    data['slotSequence'] = this.slotSequence;
    data['amount'] = this.amount;
    data['duration'] = this.duration;
    data['usedDuration'] = this.usedDuration;
    data['status'] = this.status;
    if (this.businessHours != null) {
      data['businessHours'] =
          this.businessHours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
