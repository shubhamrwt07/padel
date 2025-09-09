import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/data/request_models/booking/boking_history_model.dart';
import 'package:padel_mobile/handler/logger.dart';
import 'package:padel_mobile/repositories/bookinghisory/booking_history_repository.dart';

class PaymentWalletController extends GetxController{

  ///Payment Details Api--------------------------------------------------------
  var isLoading = false.obs;
  BookingHistoryRepository repository = Get.put(BookingHistoryRepository());
  var paymentList = <BookingHistoryData>[].obs;
  Future<void>fetchPaymentDetails()async{
    isLoading.value = true;
    try{
      final response = await repository.getBookingHistory(type: "");
      if(response.success == true){
        paymentList.assignAll(response.data??[]);
        CustomLogger.logMessage(msg: "Payment Data Fetched :-> $paymentList", level: LogLevel.info);
      }

    }catch(e){
      CustomLogger.logMessage(msg: "Error :-> $e", level: LogLevel.error);
    }finally{
      isLoading.value = false;
    }
  }
  @override
  void onInit()async {
    await fetchPaymentDetails();
    super.onInit();
  }
  String formatDate(String bookingDate) {
    final dateTime = DateTime.parse(bookingDate);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

}