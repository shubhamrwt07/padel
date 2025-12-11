class DeleteCustomerModel {
  int? status;
  String? message;
  dynamic customer;

  DeleteCustomerModel({this.status, this.message, this.customer});

  factory DeleteCustomerModel.fromJson(Map<String, dynamic> json) {
    return DeleteCustomerModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      customer: json['customer'],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'customer': customer,
  };
}
