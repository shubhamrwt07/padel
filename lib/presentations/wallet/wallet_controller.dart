import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/loader_widgets.dart';
import 'package:padel_mobile/configs/components/snack_bars.dart';
import 'package:padel_mobile/data/response_models/wallet/get_wallet_model.dart';
import 'package:padel_mobile/data/response_models/wallet/transaction_history_model.dart';
import 'package:padel_mobile/handler/logger.dart';
import 'package:padel_mobile/repositories/wallet_repository/wallet_repository.dart';

class WalletController extends GetxController{
  final WalletRepository repository = Get.put(WalletRepository());
  
  var isLoading = false.obs;
  var isAddingBalance = false.obs;
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

  Future<void> createBalance(int amount) async {
    try {
      isAddingBalance.value = true;
      final data = {"balance": amount};
      final response = await repository.testCreateWalletBalance(data: data);
      Get.back();
      if(response.status == 200){
        SnackBarUtils.showSuccessSnackBar("Balance added successfully'");
      }
      fetchWallet();
      fetchTransaction();
    } catch (e) {
      // Get.snackbar(
      //   'Error',
      //   'Failed to add balance',
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
      CustomLogger.logMessage(msg: "ERROR->$e", level: LogLevel.error);
    } finally {
      isAddingBalance.value = false;
    }
  }

  void showAddBalanceDialog() {
    final TextEditingController amountController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text('Add Balance'),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter amount',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
            onPressed: isAddingBalance.value ? null : () {
              final amount = int.tryParse(amountController.text) ?? 0;
              if (amount > 0) {
                createBalance(amount);
              }
            },
            child: isAddingBalance.value 
                ? SizedBox(width: 20, height: 20, child: LoadingWidget(color: AppColors.primaryColor,))
                : Text('Add'),
          )),
        ],
      ),
    );
  }
}