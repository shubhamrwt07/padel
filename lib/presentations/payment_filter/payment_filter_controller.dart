import 'package:get/get.dart';

class PaymentFilterController extends GetxController {
  // Status (radio)
  var selectedStatus = 'Completed'.obs;

  // Payment Method (single selection like radio)
  var selectedPaymentMethod = ''.obs;

  // Amount (single selection like radio)
  var selectedAmountRange = ''.obs;

  // Date
  var selectedDate = DateTime.now().obs; // <-- Default to current date

  void selectStatus(String status) {
    selectedStatus.value = status;
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value =
    selectedPaymentMethod.value == method ? '' : method;
  }

  void selectAmountRange(String range) {
    selectedAmountRange.value =
    selectedAmountRange.value == range ? '' : range;
  }

  void clearAll() {
    selectedStatus.value = 'Completed';
    selectedPaymentMethod.value = '';
    selectedAmountRange.value = '';
    selectedDate.value = DateTime.now(); // Reset to today's date
  }

  void updateSelectedDate(DateTime? newDate) {
    if (newDate != null) {
      selectedDate.value = newDate;
    }
  }
}