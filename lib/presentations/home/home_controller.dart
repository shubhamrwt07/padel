import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/request_models/home_models/get_club_name_model.dart';
import '../../repositories/home_repository/home_repository.dart';

class HomeController extends GetxController {
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

  // DATE ----------------------------------------------------------------------
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

  // CLUB DATA -----------------------------------------------------------------
  final HomeRepository clubRepository = HomeRepository();

  Rx<CourtsModel> courtsData=CourtsModel().obs;
  RxBool isLoadingClub = false.obs;
  RxBool isLoadingMore = false.obs;
  RxString clubError = ''.obs;
  RxInt currentPage = 1.obs;
  final int limit = 10;
  RxString searchQuery = ''.obs;
  RxBool hasMoreData = true.obs;

  /// Fetch clubs with pagination
  Future<void> fetchClubs({bool isRefresh = false}) async {
    log("message");


      final result = await clubRepository.fetchClubData(
        limit: limit.toString(),
        page: currentPage.value.toString(),
        search: searchQuery.value,
      );
    courtsData.value=result;


  }

  /// Search clubs
  void searchClubs(String query) {
    searchQuery.value = query;
    fetchClubs(isRefresh: true);
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((v) async {
      await fetchClubs();
    });
  }
}
