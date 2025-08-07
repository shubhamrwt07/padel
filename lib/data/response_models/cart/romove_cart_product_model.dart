class RemoveToCartModel {
  String? message;
  List<String>? deletedSlotIds;
  List<RemainingSlots>? remainingSlots;
  int? newTotalAmount;
  bool? cartDeleted;

  RemoveToCartModel(
      {this.message,
        this.deletedSlotIds,
        this.remainingSlots,
        this.newTotalAmount,
        this.cartDeleted});

  RemoveToCartModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    deletedSlotIds = json['deletedSlotIds'].cast<String>();
    if (json['remainingSlots'] != null) {
      remainingSlots = <RemainingSlots>[];
      json['remainingSlots'].forEach((v) {
        remainingSlots!.add(new RemainingSlots.fromJson(v));
      });
    }
    newTotalAmount = json['newTotalAmount'];
    cartDeleted = json['cartDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['deletedSlotIds'] = this.deletedSlotIds;
    if (this.remainingSlots != null) {
      data['remainingSlots'] =
          this.remainingSlots!.map((v) => v.toJson()).toList();
    }
    data['newTotalAmount'] = this.newTotalAmount;
    data['cartDeleted'] = this.cartDeleted;
    return data;
  }
}

class RemainingSlots {
  String? slotId;
  List<Times>? times;

  RemainingSlots({this.slotId, this.times});

  RemainingSlots.fromJson(Map<String, dynamic> json) {
    slotId = json['slotId'];
    if (json['times'] != null) {
      times = <Times>[];
      json['times'].forEach((v) {
        times!.add(new Times.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slotId'] = this.slotId;
    if (this.times != null) {
      data['times'] = this.times!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Times {
  String? time;
  String? slotId;

  Times({this.time, this.slotId});

  Times.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    slotId = json['slotId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['slotId'] = this.slotId;
    return data;
  }
}
