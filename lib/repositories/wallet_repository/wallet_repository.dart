import 'package:padel_mobile/core/endpoitns.dart';
import 'package:padel_mobile/core/network/dio_client.dart';
import 'package:padel_mobile/data/response_models/wallet/get_wallet_model.dart';
import 'package:padel_mobile/data/response_models/wallet/transaction_history_model.dart';
import 'package:padel_mobile/handler/logger.dart';

class WalletRepository {
  static final WalletRepository _instance = WalletRepository._internal();
  final DioClient dioClient = DioClient();

  factory WalletRepository() {
    return _instance;
  }

  WalletRepository._internal();

  ///Get Transaction-----------------------------------------------------------------
  Future<TransactionHistoryModel> getTransaction() async {
    try {
      final response = await dioClient.get(
        AppEndpoints.getTransaction,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomLogger.logMessage(
          msg: "Get-Transaction Data: ${response.data}",
          level: LogLevel.info,
        );
        return TransactionHistoryModel.fromJson(response.data);
      } else {
        throw Exception("Get-Transaction failed: ${response.statusCode}");
      }
    } catch (e, st) {
      CustomLogger.logMessage(
        msg: "Get-Transaction failed with error: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }

  ///Get Wallet-----------------------------------------------------------------
  Future<GetWalletModel> getWallet() async {
    try {
      final response = await dioClient.get(
        AppEndpoints.getWallet,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomLogger.logMessage(
          msg: "Get-Wallet Data: ${response.data}",
          level: LogLevel.info,
        );
        return GetWalletModel.fromJson(response.data);
      } else {
        throw Exception("Get-Wallet failed: ${response.statusCode}");
      }
    } catch (e, st) {
      CustomLogger.logMessage(
        msg: "Get-Wallet failed with error: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }
}