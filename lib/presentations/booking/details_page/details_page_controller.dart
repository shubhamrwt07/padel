import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/core/endpoitns.dart';
import 'package:padel_mobile/data/response_models/detail_page/details_model.dart';
import 'package:padel_mobile/presentations/booking/details_page/details_page.dart';
import 'package:padel_mobile/presentations/openmatchbooking/openmatch_booking_controller.dart';
import 'package:padel_mobile/presentations/profile/profile_controller.dart';
import 'package:padel_mobile/repositories/openmatches/open_match_repository.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get_storage/get_storage.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/components/loader_widgets.dart';
import '../../../configs/components/primary_button.dart';
import '../../../configs/components/primary_text_feild.dart';
import '../../../configs/components/snack_bars.dart';
import '../../../data/request_models/home_models/get_available_court.dart';
import '../../../handler/logger.dart';
import '../../../services/payment_services/razorpay.dart';
import '../../cart/cart_controller.dart';
class DetailsController extends GetxController {
  OpenMatchRepository repository = OpenMatchRepository();
  RxBool isProcessing = false.obs;
  var option = ''.obs;
  RxString gameType = 'Mixed Doubles'.obs;
  late RazorpayPaymentService _paymentService;
  bool isFromOpenMatch = false;
  CartController get cartController => Get.find<CartController>();
  final storage = GetStorage();
  
  // Socket connection variables
  IO.Socket? socket;
  final RxBool isSocketConnected = false.obs;
  final RxInt unreadCount = 0.obs;
  String get userId {
    final id = storage.read("userId")?.toString() ?? '';
    CustomLogger.logMessage(
      msg: 'Getting userId from storage: $id',
      level: LogLevel.debug,
    );
    return id;
  }

  // Helper method to check if login user is in the match
  bool isLoginUserInMatch() {
    final userId = storage.read('userId');
    if (userId == null) return false;
    
    // Check in teamA
    for (final player in teamA) {
      if (player['userId'] == userId.toString()) return true;
    }
    
    // Check in teamB
    for (final player in teamB) {
      if (player['userId'] == userId.toString()) return true;
    }
    
    return false;
  }

  RxList<Map<String, dynamic>> teamA = <Map<String, dynamic>>[{
    "name": "",
    "image": "",
    "userId": "",
  }].obs;

  RxList<Map<String, dynamic>> teamB = <Map<String, dynamic>>[].obs;

  Map<String, dynamic> localMatchData = {
    "clubName": "Unknown club",
    "clubImage": [],
    "courtName":"Court 1",
    "clubId": "clubid",
    "ownerId": "",
    "matchDate": "Unknown date",
    "matchTime": [],
    "skillLevel": "Beginner",
    "skillDetails":[],
    "playerLevel":"",
    "price": "Unknown price",
    "address": "",
    "gender": "",
    "matchStatus":"open",
    "slot":[],
    "teamA": [{}],
    "teamB": [],
    "courtType": "",
    "court": {"type": "", "endRegistration": "Today at 10:00 PM"}
  };

  // Modified method to handle payment success callback
  Future<void> onPaymentSuccess({
    required String paymentId,
    required String orderId,
    required String signature,
  }) async {
    log("Payment successful - ID: $paymentId, Order: $orderId, Signature: $signature");

    try {
      // Show payment success message first
      // SnackBarUtils.showSuccessSnackBar("Payment successful! Creating match...");

      // Keep processing true while creating match
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
      // Now create the match after successful payment
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

  // Separate method for creating match after payment success
// Separate method for creating match after payment success
// Separate method for creating match after payment success
  Future<void> createMatchAfterPayment() async {
    try {
      // ✅ Safely extract and format the selected match date
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

      // ✅ Format both for backend
      final formattedMatchDate = DateFormat('yyyy-MM-dd').format(parsedMatchDate);
 final formattedBookingDate = DateTime.utc(parsedMatchDate.year, parsedMatchDate.month, parsedMatchDate.day).toIso8601String();
      // ✅ Safely extract slots
      final slotData = (localMatchData["slot"] as List?)?.cast<Slots>() ?? [];

      // ✅ Extract court information - handle both single and multiple courts
      final courtId = localMatchData["courtId"]?.toString() ?? "";
      final courtIds = (localMatchData["courtIds"] as List?)?.map((e) => e.toString()).toList() ?? [];
      final courtName = localMatchData["courtName"]?.toString() ?? "";

      // ✅ Build slot JSONs with courtId inside each slot
      final slotsJson = slotData.asMap().entries.map((entry) {
        final index = entry.key;
        final slot = entry.value;

        // Use corresponding courtId from courtIds array, or fallback to single courtId
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
          "macthType":"openMatch",
          "courtName": courtName,
          "courtId": slotCourtId, // ✅ Court ID inside slot
          "bookingDate": formattedBookingDate, // ✅ selected match date
        };
      }).toList();

      // ✅ Prepare final request body
      final body = {
        "slot": slotsJson,
        "clubId": localMatchData["clubId"] ?? "",
        "matchDate": formattedMatchDate, // ✅ selected match date
        "skillLevel": localMatchData["skillLevel"] ?? "",
        // 👇 Skill details
        "skillDetails": localMatchData["skillDetails"] ?? [],
        "customerScale": localMatchData["customerScale"] ?? "",
        "customerRacketSport": localMatchData["customerRacketSport"] ?? "",
        "receivingTP": localMatchData["receivingTP"] ?? "",
        "customerAge": localMatchData["customerAge"] ?? "",
        "volleyNetPositioning": localMatchData["volleyNetPositioning"] ?? "",
        "playerLevel": localMatchData["playerLevel"] ?? "",
        "reboundSkills": localMatchData["reboundSkills"] ?? "",

        "matchStatus": "open",
        "matchTime": localMatchData["matchTime"] ?? "",
        "gender":gameType.value,

        // ✅ Proper team A and B mapping
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

      log("✅ Final Match Request Body: ${body.toString()}");
      final cleanedBody = removeEmpty(body);
      log("📦 Final Cleaned Body: $cleanedBody");

      // ✅ Call API
      final response = await repository.createMatch(data: cleanedBody);
      log("🎯 Match Created -> ${response.toJson()}");
      SnackBarUtils.showSuccessSnackBar("Match created successfully!");

      // ✅ Call createBooking after successful match creation
      await createBooking();

      // ✅ Navigate to match booking page
      // openMatchBookingController.fetchOpenMatchesBooking(type: 'upcoming');
      // Get.toNamed(RoutesName.matchBooking, arguments: {"type": "detailPage"});
      Get.toNamed(RoutesName.bottomNav);
      openMatchBookingController.fetchOpenMatchesBooking(type: 'upcoming');
    } catch (e, st) {
      log("❌ Match creation error: $e\n$st");
      Get.close(2);
      showBookingErrorDialog();
      // SnackBarUtils.showErrorSnackBar("Failed to create match: $e");
    }
  }

  Future<void> createBooking() async {
    final slotData = (localMatchData["slot"] as List?)?.cast<Slots>() ?? [];

    // ✅ Read ownerId directly from localMatchData (set from source screens)
    final String ownerId = (localMatchData["ownerId"] ?? "").toString();

    // ✅ Format booking date to midnight
    final matchDateValue = localMatchData["matchDate"];
    DateTime? parsedMatchDate;
    if (matchDateValue is DateTime) {
      parsedMatchDate = matchDateValue;
    } else if (matchDateValue != null) {
      parsedMatchDate = DateTime.tryParse(matchDateValue.toString());
    }
    final formattedBookingDate = parsedMatchDate != null 
        ? DateTime.utc(parsedMatchDate.year, parsedMatchDate.month, parsedMatchDate.day).toIso8601String()
        : "";

    final payload = [
      {
        "slot": slotData
            .map(
              (slot) => {
                "slotId": slot.sId ?? "",
                "businessHours": slot.businessHours?.map((bh) {
                      return {
                        "time": bh.time ?? "",
                        "day": bh.day ?? "",
                      };
                    }).toList() ??
                    [],
                "slotTimes": [
                  {
                    "time": slot.time ?? "",
                    "amount": slot.amount ?? 0,
                  }
                ],
                "courtId": localMatchData["courtId"] ?? "",
                "courtName": localMatchData["courtName"] ?? "",
                "bookingDate": formattedBookingDate,
              },
            )
            .toList(),
        "register_club_id": localMatchData["clubId"] ?? "",
        "ownerId": ownerId,
      }
    ];

    log("🎯 Booking Payload: $payload");
    await cartController.bookCart(data: payload);
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

                  // Go Home button
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
                        Get.offAllNamed(RoutesName.bottomNav);
                      },
                      child: const Text(
                        "Go to Home",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Help & Support button
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

  // Main method that immediately shows payment sheet when book button is pressed
  Future<void> initiatePaymentAndCreateMatch() async {
    // Validate that teams have at least minimum required players
    if (!validateTeams()) {
      SnackBarUtils.showWarningSnackBar("Please add required players to both teams");
      return;
    }

    // Start processing immediately when book button is hit
    isProcessing.value = true;

    try {
      // Extract price from localMatchData
      final priceString = localMatchData['price']?.toString() ?? '0';
      final price = double.tryParse(priceString.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;

      if (price <= 0) {
        SnackBarUtils.showErrorSnackBar("Invalid price amount");
        isProcessing.value = false;
        return;
      }

      // Immediately open Razorpay payment sheet using your service structure
      await _paymentService.initiatePayment(
        keyId: 'rzp_test_1DP5mmOlF5G5ag',
        amount: price,
        currency: 'INR',
        name: 'Matchacha Padel',
        description: 'Payment for court booking and match creation',
        orderId: '', // You can generate order ID from your backend if needed
        userEmail: profileController.profileModel.value?.response?.email ?? 'test@example.com',
        userContact: '9999999999',
        notes: {
          'user_id': profileController.profileModel.value?.response?.sId ?? '123',
          'club_id': localMatchData['clubId'],
          'match_date': localMatchData['matchDate'].toString(),
          'match_time': localMatchData['matchTime'].toString(),
        },
        theme: '#F37254', // Your app's primary color
        paymentMethods: ['card', 'netbanking', 'upi', 'wallet'], // Enable all methods
      );
    } catch (e) {
      isProcessing.value = false;
      log("Payment initiation error: $e");
      SnackBarUtils.showErrorSnackBar("Failed to initiate payment: $e");
    }
    // Note: isProcessing will be set to false in success/failure callbacks
  }

  // Validate teams before payment
  bool validateTeams() {
    // Check if at least one player in Team A has valid data
    bool teamAValid = teamA.isNotEmpty &&
        teamA.any((player) =>
        player['name'] != null &&
            player['name'].toString().isNotEmpty &&
            player['userId'] != null &&
            player['userId'].toString().isNotEmpty);

    // For open matches, Team B can be empty initially
    // But you can add validation if needed
    return teamAValid;
  }

  // Legacy method - kept for backward compatibility but now redirects to payment
  @Deprecated('Use initiatePaymentAndCreateMatch instead')
  // Future<void> startPayment() async {
  //   await initiatePaymentAndCreateMatch();
  // }

  ///show Cancel Match Dialog Box-----------------------------------------------
  void showCancelMatchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Cancel Match', style: Get.textTheme.headlineMedium),
        content: Text(
          'Are you sure you want to cancel this match?',
          style: Get.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w400),
        ),
        actions: [
          PrimaryButton(
            height: 45,
            width: 80,
            onTap: () {
              Get.back();
            },
            text: "No",
          ).paddingOnly(right: 5),
          PrimaryButton(
            height: 45,
            width: 80,
            onTap: () {
              Get.close(2);
            },
            text: "Yes",
          ),
        ],
      ),
    );
  }

  OpenMatchBookingController openMatchBookingController = Get.put(OpenMatchBookingController());
  ProfileController profileController = Get.put(ProfileController());
  final fullNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  RxBool isLoading = false.obs;
  RxString gender = 'Male'.obs;
  RxString playerLevel = ''.obs;
  var apiPlayerLevels = <Map<String, dynamic>>[].obs;

  final Map<String, String> playerLevelMap = {
    'A': 'A – Top Player',
    'B1': 'B1 – Experienced Player',
    'B2': 'B2 – Advanced Player',
    'C1': 'C1 – Confident Player',
    'C2': 'C2 – Intermediate Player',
    'D1': 'D1 – Amateur Player',
    'D2': 'D2 – Novice Player',
    'E': 'E – Entry Level',
  };

  Map<String, String> get dynamicPlayerLevelMap {
    if (apiPlayerLevels.isNotEmpty) {
      return Map.fromEntries(
        apiPlayerLevels.map((level) => MapEntry(
          level['code'] ?? '',
          '${level['code']} – ${level['question']}',
        )),
      );
    }
    return playerLevelMap;
  }

  /// Add player to team method
  void addPlayerToTeam(String team, int index, Map<String, dynamic> playerData) {
    if (team.toLowerCase() == "teama") {
      // Ensure the list has enough elements
      while (teamA.length <= index) {
        teamA.add(<String, dynamic>{});
      }
      // Create a new Map<String, dynamic> to ensure type safety
      Map<String, dynamic> newPlayerData = <String, dynamic>{};
      newPlayerData.addAll(playerData);
      teamA[index] = newPlayerData;
    } else if (team.toLowerCase() == "teamb") {
      // Ensure the list has enough elements
      while (teamB.length <= index) {
        teamB.add(<String, dynamic>{});
      }
      // Create a new Map<String, dynamic> to ensure type safety
      Map<String, dynamic> newPlayerData = <String, dynamic>{};
      newPlayerData.addAll(playerData);
      teamB[index] = newPlayerData;
    }

    // Update the reactive lists
    teamA.refresh();
    teamB.refresh();

  }

  /// Enhanced create user method with team assignment
  Future<void> createUserAndAddToTeam({required int index, required String team}) async {
    if (isLoading.value || Get.isSnackbarOpen) return;
    // Validation
    if (fullNameController.text.isEmpty) {
      return SnackBarUtils.showWarningSnackBar("Please Enter Full Name");
    } else if (emailController.text.isEmpty) {
      return SnackBarUtils.showWarningSnackBar("Please Enter Email Address");
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      return SnackBarUtils.showWarningSnackBar("Please Enter a Valid Email Address");
    } else if (phoneController.text.isEmpty) {
      return SnackBarUtils.showWarningSnackBar("Please Enter Phone Number");
    } else if (gender.value.isEmpty) {
      return SnackBarUtils.showWarningSnackBar("Please Select the Gender");
    } else if (playerLevel.value.isEmpty) {
      return SnackBarUtils.showWarningSnackBar("Please Select the Player Level");
    }

    isLoading.value = true;
    try {
      final body = {
        "name": fullNameController.text.trim(),
        "lastName": lastNameController.text.trim(),
        "email": emailController.text.trim(),
        "phoneNumber": phoneController.text.trim(),
        "gender": gender.value,
        "level": playerLevel.value
      };

      final response = await repository.createUserForOpenMatch(body: body);

      if (response?.status == "200") {
        // Create player data object with explicit typing INCLUDING LEVEL
        Map<String, dynamic> newPlayer = <String, dynamic>{
          "name": fullNameController.text.trim(),
          "lastName":lastNameController.text.trim(),
          "image": "",
          "userId": response!.response!.sId!,
          "level": playerLevel.value,
          "levelLabel": playerLevelMap[playerLevel.value] ?? playerLevel.value,
        };

        // Add player to correct team and index
        addPlayerToTeam(team, index, newPlayer);

        // Update UI
        update();

        // Show success message
        SnackBarUtils.showSuccessSnackBar("Player added successfully!");

        // Clear form fields
        clearForm();

        // Close dialog
        Get.back();
      } else {
        SnackBarUtils.showInfoSnackBar(response?.message ?? "Failed to create user");
      }
    } catch (e) {
      CustomLogger.logMessage(msg: "Error :-> $e", level: LogLevel.error);
      SnackBarUtils.showErrorSnackBar("An error occurred while creating user");
    } finally {
      isLoading.value = false;
    }
  }
  /// Clear form fields
  void clearForm() {
    fullNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    gender.value = 'Male';
    playerLevel.value = 'A';
  }

  /// Show dialog method updated to use new system
  void showDailogue(BuildContext context, {required int index, required String team}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Dialog(
            insetPadding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: Get.height * 0.8,
                maxWidth: Get.width,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ---------------- HEADER ----------------
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Manual Booking",
                          style: Get.textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.labelBlackColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close, color: AppColors.labelBlackColor),
                        ),
                      ],
                    ),
                  ),

                  // ---------------- BODY ----------------
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // First Name
                          _textFieldWithLabel(
                            "First Name",
                            action: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            fullNameController,
                            context,
                          ),
                          _textFieldWithLabel(
                            "Last Name",
                            action: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            lastNameController,
                            context,
                          ),

                          // Email
                          _textFieldWithLabel(
                            "Email",
                            action: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            emailController,
                            context,
                          ),

                          // Phone Number
                          _textFieldWithLabel(
                            "Phone Number",
                            action: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            phoneController,
                            maxLength: 10,
                            context,
                          ),

                          // Gender
                          Text(
                            "Gender",
                            style: Get.textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.labelBlackColor,
                            ),
                          ).paddingOnly(top: Get.height * 0.02),

                          Obx(() => RadioGroup<String>(
                            groupValue: gender.value,
                            onChanged: (value) => gender.value = value!,
                            child: Row(
                              children: ["Female", "Male", "Other"].map((g) {
                                return Expanded(
                                  child: RadioListTile<String>(
                                    title: Text(
                                      g,
                                      style: Get.textTheme.headlineSmall,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    dense: true,
                                    value: g,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                );
                              }).toList(),
                            ),
                          )),

                          // Player Level
                          Text(
                            "Player Level",
                            style: Get.textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.labelBlackColor,
                            ),
                          ).paddingOnly(top: Get.height * 0.02, bottom: Get.height * 0.01),

                          Obx(() {
                            final currentValue = playerLevelMap.containsKey(playerLevel.value)
                                ? playerLevel.value
                                : null;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButtonFormField<String>(
                                  initialValue: currentValue,
                                  isDense: true,
                                  dropdownColor: AppColors.whiteColor,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.textFieldColor,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  hint: Text(
                                    "Select Player Level",
                                    style: Get.textTheme.headlineMedium!.copyWith(
                                      color: AppColors.textColor.withValues(alpha: 0.6),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.textColor,
                                  ),
                                  items: dynamicPlayerLevelMap.entries.map((entry) {
                                    return DropdownMenuItem<String>(
                                      value: entry.key,
                                      child: Text(
                                        entry.value,
                                        style: Get.textTheme.headlineMedium!.copyWith(
                                          color: AppColors.textColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      playerLevel.value = value;
                                    }
                                  },
                                ),

                                const SizedBox(height: 20), // ✅ Space after Player Level field
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // ---------------- FOOTER ----------------
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Obx(
                                () => PrimaryButton(
                              height: 50,
                              onTap: () {
                                createUserAndAddToTeam(index: index, team: team);
                              },
                              text: "Confirm",
                              child: isLoading.value
                                  ? AppLoader(size: 30, strokeWidth: 5)
                                  : null,
                            ),
                          ),
                        ),
                      ],
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

  Widget _textFieldWithLabel(
      String label,
      TextEditingController? controller,
      BuildContext context, {
        bool readOnly = false,
        TextInputType? keyboardType,
        TextInputAction? action,
        int? maxLength,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Get.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.labelBlackColor,
          ),
        ).paddingOnly(top: Get.height * .02),
        PrimaryTextField(
          hintText: "Enter $label",
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          action: action,
          maxLength: maxLength,
        ).paddingOnly(top: 10),
      ],
    );
  }

  /// Disconnect socket when user logs out or changes
  void disconnectSocket() {
    CustomLogger.logMessage(
      msg: '🔌 DETAILS: disconnectSocket() called',
      level: LogLevel.info,
    );
    try {
      if (socket?.connected == true) {
        CustomLogger.logMessage(
          msg: '🔌 DETAILS: Socket is connected, leaving matches and disconnecting...',
          level: LogLevel.info,
        );
        
        // Leave current match before disconnecting
        final args = Get.arguments;
        if (args is Map && args['matchId'] != null) {
          final matchId = args['matchId'].toString();
          socket!.emit('leaveMatch', matchId);
          CustomLogger.logMessage(
            msg: '📝 DETAILS: Left match $matchId',
            level: LogLevel.info,
          );
        }
        
        socket!.disconnect();
        CustomLogger.logMessage(
          msg: '✅ DETAILS: Socket disconnected successfully',
          level: LogLevel.info,
        );
      } else {
        CustomLogger.logMessage(
          msg: 'ℹ️ DETAILS: Socket was not connected or null',
          level: LogLevel.info,
        );
      }
    } catch (e) {
      CustomLogger.logMessage(
        msg: '❌ DETAILS: Error during socket disconnect: $e',
        level: LogLevel.error,
      );
    } finally {
      socket = null;
      isSocketConnected.value = false;
      unreadCount.value = 0;
      CustomLogger.logMessage(
        msg: '🔴 DETAILS: Socket variables reset',
        level: LogLevel.info,
      );
    }
  }

  /// Mark messages as read from details page
  void markAllMessagesAsReadFromDetails() {
    final args = Get.arguments;
    if (args is Map && args['matchId'] != null) {
      final matchId = args['matchId'].toString();
      
      if (socket != null && socket!.connected) {
        socket!.emit('markMessageRead', {'matchId': matchId});
        CustomLogger.logMessage(
          msg: '📖 Marking messages as read from details page for match: $matchId',
          level: LogLevel.info,
        );
        
        // Reset unread count immediately for better UX
        unreadCount.value = 0;
      } else {
        CustomLogger.logMessage(
          msg: '⚠️ Cannot mark messages as read - socket not connected',
          level: LogLevel.warning,
        );
      }
    }
  }

  /// Connect socket if user is part of the match and fromOpenMatch is true
  void connectSocketIfEligible() {
    // Only connect socket if coming from open match
    if (!isFromOpenMatch) return;
    
    final args = Get.arguments;
    if (args == null || args is! Map) return;
    
    final matchId = args['matchId']?.toString();
    if (matchId == null || matchId.isEmpty) return;
    
    final loggedInUserId = profileController.profileModel.value?.response?.sId;
    if (loggedInUserId == null || loggedInUserId.isEmpty) return;

    // Check if user is in either team
    bool isUserInTeamA = teamA.any((player) => player['userId'] == loggedInUserId);
    bool isUserInTeamB = teamB.any((player) => player['userId'] == loggedInUserId);

    if (isUserInTeamA || isUserInTeamB) {
      _connectSocket(matchId);
    }
  }

  /// Connect to socket for match chat
  void _connectSocket(String matchId) {
    try {
      // Disconnect existing socket if it exists
      if (socket != null) {
        CustomLogger.logMessage(
          msg: '🔌 DETAILS: Disconnecting existing socket before creating new one',
          level: LogLevel.info,
        );
        socket!.disconnect();
        socket = null;
      }
      
      final currentUserId = userId; // Get fresh userId
      CustomLogger.logMessage(
        msg: '🔌 DETAILS: Creating new socket connection for user: $currentUserId',
        level: LogLevel.info,
      );
      
      socket = IO.io(
        AppEndpoints.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .enableForceNew()
            .setAuth({'userId': currentUserId})
            .build(),
      );

      socket!.connect();

      socket!.on('connect', (_) {
        CustomLogger.logMessage(
          msg: '✅ Socket connected in detail page for match: $matchId with userId: $currentUserId',
          level: LogLevel.info,
        );
        isSocketConnected.value = true;
        socket!.emit('joinMatch', matchId);
        socket!.emit('getUnreadCount', {'matchId': matchId});
      });

      socket!.on('unreadCount', (data) {
        final count = data['count'] ?? 0;
        CustomLogger.logMessage(
          msg: '💡 🔔 Received unreadCount in details: $count for match: $matchId',
          level: LogLevel.info,
        );
        unreadCount.value = count;
      });

      socket!.on('disconnect', (reason) {
        CustomLogger.logMessage(
          msg: '❌ Socket disconnected in detail page: $reason',
          level: LogLevel.error,
        );
        isSocketConnected.value = false;
      });

      socket!.on('connect_error', (error) {
        CustomLogger.logMessage(
          msg: '🔥 Socket connection error in detail page: $error',
          level: LogLevel.error,
        );
        isSocketConnected.value = false;
      });

      socket!.on('newMessage', (data) {
        final senderId = data['senderId']?.toString() ?? '';
        final messageMatchId = data['matchId']?.toString() ?? '';
        final args = Get.arguments;
        
        // Only increment if message is for this match and not from current user
        if (args is Map && 
            messageMatchId == args['matchId']?.toString() && 
            senderId != userId) {
          unreadCount.value = unreadCount.value + 1;
          CustomLogger.logMessage(
            msg: '📨 New message received, incrementing unread count to ${unreadCount.value}',
            level: LogLevel.info,
          );
        }
      });

      // Listen for message read updates to reset unread count
      socket!.on('messageReadUpdate', (data) {
        // Check if the read update is for our user
        final readBy = data['readBy'] as List?;
        if (readBy != null && readBy.contains(userId)) {
          unreadCount.value = 0;
        }
      });

      // Listen for all messages marked as read
      socket!.on('allMessagesRead', (data) {
        final matchIdFromEvent = data['matchId']?.toString();
        final userIdFromEvent = data['userId']?.toString();
        final args = Get.arguments;
        if (args is Map && 
            matchIdFromEvent == args['matchId']?.toString() && 
            userIdFromEvent == userId) {
          CustomLogger.logMessage(
            msg: '📖 All messages marked as read, resetting unread count',
            level: LogLevel.info,
          );
          unreadCount.value = 0;
        }
      });

      // Listen for markMessageRead acknowledgment
      socket!.on('messageReadAck', (data) {
        final matchIdFromEvent = data['matchId']?.toString();
        final args = Get.arguments;
        if (args is Map && matchIdFromEvent == args['matchId']?.toString()) {
          CustomLogger.logMessage(
            msg: '✅ Message read acknowledgment received, resetting unread count',
            level: LogLevel.info,
          );
          unreadCount.value = 0;
        }
      });
    } catch (e) {
      CustomLogger.logMessage(
        msg: '❌ Error connecting socket in detail page: $e',
        level: LogLevel.error,
      );
    }
  }



  @override
  void onInit() {
    // Initialize payment service with callbacks
    _paymentService = RazorpayPaymentService();

    // Set up payment callbacks
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

    // Set isFromOpenMatch flag
    final args = Get.arguments;
    isFromOpenMatch = args is Map && args['fromOpenMatch'] == true;
    
    // Only add profile data if not coming from OpenMatchBookingScreen
    if (!isFromOpenMatch) {
      String skillLevel = "";
      // Prefer explicitly selected player level label if present
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
        // Store both label and short code where possible
        "level": profileController.profileModel.value?.response!.playerLevel?.split(' ').first??"",
        "levelLabel": skillLevel,
     };

      teamA.first.addAll(profileData);
    }

    // Connect socket after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      connectSocketIfEligible();
    });

    super.onInit();
  }


  /// Mark all messages as read for this match
  void markAllMessagesAsRead() {
    final args = Get.arguments;
    if (args is Map && socket?.connected == true) {
      final matchId = args['matchId']?.toString();
      if (matchId != null) {
        socket!.emit('markMessageRead', {'matchId': matchId});
        // Don't reset count immediately - wait for backend confirmation
      }
    }
  }



  /// Handle back navigation - disconnect socket
  void handleBackNavigation() {
    disconnectSocket();
  }

  @override
  void onClose() {
    // Disconnect socket when leaving detail page
    disconnectSocket();
    // Dispose payment service
    _paymentService.dispose();
    super.onClose();
  }
  Future<void> shareMatch(
      OpenMatchDetailsModel match,
      DetailsController controller,
      BuildContext context,
      ) async {
    final teamA = match.data?.teamA ?? [];
    final teamB = match.data?.teamB ?? [];

    String formatPlayerNames(List<dynamic> players) {
      if (players.isEmpty) return "Not decided";
      return players.map((p) {
        final user = p.userId;
        final firstName = user?.name ?? '';
        final lastName = user?.lastName ?? '';
        final fullName = "$firstName $lastName".trim();
        return fullName.isEmpty ? "Unknown" : fullName;
      }).join(", ");
    }

    final teamAPlayers = formatPlayerNames(teamA);
    final teamBPlayers = formatPlayerNames(teamB);

    final matchDate = formatMatchDateAt(match.data?.matchDate ?? "");
    final clubName = match.data?.clubId?.clubName ?? "Unknown Club";
    final matchType = match.data?.matchType?.capitalizeFirst ?? "Open Match";
    final gender = match.data?.gender?.capitalizeFirst ?? "-";
    final skill = match.data?.skillLevel?.capitalizeFirst ?? "-";
    final slots = match.data?.slot ?? [];
    final totalAmount = slots.isNotEmpty
        ? slots
        .expand((slot) => slot.slotTimes ?? [])
        .map((st) => (st.amount ?? 0) as int)
        .fold(0, (a, b) => a + b)
        : 0;

    final message = '''
🎾 *Padel Match Details*

📍 *Club:* $clubName
📅 *Date:* $matchDate
⚧ *Gender:* $gender
🏆 *Level:* $skill
💰 *Price:* ₹$totalAmount
🎮 *Match Type:* $matchType

👥 *Team A:* $teamAPlayers
👥 *Team B:* $teamBPlayers

Join the excitement! 💪
''';

    final renderBox = context.findRenderObject() as RenderBox?;
    // on iPad the rect must be non-zero; fallback to a tiny non-zero rect if null/zero
    final Rect shareRect = (renderBox != null)
        ? (renderBox.localToGlobal(Offset.zero) & renderBox.size)
        : const Rect.fromLTWH(0, 0, 1, 1);

    // sharePositionOrigin is a field of ShareParams
    await SharePlus.instance.share(
      ShareParams(
        text: message,
        subject: "Check out this Padel match!",
        // important for iPad / iOS popover positioning
        sharePositionOrigin: (shareRect.width == 0 || shareRect.height == 0)
            ? const Rect.fromLTWH(0, 0, 1, 1)
            : shareRect,
      ),
    );
  }

  Future<void> shareLocalMatch(BuildContext context) async {
    String formatPlayerNames(List<Map<String, dynamic>> players) {
      if (players.isEmpty) return "Available";
      return players
          .where((p) => p['name'] != null && p['name'].toString().isNotEmpty)
          .map((p) {
        final firstName = (p['name']?.toString())?.capitalizeFirst ?? '';
        final lastName = (p['lastName']?.toString())?.capitalizeFirst ?? '';
        final fullName = "$firstName $lastName".trim();
        return fullName.isEmpty ? "Unknown" : fullName;
      }).join(", ");
    }

    final teamAPlayers = formatPlayerNames(teamA.toList());
    final teamBPlayers = formatPlayerNames(teamB.toList());

    final matchDate = formatMatchDateAt(localMatchData['matchDate'] ?? "");
    final clubName = localMatchData['clubName'] ?? "Unknown Club";
    final skill = localMatchData['skillLevel'] ?? "-";
    final price = localMatchData['price'] ?? "0";
    final gameTypeValue = gameType.value;

    final message = '''
🎾 *Padel Match Details*

📍 *Club:* $clubName
📅 *Date:* $matchDate
⚧ *Game Type:* $gameTypeValue
🏆 *Level:* $skill
💰 *Price:* ₹$price
🎮 *Match Type:* Open Match

👥 *Team A:* $teamAPlayers
👥 *Team B:* $teamBPlayers

Join the excitement! 💪
''';

    final renderBox = context.findRenderObject() as RenderBox?;
    final Rect shareRect = (renderBox != null)
        ? (renderBox.localToGlobal(Offset.zero) & renderBox.size)
        : const Rect.fromLTWH(0, 0, 1, 1);

    await Share.share(
      message,
      subject: "Check out this Padel match!",
      sharePositionOrigin: (shareRect.width == 0 || shareRect.height == 0)
          ? const Rect.fromLTWH(0, 0, 1, 1)
          : shareRect,
    );
  }
}