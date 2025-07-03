import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

class FiltersController extends GetxController{
  RxString selectedLocation = ''.obs;
  RxBool isAmPm = false.obs;
  Rx<bool> viewUnavailableSlots = false.obs;

  List<String> locations = ["New Delhi", "Mumbai", "Bangalore"];

  var startDate = ''.obs;
  var endDate = ''.obs;
  var startTime = ''.obs;
  var endTime = ''.obs;
  var selectedOption = 'Relevance'.obs;
  final List<String> sortOptions = [
    'Relevance',
    'Number of players',
    'Most relevant',
    'Nearest',
  ];
  var playWithOptions = ['Men only', 'Women only', 'Mixed'];
  var selectedPlayWith = ''.obs;
  var amenitiesFilters = [
    'Parking',
    'Washrooms',
    'Floodlights (for night matches)',
    'Changing Room',
    'Spectator Area',
    'Refreshments or water available',
    'Racket or gear rental',
  ];
  var selectedAmenities = ''.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 20000.0.obs;
  final Rx<RangeValues> selectedRange = const RangeValues(0, 20000).obs;
  final RxDouble selectedPrice = 250.0.obs;
  void clearAllFilters() {
    selectedLocation.value = '';
    startDate.value = '';
    endDate.value = '';
    startTime.value = '';
    endTime.value = '';
    isAmPm.value = false;
    selectedOption.value = '';
    selectedPlayWith.value = '';
    selectedAmenities.value = '';
    selectedPrice.value = minPrice.value;
    selectedRange.value = RangeValues(minPrice.value, maxPrice.value);
  }
}