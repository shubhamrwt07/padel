import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

class AllSuggestionsController extends GetxController{
  RxString selectedSlot = 'Morning'.obs;

  final List<String> slots = ['Morning', 'Afternoon', 'Evening'];

  void selectSlot(String slot) {
    selectedSlot.value = slot;
  }
}