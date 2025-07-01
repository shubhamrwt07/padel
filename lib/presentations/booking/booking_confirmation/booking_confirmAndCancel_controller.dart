import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

class BookingConfirmAndCancelController extends GetxController{
  RxBool cancelBooking = false.obs;
  RxString selectedReason = ''.obs;
  TextEditingController otherReasonController = TextEditingController();

  List<String> cancellationReasons = [
    "Change of plans",
    "Found better timing",
    "Other"
  ];

}