import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

class AllSuggestionsController extends GetxController{
  RxString selectedSlot = 'Morning'.obs;
  RxBool showFilter = false.obs;
  final List<String> slots = ['Morning', 'Afternoon', 'Evening'];
  final RxString selectedCategory = 'Select Category'.obs;

  //SELECT CATEGORY-------------------------------------------------------------

  final List<String> categories = ['Level A', 'Level B', 'Level C'];
  final GlobalKey dropdownKey = GlobalKey();

  void selectSlot(String slot) {
    selectedSlot.value = slot;
  }

  //DATE------------------------------------------------------------------------

  var selectedDate = DateTime.now().obs;

  Future<void> selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: now,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: const TextTheme(
              // Customize as needed
              titleLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              bodyLarge: TextStyle(fontSize: 14),
              bodyMedium: TextStyle(fontSize: 12),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      selectedDate.value = pickedDate;
    }
  }
}