import 'package:flutter/material.dart';
import 'package:get/get.dart';

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