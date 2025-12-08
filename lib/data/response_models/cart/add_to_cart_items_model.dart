class AddToCartModel {
  final String? message;
  final Cart? cart;
  final bool? isNewCart;

  AddToCartModel({this.message, this.cart, this.isNewCart});

  factory AddToCartModel.fromJson(Map<String, dynamic> json) => AddToCartModel(
        message: json['message'],
        cart: json['cart'] != null ? Cart.fromJson(json['cart']) : null,
        isNewCart: json['isNewCart'],
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'cart': cart?.toJson(),
        'isNewCart': isNewCart,
      };
}

class Cart {
  final String? userId;
  final List<Slot>? slot;
  final String? registerClubId;
  final int? totalAmount;
  final String? courtName;
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  Cart({
    this.userId,
    this.slot,
    this.registerClubId,
    this.totalAmount,
    this.courtName,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        userId: json['userId'],
        slot: (json['slot'] as List<dynamic>?)
            ?.map((e) => Slot.fromJson(e))
            .toList(),
        registerClubId: json['register_club_id'],
        totalAmount: json['totalAmount'],
        courtName: json['courtName'],
        id: json['_id'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'slot': slot?.map((e) => e.toJson()).toList(),
        'register_club_id': registerClubId,
        'totalAmount': totalAmount,
        'courtName': courtName,
        '_id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
      };
}

class Slot {
  final List<SlotTimes>? slotTimes;
  final String? id;

  Slot({this.slotTimes, this.id});

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        slotTimes: (json['slotTimes'] as List<dynamic>?)
            ?.map((e) => SlotTimes.fromJson(e))
            .toList(),
        id: json['_id'],
      );

  Map<String, dynamic> toJson() => {
        'slotTimes': slotTimes?.map((e) => e.toJson()).toList(),
        '_id': id,
      };
}

class SlotTimes {
  final String? time;
  final int? amount;
  final String? slotId;
  final String? bookingDate;
  final String? id;

  SlotTimes({this.time, this.amount, this.slotId, this.bookingDate, this.id});

  factory SlotTimes.fromJson(Map<String, dynamic> json) => SlotTimes(
        time: json['time'],
        amount: json['amount'],
        slotId: json['slotId'],
        bookingDate: json['bookingDate'],
        id: json['_id'],
      );

  Map<String, dynamic> toJson() => {
        'time': time,
        'amount': amount,
        'slotId': slotId,
        'bookingDate': bookingDate,
        '_id': id,
      };
}