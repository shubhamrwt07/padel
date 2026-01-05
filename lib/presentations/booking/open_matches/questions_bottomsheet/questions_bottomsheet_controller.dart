import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/presentations/openmatchbooking/openmatch_booking_controller.dart';
import 'package:padel_mobile/presentations/profile/profile_controller.dart';
import 'package:padel_mobile/presentations/home/home_controller.dart';
import 'package:padel_mobile/repositories/openmatches/open_match_repository.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../configs/app_colors.dart';
import '../../../../configs/components/loader_widgets.dart';
import '../../../../configs/components/snack_bars.dart';
import '../../../../data/request_models/home_models/get_available_court.dart';
import '../../../../handler/logger.dart';
import '../../../../services/payment_services/razorpay.dart';
import '../../../cart/cart_controller.dart';

class QuestionsBottomsheetController extends GetxController {
  OpenMatchRepository repository = OpenMatchRepository();
  RxBool isProcessing = false.obs;
  RxString gameType = ''.obs;
  RxString selectedGameLevel = ''.obs;
  RxString selectedGameType = ''.obs;
  RxString selectedMatchType = ''.obs;
  late RazorpayPaymentService _paymentService;
  CartController get cartController => Get.find<CartController>();
  final storage = GetStorage();
  
  OpenMatchBookingController openMatchBookingController = Get.put(OpenMatchBookingController());
  ProfileController profileController = Get.put(ProfileController());
  HomeController homeController = Get.put(HomeController());
  
  // Local match data from create open matches controller
  Map<String, dynamic> localMatchData = {};
  
  // Validation method
  bool validateSelections() {
    if (selectedGameLevel.value.isEmpty) {
      SnackBarUtils.showInfoSnackBar("Please select a game level");
      return false;
    }
    if (selectedGameType.value.isEmpty) {
      SnackBarUtils.showInfoSnackBar("Please select a game type");
      return false;
    }
    if (selectedMatchType.value.isEmpty) {
      SnackBarUtils.showInfoSnackBar("Please select a match type");
      return false;
    }
    return true;
  }
  
  RxList<Map<String, dynamic>> teamA = <Map<String, dynamic>>[{
    "name": "",
    "image": "",
    "userId": "",
  }].obs;

  RxList<Map<String, dynamic>> teamB = <Map<String, dynamic>>[].obs;

  // Modified method to handle payment success callback
  Future<void> onPaymentSuccess({
    required String paymentId,
    required String orderId,
    required String signature,
  }) async {
    log("🎉 Payment successful - ID: $paymentId, Order: $orderId, Signature: $signature");
    log("🚀 About to call createMatchAfterPayment");

    try {
      isProcessing.value = true;
      Get.generalDialog(
        barrierDismissible: false,
        barrierColor: Colors.white,
        pageBuilder: (_, __, ___) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoadingWidget(color: AppColors.primaryColor, size: 30),
                  const SizedBox(height: 20),
                  const Text(
                    "Creating your open match...",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please wait while we set up your match.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      );
      
      await createMatchAfterPayment();
    } catch (e) {
      log("Error after payment success: $e");
      SnackBarUtils.showErrorSnackBar("Payment successful but match creation failed: $e");
    } finally {
      isProcessing.value = false;
    }
  }

  // Handle payment failure
  void onPaymentError(String error) {
    log("Payment failed: $error");
    isProcessing.value = false;
    SnackBarUtils.showErrorSnackBar("Payment failed: $error");
  }

  // Create match after payment success
  var openMatchId = ''.obs;
  Future<void> createMatchAfterPayment() async {
    log("🚀 Starting createMatchAfterPayment method");
    try {
      final matchDateValue = localMatchData["matchDate"];
      DateTime? parsedMatchDate;

      if (matchDateValue is DateTime) {
        parsedMatchDate = matchDateValue;
      } else if (matchDateValue != null) {
        parsedMatchDate = DateTime.tryParse(matchDateValue.toString());
      }

      if (parsedMatchDate == null) {
        log("⚠️ No valid matchDate found in localMatchData, using today");
        parsedMatchDate = DateTime.now();
      }

      final formattedMatchDate = DateFormat('yyyy-MM-dd').format(parsedMatchDate);
      final formattedBookingDate = DateTime.utc(parsedMatchDate.year, parsedMatchDate.month, parsedMatchDate.day).toIso8601String();
      
      final slotData = (localMatchData["slot"] as List?)?.cast<Slots>() ?? [];
      final courtId = localMatchData["courtId"]?.toString() ?? "";
      final courtIds = (localMatchData["courtIds"] as List?)?.map((e) => e.toString()).toList() ?? [];
      final courtName = localMatchData["courtName"]?.toString() ?? "";

      final slotsJson = slotData.asMap().entries.map((entry) {
        final index = entry.key;
        final slot = entry.value;

        String slotCourtId = courtId;
        if (courtIds.isNotEmpty && index < courtIds.length) {
          slotCourtId = courtIds[index];
        }

        return {
          "slotId": slot.sId ?? "",
          "businessHours": slot.businessHours?.map((bh) => {
            "time": bh.time ?? "",
            "day": bh.day ?? "",
          }).toList() ?? [],
          "slotTimes": [
            {
              "time": slot.time ?? "",
              "amount": slot.amount ?? 0,
            }
          ],
          "matchType":selectedMatchType.value,
          "courtName": courtName,
          "courtId": slotCourtId,
          "bookingDate": formattedBookingDate,
          "duration": slot.duration ?? 60,
          "totalTime": slot.duration ?? 60,
          "bookingTime": slot.bookingTime ?? slot.time ?? ""
        };
      }).toList();

      final body = {
        "slot": slotsJson,
        "clubId": localMatchData["clubId"] ?? "",
        "matchDate": formattedMatchDate,
        // "skillLevel": localMatchData["skillLevel"] ?? "",
        "skillLevel": selectedGameLevel.value,
        // "skillDetails": localMatchData["skillDetails"] ?? [],
        // "customerScale": localMatchData["customerScale"] ?? "",
        // "customerRacketSport": localMatchData["customerRacketSport"] ?? "",
        // "receivingTP": localMatchData["receivingTP"] ?? "",
        // "customerAge": localMatchData["customerAge"] ?? "",
        // "volleyNetPositioning": localMatchData["volleyNetPositioning"] ?? "",
        // "playerLevel": localMatchData["playerLevel"] ?? "",
        // "reboundSkills": localMatchData["reboundSkills"] ?? "",
        "matchStatus": "open",
        "matchTime": localMatchData["matchTime"] ?? "",
        "gender":selectedGameType.value,
        // "matchType":selectedMatchType.value,
        "teamA": teamA
            .where((p) =>
        (p["userId"] ?? p["_id"]) != null &&
            (p["userId"] ?? p["_id"]).toString().isNotEmpty)
            .map((p) => p["userId"] ?? p["_id"])
            .toList(),
        "teamB": teamB
            .where((p) =>
        (p["userId"] ?? p["_id"]) != null &&
            (p["userId"] ?? p["_id"]).toString().isNotEmpty)
            .map((p) => p["userId"] ?? p["_id"])
            .toList(),
      };

      log("✅ Final Match Request Body:");
      log(body.toString());
      final cleanedBody = removeEmpty(body);
      log("📦 Final Cleaned Body:");
      log(cleanedBody.toString());

      final response = await repository.createMatch(data: cleanedBody);
      log("🎯 Match Created -> ${response.toJson()}");
      openMatchId.value = response.matches?[0].id??"";
      SnackBarUtils.showSuccessSnackBar("Match created successfully!");
      CustomLogger.logMessage(msg: "MEWW-> ${response.message??""}", level: LogLevel.debug);
      // await createBooking();

      Get.offAllNamed(RoutesName.bottomNav);
      openMatchBookingController.fetchOpenMatchesBooking(type: 'upcoming');
    } catch (e, st) {
      log("❌ Match creation error: $e\n$st");
      Get.close(2);
      showBookingErrorDialog();
    }
  }


  Map<String, dynamic> removeEmpty(Map<String, dynamic> json) {
    json.removeWhere((key, value) =>
    value == null ||
        value == "" ||
        (value is List && value.isEmpty));
    return json;
  }
  
  void showBookingErrorDialog() {
    Get.generalDialog(
      barrierDismissible: false,
      barrierColor: Colors.white,
      pageBuilder: (_, __, ___) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 80,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Booking Failed",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Your booking could not be completed right now.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Your payment has been received successfully, "
                        "but we couldn't confirm your booking at this moment.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please contact support for assistance or a refund.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed(RoutesName.bottomNav);
                      },
                      child: const Text(
                        "Go to Home",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: AppColors.primaryColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed(RoutesName.support);
                      },
                      child: Text(
                        "Help & Support",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Main method for direct payment
  Future<void> initiatePaymentAndCreateMatch() async {
    log("💳 Starting payment initiation process");
    if (!validateSelections()) {
      return;
    }
    
    if (!validateTeams()) {
      SnackBarUtils.showWarningSnackBar("Please add required players to both teams");
      return;
    }

    isProcessing.value = true;

    try {
      final priceString = localMatchData['price']?.toString() ?? '0';
      final price = double.tryParse(priceString.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;

      if (price <= 0) {
        SnackBarUtils.showErrorSnackBar("Invalid price amount");
        isProcessing.value = false;
        return;
      }

      await _paymentService.initiatePayment(
        keyId: 'rzp_test_1DP5mmOlF5G5ag',
        amount: price,
        currency: 'INR',
        name: 'Swoot',
        description: 'Payment for court booking and match creation',
        orderId: '',
        userEmail: profileController.profileModel.value?.response?.email ?? 'test@example.com',
        userContact: '9999999999',
        notes: {
          'user_id': profileController.profileModel.value?.response?.sId ?? '123',
          'club_id': localMatchData['clubId'],
          'match_date': localMatchData['matchDate'].toString(),
          'match_time': localMatchData['matchTime'].toString(),
        },
        theme: '#F37254',
        paymentMethods: ['card', 'netbanking', 'upi', 'wallet'],
      );
    } catch (e) {
      isProcessing.value = false;
      log("Payment initiation error: $e");
      SnackBarUtils.showErrorSnackBar("Failed to initiate payment: $e");
    }
  }

  bool validateTeams() {
    bool teamAValid = teamA.isNotEmpty &&
        teamA.any((player) =>
        player['name'] != null &&
            player['name'].toString().isNotEmpty &&
            player['userId'] != null &&
            player['userId'].toString().isNotEmpty);
    return teamAValid;
  }

  @override
  void onInit() {
    _paymentService = RazorpayPaymentService();

    _paymentService.onPaymentSuccess = (response) {
      onPaymentSuccess(
        paymentId: response.paymentId ?? '',
        orderId: response.orderId ?? '',
        signature: response.signature ?? '',
      );
    };

    _paymentService.onPaymentFailure = (response) {
      String errorMessage = 'Payment failed';
      if (response.code == Razorpay.PAYMENT_CANCELLED) {
        errorMessage = 'Payment was cancelled';
      } else if (response.message != null) {
        errorMessage = response.message!;
      }
      onPaymentError(errorMessage);
    };

    _paymentService.onExternalWallet = (response) {
      log('External wallet used: ${response.walletName}');
    };

    profileController.fetchUserProfile();
    
    // Get local match data from arguments
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      localMatchData = args;
    }
    
    // Add profile data to teamA
    String skillLevel = "";
    if ((localMatchData['playerLevel'] ?? '').toString().isNotEmpty) {
      skillLevel = localMatchData['playerLevel'].toString();
    } else {
      final skillDetails = localMatchData['skillDetails'];
      if (skillDetails != null && skillDetails is List && skillDetails.isNotEmpty) {
        skillLevel = skillDetails.last.toString();
      } else if (localMatchData['skillLevel'] != null) {
        skillLevel = localMatchData['skillLevel'].toString();
      }
    }

    Map<String, dynamic> profileData = <String, dynamic>{
      "name": profileController.profileModel.value?.response!.name ?? "",
      "lastName": profileController.profileModel.value?.response?.lastName??"",
      "image": profileController.profileModel.value?.response!.profilePic ?? "",
      "userId": profileController.profileModel.value?.response!.sId ?? "",
      "level": profileController.profileModel.value?.response!.playerLevel?.split(' ').first??"",
      "levelLabel": skillLevel,
   };

    teamA.first.addAll(profileData);
    
    super.onInit();
  }

  @override
  void onClose() {
    _paymentService.dispose();
    super.onClose();
  }
}