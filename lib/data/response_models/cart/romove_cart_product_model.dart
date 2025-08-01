class RemoveToCartModel {
  String? message;
  List<String>? deletedSlotIds;
  bool? cartDeleted;

  RemoveToCartModel({this.message, this.deletedSlotIds, this.cartDeleted});

  RemoveToCartModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    deletedSlotIds = json['deletedSlotIds'].cast<String>();
    cartDeleted = json['cartDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['deletedSlotIds'] = this.deletedSlotIds;
    data['cartDeleted'] = this.cartDeleted;
    return data;
  }
}
