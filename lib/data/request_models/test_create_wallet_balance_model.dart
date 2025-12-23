class TestCreateWalletBalanceModel {
  final int? status;
  final String? message;
  final WalletResponse? response;

  TestCreateWalletBalanceModel({
    this.status,
    this.message,
    this.response,
  });

  factory TestCreateWalletBalanceModel.fromJson(Map<String, dynamic> json) {
    return TestCreateWalletBalanceModel(
      status: json['status'],
      message: json['message'],
      response: json['response'] == null
          ? null
          : WalletResponse.fromJson(json['response']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    if (response != null) 'response': response!.toJson(),
  };
}

class WalletResponse {
  final String? id;
  final String? userId;
  final int? balance;
  final bool? isActive;

  WalletResponse({
    this.id,
    this.userId,
    this.balance,
    this.isActive,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      id: json['_id'],
      userId: json['userId'],
      balance: json['balance'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'userId': userId,
    'balance': balance,
    'isActive': isActive,
  };
}
