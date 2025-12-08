class RemoveToCartModel {
  String? message;
  List<String>? deletedSlotIds;
  List<RemainingSlots>? remainingSlots;
  int? newTotalAmount;
  bool? cartDeleted;

  RemoveToCartModel({
    this.message,
    this.deletedSlotIds,
    this.remainingSlots,
    this.newTotalAmount,
    this.cartDeleted,
  });

  RemoveToCartModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    deletedSlotIds = json['deletedSlotIds'] != null
        ? List<String>.from(json['deletedSlotIds'])
        : null;

    if (json['remainingSlots'] != null) {
      remainingSlots = (json['remainingSlots'] as List)
          .map((e) => RemainingSlots.fromJson(e))
          .toList();
    }

    newTotalAmount = json['newTotalAmount'];
    cartDeleted = json['cartDeleted'];
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'deletedSlotIds': deletedSlotIds,
        'remainingSlots': remainingSlots?.map((e) => e.toJson()).toList(),
        'newTotalAmount': newTotalAmount,
        'cartDeleted': cartDeleted,
      };
}

class RemainingSlots {
  String? slotId;
  List<Times>? times;

  RemainingSlots({this.slotId, this.times});

  RemainingSlots.fromJson(Map<String, dynamic> json) {
    slotId = json['slotId'];

    if (json['times'] != null) {
      times = (json['times'] as List)
          .map((e) => Times.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() => {
        'slotId': slotId,
        'times': times?.map((e) => e.toJson()).toList(),
      };
}

class Times {
  String? time;
  String? slotId;

  Times({this.time, this.slotId});

  Times.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    slotId = json['slotId'];
  }

  Map<String, dynamic> toJson() => {
        'time': time,
        'slotId': slotId,
      };
}