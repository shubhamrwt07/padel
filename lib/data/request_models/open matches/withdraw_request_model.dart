class WithdrawRequestModel {
  final int? status;
  final String? message;

  const WithdrawRequestModel({
    this.status,
    this.message,
  });

  factory WithdrawRequestModel.fromJson(Map<String, dynamic> json) {
    return WithdrawRequestModel(
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
  };
}
