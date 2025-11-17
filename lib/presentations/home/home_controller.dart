import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/components/snack_bars.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/core/network/dio_client.dart';
import 'package:padel_mobile/data/request_models/booking/boking_history_model.dart';
import 'package:padel_mobile/handler/logger.dart';
import 'package:padel_mobile/presentations/profile/profile_controller.dart';
import 'package:padel_mobile/repositories/bookinghisory/booking_history_repository.dart';
import 'package:padel_mobile/repositories/score_board_repo/score_board_repository.dart';
import '../../data/request_models/home_models/get_club_name_model.dart';
import '../../repositories/home_repository/home_repository.dart';

class HomeController extends GetxController {
  ProfileController profileController = Get.put(ProfileController());
  // LOCATION ------------------------------------------------------------------
  final RxString selectedLocation = ''.obs;
  RxBool showLocationAndDate = false.obs;
  ScrollController scrollController = ScrollController();

  final List<String> dummyLocations = [
    'Delhi',
    'Mumbai',
    'Bangalore',
    'Hyderabad',
    'Chennai',
    'Pune',
    'Kolkata',
    'Jaipur',
    'Ahmedabad',
    'Chandigarh',
  ];

  // DATE -------------------------
  var selectedDate = DateTime.now().obs;

  Future<void> selectDate(BuildContext context) async {
    try {
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
                titleLarge: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
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
    } catch (e) {
      log("Error selecting date: $e");
      // Handle date selection error gracefully
    }
  }

  // CLUB DATA -----------------------------------------------------------------
  final HomeRepository clubRepository = HomeRepository();

  // Using nullable type for proper null handling
  Rx<CourtsModel?> courtsData = Rx<CourtsModel?>(null);
  RxBool isLoadingClub = false.obs;
  RxBool isLoadingMore = false.obs;
  RxString clubError = ''.obs;
  RxInt currentPage = 1.obs;
  final int limit = 20;
  RxString searchQuery = ''.obs;
  RxBool hasMoreData = true.obs;

  RxBool isInitialized = false.obs;
  RxInt totalCourts = 0.obs;

  // State getters for better state management
  bool get isInitialLoading {
    return isLoadingClub.value && !isInitialized.value;
  }

  bool get hasErrorWithNoData {
    return clubError.value.isNotEmpty && !hasCourtsData;
  }

  bool get shouldShowEmptyState {
    return !hasCourtsData &&
        isInitialized.value &&
        !isLoadingClub.value &&
        clubError.value.isEmpty;
  }

  // Check if courts data is available
  bool get hasCourtsData {
    return courtsData.value != null &&
        courtsData.value!.data != null &&
        courtsData.value!.data!.courts != null &&
        courtsData.value!.data!.courts!.isNotEmpty;
  }

  /// Get courts list safely
  List<dynamic> get courtsList {
    if (hasCourtsData) {
      return courtsData.value!.data!.courts!;
    }
    return [];
  }

  /// Get courts count safely
  int get courtsCount {
    return courtsList.length;
  }

  /// Fetch clubs with pagination and comprehensive error handling
  Future<void> fetchClubs({bool isRefresh = false}) async {
    try {
      log("Fetching clubs - Page: ${currentPage.value}, Search: ${searchQuery.value}");

      if (isRefresh || currentPage.value == 1) {
        isLoadingClub.value = true;
        clubError.value = '';
        hasMoreData.value = true;
      } else {
        isLoadingMore.value = true;
      }

      // Make API call
      final result = await clubRepository.fetchClubData(
        limit: limit.toString(),
        page: currentPage.value.toString(),
        search: searchQuery.value,
      );

      log("Courts length ${result.data?.courts?.length ?? 0}");

      // Handle successful response
      if (result.data?.courts != null) {
        if (isRefresh || currentPage.value == 1) {
          courtsData.value = result;
        } else {
          // Merge new data with existing data
          if (courtsData.value?.data?.courts != null) {
            final existingCourts = courtsData.value!.data!.courts!;
            final newCourts = result.data!.courts!;

            existingCourts.addAll(newCourts);

            // Check if more data is available
            hasMoreData.value = newCourts.length >= limit;
          }
        }

        // Update total count
        totalCourts.value = courtsData.value?.data?.courts?.length ?? 0;

        // Clear any existing errors
        clubError.value = '';
      }

      // Mark as initialized after first successful fetch
      if (!isInitialized.value) {
        isInitialized.value = true;
      }

      log("Successfully fetched ${courtsData.value?.data?.courts?.length ?? 0} courts");

    } catch (e) {
      log("Error fetching clubs: $e");

      // Set appropriate error message
      if (e.toString().contains('network') || e.toString().contains('connection')) {
        clubError.value = 'Network error. Please check your connection and try again.';
      } else if (e.toString().contains('timeout')) {
        clubError.value = 'Request timeout. Please try again.';
      } else if (e.toString().contains('server')) {
        clubError.value = 'Server error. Please try again later.';
      } else {
        clubError.value = 'Failed to load courts. Please try again.';
      }

      // Only mark as initialized if this was the first attempt
      if (!isInitialized.value && (isRefresh || currentPage.value == 1)) {
        isInitialized.value = true;
      }

    } finally {
      // Reset loading states
      isLoadingClub.value = false;
      isLoadingMore.value = false;
    }
  }

  /// Load more data for pagination with better error handling
  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMoreData.value || !isInitialized.value) {
      return;
    }

    try {
      currentPage.value++;
      await fetchClubs();
    } catch (e) {
      // Revert page increment on error
      currentPage.value = (currentPage.value - 1).clamp(1, currentPage.value);
      log("Error loading more: $e");
    }
  }

  /// Search clubs with debouncing
  void searchClubs(String query) {
    searchQuery.value = query.trim();
    currentPage.value = 1;
    hasMoreData.value = true;
    fetchClubs(isRefresh: true);
  }

  /// Retry fetching data
  Future<void> retryFetch() async {
    clubError.value = '';
    currentPage.value = 1;
    hasMoreData.value = true;
    isInitialized.value = false;

    await Future.wait([
      fetchClubs(isRefresh: true),
      fetchBookings(),
    ]);
  }

  /// Clear search and reset data
  void clearSearch() {
    searchQuery.value = '';
    currentPage.value = 1;
    hasMoreData.value = true;
    fetchClubs(isRefresh: true);
  }

  /// Update selected location
  void updateLocation(String location) {
    selectedLocation.value = location;
    // Optionally refresh data based on location
  }

  bool get isLoadingAll => isLoadingClub.value || isLoadingBookings.value;

  ///Your Bookings--------------------------------------------------------------
  var bookings = Rxn<BookingHistoryModel>();
  BookingHistoryRepository bookingHistoryRepository = Get.put(BookingHistoryRepository());
  RxBool isLoadingBookings = false.obs;

  Future<void> fetchBookings() async {
    isLoadingBookings.value = true;
    try {
      final response = await bookingHistoryRepository.getBookingHistory(type: "upcoming");
      bookings.value = response;
      if (response.success == true) {
        CustomLogger.logMessage(msg: "Booking fetched", level: LogLevel.debug);
      }
    } catch (e) {
      CustomLogger.logMessage(msg: e, level: LogLevel.error);
    } finally {
      isLoadingBookings.value = false;
    }
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEE, dd MMM').format(date); // e.g., Thu, 27 June
    } catch (e) {
      return dateStr;
    }
  }

  void showLocationPicker(BuildContext context) async {
    // Example: pick a location via a dialog
    final result = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Select Location'),
        children: dummyLocations
            .map((location) => SimpleDialogOption(
          onPressed: () => Navigator.pop(context, location),
          child: Text(location),
        ))
            .toList(),
      ),
    );

    if (result != null) selectedLocation.value = result;
  }

  @override
  void onInit() {
    super.onInit();
    // notificationService.initialize();
    // var token = notificationService.getToken();
    // log("Firebase Token $token");

    // Initialize scroll controller listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMore();
      }
    });

    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        fetchClubs(isRefresh: true),
        fetchBookings(),
      ]);
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
    ScoreBoardRepository repository = Get.put(ScoreBoardRepository());

  Future<void> createScoreBoard({required String bookingId}) async {
    try {
      // First, check if scoreboard already exists for this booking
      final checkResponse = await repository.getScoreBoard(bookingId: bookingId);

      // Only check data - ignore success field
      bool scoreboardExists = false;

      if (checkResponse.data != null) {
        // Check if data is a list and not empty
        if (checkResponse.data is List) {
          scoreboardExists = (checkResponse.data as List).isNotEmpty;
        }
        // Check if data is an object (not a list)
        else {
          scoreboardExists = true;
        }
      }

      // If scoreboard exists, just navigate - DON'T create
      if (scoreboardExists) {
        Get.toNamed(RoutesName.scoreBoard, arguments: {"bookingId": bookingId});
        CustomLogger.logMessage(
            msg: "ScoreBoard already exists - Navigating without creating - BOOKING ID -> $bookingId",
            level: LogLevel.debug
        );
        return; // Exit early - DON'T hit create API
      }

      // If data is empty array or null, proceed to create
      CustomLogger.logMessage(
          msg: "ScoreBoard doesn't exist (empty data) - Proceeding to create - BOOKING ID -> $bookingId",
          level: LogLevel.debug
      );

      // If we reach here, scoreboard doesn't exist - proceed with creation
      final bookingList = bookings.value?.data ?? [];

      if (bookingList.isEmpty) {
        SnackBarUtils.showInfoSnackBar("No booking data found");
        return;
      }

      // Take first upcoming booking
      final booking = bookingList.first;

      // Create new scoreboard only if it doesn't exist
      final body = {
        "bookingId": bookingId,
        "matchDate": booking.bookingDate ?? "",
        "matchTime": booking.slot?[0].slotTimes?[0].time ?? "",
        "userId": storage.read("userId") ?? "",
        "courtName": booking.slot?[0].courtName ?? "",
        "clubName": booking.registerClubId?.clubName ?? "",
        "teams": [
          {
            "name": "Team A",
            "players": [
              {
                "name": "Team A",
                "playerId": storage.read("userId") ?? "",
              }
            ]
          }
        ]
      };

      final response = await repository.createScoreBoard(data: body);

      if (response.success == true) {
        Get.toNamed(RoutesName.scoreBoard, arguments: {"bookingId": bookingId});
        CustomLogger.logMessage(
            msg: "ScoreBoard Created Successfully - BOOKING ID -> $bookingId",
            level: LogLevel.debug
        );
      }

    } catch (e) {
      CustomLogger.logMessage(msg: "ERROR -> $e", level: LogLevel.error);
      SnackBarUtils.showErrorSnackBar("Failed to load or create scoreboard");
    }
  }}