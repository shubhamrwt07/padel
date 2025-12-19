class GetWalletModel {
  final String? id;
  final String? userId;
  final int? balance;
  final bool? isActive;

  const GetWalletModel({
    this.id,
    this.userId,
    this.balance,
    this.isActive,
  });

  factory GetWalletModel.fromJson(Map<String, dynamic> json) {
    return GetWalletModel(
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
