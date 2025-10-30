import '../../data/request_models/booking/boking_history_model.dart';
import '../../repositories/bookinghisory/booking_history_repository.dart';
import '../auth/forgot_password/widgets/forgot_password_exports.dart';

class BookingHistoryController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  late ScrollController scrollController;

  final BookingHistoryRepository bookingRepo = BookingHistoryRepository();

  Rx<BookingHistoryModel?> upcomingBookings = Rx<BookingHistoryModel?>(null);
  Rx<BookingHistoryModel?> completedBookings = Rx<BookingHistoryModel?>(null);
  Rx<BookingHistoryModel?> cancelledBookings = Rx<BookingHistoryModel?>(null);

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
    tabController = TabController(length: 3, vsync: this);
    scrollController = ScrollController();

    // Add scroll listener for pagination
    scrollController.addListener(() {
      if (!scrollController.hasClients) return;

      final currentPosition = scrollController.position.pixels;
      final maxExtent = scrollController.position.maxScrollExtent;
      final threshold = maxExtent - 200;

      if (currentPosition >= threshold) {
        final currentTabIndex = tabController.index;
        String type = "upcoming";
        if (currentTabIndex == 1) type = "completed";
        if (currentTabIndex == 2) type = "cancelled";

        if (hasMoreData(type) && !isLoadingMore.value) {
          loadMoreBookings(type);
        }
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
      print("Upcoming response - page: ${upcoming.page}, totalPages: ${upcoming.totalPages}, data length: ${upcoming.data?.length}");

      if (upcoming.data == null) upcoming.data = [];
      upcomingBookings.value = upcoming;

      // Safe null check
      if (upcoming.totalPages != null && upcoming.page != null) {
        upcomingHasMore.value = upcoming.page! < upcoming.totalPages!;
      } else {
        upcomingHasMore.value = false;
      }

      // Fetch completed bookings
      print("Fetching completed bookings...");
      final completed = await bookingRepo.getBookingHistory(type: "completed", page: 1, limit: 10);
      print("Completed response - page: ${completed.page}, totalPages: ${completed.totalPages}, data length: ${completed.data?.length}");

      if (completed.data == null) completed.data = [];
      completedBookings.value = completed;

      if (completed.totalPages != null && completed.page != null) {
        completedHasMore.value = completed.page! < completed.totalPages!;
      } else {
        completedHasMore.value = false;
      }

      // Fetch cancelled bookings
      print("Fetching cancelled bookings...");
      final cancelled = await bookingRepo.getBookingHistory(type: "cancelled", page: 1, limit: 10);
      print("Cancelled response - page: ${cancelled.page}, totalPages: ${cancelled.totalPages}, data length: ${cancelled.data?.length}");

      if (cancelled.data == null) cancelled.data = [];
      cancelledBookings.value = cancelled;

      if (cancelled.totalPages != null && cancelled.page != null) {
        cancelledHasMore.value = cancelled.page! < cancelled.totalPages!;
      } else {
        cancelledHasMore.value = false;
      }

      update();
    } catch (e, stackTrace) {
      print("Error fetching bookings: $e");
      print("Stack trace: $stackTrace");
      errorMessage.value = "Failed to fetch bookings: $e";
    } finally {
      isLoading.value = false;
    }
  }

  void loadMoreBookings(String type) async {
    if (isLoadingMore.value) {
      print("Already loading more data, skipping...");
      return;
    }

    if (!hasMoreData(type)) {
      print("No more $type data available");
      return;
    }

    try {
      isLoadingMore.value = true;

      BookingHistoryModel? newData;
      int nextPage;

      switch (type) {
        case "upcoming":
          nextPage = upcomingPage.value + 1;
          print("Loading upcoming page: $nextPage");

          newData = await bookingRepo.getBookingHistory(type: type, page: nextPage, limit: 10);
          print("Upcoming page $nextPage - page: ${newData.page}, totalPages: ${newData.totalPages}, data: ${newData.data?.length}");

          if (newData.data != null && newData.data!.isNotEmpty) {
            upcomingBookings.value ??= BookingHistoryModel();
            upcomingBookings.value!.data ??= [];
            upcomingBookings.value!.data!.addAll(newData.data!);
            upcomingPage.value = nextPage;

            // Safe check
            if (newData.totalPages != null && newData.page != null) {
              upcomingHasMore.value = newData.page! < newData.totalPages!;
            } else {
              upcomingHasMore.value = false;
            }

            print("Updated upcoming: page $nextPage, hasMore: ${upcomingHasMore.value}");
            upcomingBookings.refresh(); // Force UI update
          } else {
            upcomingHasMore.value = false;
            print("No more upcoming data available");
          }
          break;

        case "completed":
          nextPage = completedPage.value + 1;
          print("Loading completed page: $nextPage");

          newData = await bookingRepo.getBookingHistory(type: type, page: nextPage, limit: 10);
          print("Completed page $nextPage - page: ${newData.page}, totalPages: ${newData.totalPages}, data: ${newData.data?.length}");

          if (newData.data != null && newData.data!.isNotEmpty) {
            completedBookings.value ??= BookingHistoryModel();
            completedBookings.value!.data ??= [];
            completedBookings.value!.data!.addAll(newData.data!);
            completedPage.value = nextPage;

            if (newData.totalPages != null && newData.page != null) {
              completedHasMore.value = newData.page! < newData.totalPages!;
            } else {
              completedHasMore.value = false;
            }

            print("Updated completed: page $nextPage, hasMore: ${completedHasMore.value}");
            completedBookings.refresh();
          } else {
            completedHasMore.value = false;
            print("No more completed data available");
          }
          break;

        case "cancelled":
          nextPage = cancelledPage.value + 1;
          print("Loading cancelled page: $nextPage");

          newData = await bookingRepo.getBookingHistory(type: type, page: nextPage, limit: 10);
          print("Cancelled page $nextPage - page: ${newData.page}, totalPages: ${newData.totalPages}, data: ${newData.data?.length}");

          if (newData.data != null && newData.data!.isNotEmpty) {
            cancelledBookings.value ??= BookingHistoryModel();
            cancelledBookings.value!.data ??= [];
            cancelledBookings.value!.data!.addAll(newData.data!);
            cancelledPage.value = nextPage;

            if (newData.totalPages != null && newData.page != null) {
              cancelledHasMore.value = newData.page! < newData.totalPages!;
            } else {
              cancelledHasMore.value = false;
            }

            print("Updated cancelled: page $nextPage, hasMore: ${cancelledHasMore.value}");
            cancelledBookings.refresh();
          } else {
            cancelledHasMore.value = false;
            print("No more cancelled data available");
          }
          break;
      }

      update();
    } catch (e, stackTrace) {
      print("Error loading more bookings: $e");
      print("Stack trace: $stackTrace");
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