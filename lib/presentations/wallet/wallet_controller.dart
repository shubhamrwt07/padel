import 'package:get/get.dart';
import 'package:padel_mobile/data/response_models/wallet/get_wallet_model.dart';
import 'package:padel_mobile/data/response_models/wallet/transaction_history_model.dart';
import 'package:padel_mobile/handler/logger.dart';
import 'package:padel_mobile/repositories/wallet_repository/wallet_repository.dart';

class WalletController extends GetxController{
  final WalletRepository repository = Get.put(WalletRepository());
  
  var isLoading = false.obs;
  var transactionList = <Transaction>[].obs;
  var walletBalance = 0.obs;
  
  Future<void> fetchTransaction() async {
    try {
      isLoading.value = true;
      final response = await repository.getTransaction();
      if (response.status == 200) {
        transactionList.value = response.transactions ?? [];
      }
    } catch (e) {
      CustomLogger.logMessage(msg: "ERROR->$e", level: LogLevel.error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWallet() async {
    try {
      final response = await repository.getWallet();
      walletBalance.value = response.balance ?? 0;
    } catch (e) {
      CustomLogger.logMessage(msg: "ERROR->$e", level: LogLevel.error);
    }
  }
}