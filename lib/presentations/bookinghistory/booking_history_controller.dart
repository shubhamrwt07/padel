import '../../data/request_models/booking/boking_history_model.dart';
import '../../repositories/bookinghisory/booking_history_repository.dart';
import '../auth/forgot_password/widgets/forgot_password_exports.dart';

class BookingHistoryController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  late ScrollController scrollController;

  final BookingHistoryRepository bookingRepo = BookingHistoryRepository();

  Rx<BookingHistoryModel?> upcomingBookings = Rx<BookingHistoryModel?>(null);
  Rx<BookingHistoryModel?> completedBookings = Rx<BookingHistoryModel?>(null);
  Rx<BookingHistoryModel?> cancelledBookings = Rx<BookingHistoryModel?>(null); // ✅ new

  // Pagination variables
  RxInt upcomingPage = 1.obs;
  RxInt completedPage = 1.obs;
  RxInt cancelledPage = 1.obs;
  
  RxBool upcomingHasMore = true.obs;
  RxBool completedHasMore = true.obs;
  RxBool cancelledHasMore = true.obs;
  
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this); // ✅ updated to 3 tabs
    scrollController = ScrollController();

    // Add scroll listener for pagination
    scrollController.addListener(() {
      final currentPosition = scrollController.position.pixels;
      final maxExtent = scrollController.position.maxScrollExtent;
      final threshold = maxExtent - 200;
      
      print("Scroll position: $currentPosition, maxExtent: $maxExtent, threshold: $threshold");
      
      if (currentPosition >= threshold) {
        final currentTabIndex = tabController.index;
        String type = "upcoming";
        if (currentTabIndex == 1) type = "completed";
        if (currentTabIndex == 2) type = "cancelled";
        
        print("Scroll threshold reached for tab: $currentTabIndex, type: $type");
        print("hasMoreData: ${hasMoreData(type)}, isLoadingMore: ${isLoadingMore.value}");
        
        if (hasMoreData(type) && !isLoadingMore.value) {
          print("Triggering loadMoreBookings for type: $type");
          loadMoreBookings(type);
        }
      }
    });

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

      // Reset pagination
      upcomingPage.value = 1;
      completedPage.value = 1;
      cancelledPage.value = 1;
      upcomingHasMore.value = true;
      completedHasMore.value = true;
      cancelledHasMore.value = true;

      // Fetch upcoming bookings
      print("Fetching upcoming bookings...");
      final upcoming = await bookingRepo.getBookingHistory(type: "upcoming", page: 1, limit: 10);
      upcomingBookings.value = upcoming;
      upcomingHasMore.value = upcoming.totalPages != null && upcoming.page! < upcoming.totalPages!;

      // Fetch completed bookings
      print("Fetching completed bookings...");
      final completed = await bookingRepo.getBookingHistory(type: "completed", page: 1, limit: 10);
      completedBookings.value = completed;
      completedHasMore.value = completed.totalPages != null && completed.page! < completed.totalPages!;

      // Fetch cancelled bookings ✅
      print("Fetching cancelled bookings...");
      final cancelled = await bookingRepo.getBookingHistory(type: "cancelled", page: 1, limit: 10);
      cancelledBookings.value = cancelled;
      cancelledHasMore.value = cancelled.totalPages != null && cancelled.page! < cancelled.totalPages!;

      update();
    } catch (e) {
      print("Error fetching bookings: $e");
      errorMessage.value = "Failed to fetch bookings: $e";
    } finally {
      isLoading.value = false;
      print("Finished fetching bookings. Loading: ${isLoading.value}");
    }
  }

  void loadMoreBookings(String type) async {
    if (isLoadingMore.value) {
      print("Already loading more data, skipping...");
      return;
    }

    print("loadMoreBookings called for type: $type");
    print("Current hasMore status - upcoming: ${upcomingHasMore.value}, completed: ${completedHasMore.value}, cancelled: ${cancelledHasMore.value}");

    try {
      isLoadingMore.value = true;
      
      BookingHistoryModel? newData;
      int nextPage;
      
      switch (type) {
        case "upcoming":
          if (!upcomingHasMore.value) {
            print("No more upcoming data available");
            return;
          }
          nextPage = upcomingPage.value + 1;
          print("Loading upcoming page: $nextPage");
          newData = await bookingRepo.getBookingHistory(type: type, page: nextPage, limit: 10);
          print("Received ${newData.data?.length ?? 0} upcoming items");
          if (newData.data != null && newData.data!.isNotEmpty) {
            upcomingBookings.value!.data!.addAll(newData.data!);
            upcomingPage.value = nextPage;
            upcomingHasMore.value = newData.totalPages != null && newData.page! < newData.totalPages!;
            print("Updated upcoming: page $nextPage, hasMore: ${upcomingHasMore.value}");
          }
          break;
          
        case "completed":
          if (!completedHasMore.value) {
            print("No more completed data available");
            return;
          }
          nextPage = completedPage.value + 1;
          print("Loading completed page: $nextPage");
          newData = await bookingRepo.getBookingHistory(type: type, page: nextPage, limit: 10);
          print("Received ${newData.data?.length ?? 0} completed items");
          if (newData.data != null && newData.data!.isNotEmpty) {
            completedBookings.value!.data!.addAll(newData.data!);
            completedPage.value = nextPage;
            completedHasMore.value = newData.totalPages != null && newData.page! < newData.totalPages!;
            print("Updated completed: page $nextPage, hasMore: ${completedHasMore.value}");
          }
          break;
          
        case "cancelled":
          if (!cancelledHasMore.value) {
            print("No more cancelled data available");
            return;
          }
          nextPage = cancelledPage.value + 1;
          print("Loading cancelled page: $nextPage");
          newData = await bookingRepo.getBookingHistory(type: type, page: nextPage, limit: 10);
          print("Received ${newData.data?.length ?? 0} cancelled items");
          if (newData.data != null && newData.data!.isNotEmpty) {
            cancelledBookings.value!.data!.addAll(newData.data!);
            cancelledPage.value = nextPage;
            cancelledHasMore.value = newData.totalPages != null && newData.page! < newData.totalPages!;
            print("Updated cancelled: page $nextPage, hasMore: ${cancelledHasMore.value}");
          }
          break;
      }
      
      update();
    } catch (e) {
      print("Error loading more bookings: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  bool hasMoreData(String type) {
    switch (type) {
      case "upcoming":
        return upcomingHasMore.value;
      case "completed":
        return completedHasMore.value;
      case "cancelled":
        return cancelledHasMore.value;
      default:
        return false;
    }
  }

  void refreshBookings() {
    fetchBookings();
  }

  @override
  void onClose() {
    tabController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
