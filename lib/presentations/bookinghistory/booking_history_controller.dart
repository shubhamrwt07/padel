import '../../data/request_models/booking/boking_history_model.dart';
import '../../repositories/bookinghisory/booking_history_repository.dart';
import '../auth/forgot_password/widgets/forgot_password_exports.dart';

class BookingHistoryController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final BookingHistoryRepository bookingRepo = BookingHistoryRepository();

  Rx<BookingHistoryModel?> upcomingBookings = Rx<BookingHistoryModel?>(null);
  Rx<BookingHistoryModel?> completedBookings = Rx<BookingHistoryModel?>(null);
  Rx<BookingHistoryModel?> cancelledBookings = Rx<BookingHistoryModel?>(null); // ✅ new

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this); // ✅ updated to 3 tabs

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        print("Current tab: ${tabController.index}");
      }
    });

    fetchBookings();
    super.onInit();
  }

  void fetchBookings() async {
    try {
      print("Starting to fetch booking data...");
      isLoading.value = true;
      errorMessage.value = '';

      // Fetch upcoming bookings
      print("Fetching upcoming bookings...");
      final upcoming = await bookingRepo.getBookingHistory(type: "upcoming");
      upcomingBookings.value = upcoming;

      // Fetch completed bookings
      print("Fetching completed bookings...");
      final completed = await bookingRepo.getBookingHistory(type: "completed");
      completedBookings.value = completed;

      // Fetch cancelled bookings ✅
      print("Fetching cancelled bookings...");
      final cancelled = await bookingRepo.getBookingHistory(type: "cancelled");
      cancelledBookings.value = cancelled;

      update();
    } catch (e) {
      print("Error fetching bookings: $e");
      errorMessage.value = "Failed to fetch bookings: $e";
    } finally {
      isLoading.value = false;
      print("Finished fetching bookings. Loading: ${isLoading.value}");
    }
  }

  void refreshBookings() {
    fetchBookings();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
