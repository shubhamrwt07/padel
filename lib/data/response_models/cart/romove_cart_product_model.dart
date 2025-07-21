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
  List<String>? times;

  RemainingSlots({this.slotId, this.times});

  RemainingSlots.fromJson(Map<String, dynamic> json) {
    slotId = json['slotId'];
    times = json['times'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slotId'] = this.slotId;
    data['times'] = this.times;
    return data;
  }
}
