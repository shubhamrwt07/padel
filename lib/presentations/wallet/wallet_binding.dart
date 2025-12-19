import 'package:get/get.dart';
import 'package:padel_mobile/presentations/wallet/wallet_controller.dart';

class WalletBinding implements Bindings{
  @override
  void dependencies() {
   Get.put(WalletController());
  }

}