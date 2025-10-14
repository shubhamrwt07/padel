import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/presentations/booking/details_page/details_model.dart';
import 'package:padel_mobile/presentations/booking/open_matches/open_match_controller.dart';
import 'package:padel_mobile/presentations/profile/profile_controller.dart';
import 'package:padel_mobile/repositories/openmatches/open_match_repository.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/components/loader_widgets.dart';
import '../../../configs/components/primary_button.dart';
import '../../../configs/components/primary_text_feild.dart';
import '../../../configs/components/snack_bars.dart';
import '../../../data/request_models/home_models/get_available_court.dart';
import '../../../handler/logger.dart';
import '../../../services/payment_services/razorpay.dart';
import '../open_matches/addPlayer/add_player_controller.dart';
class DetailsController extends GetxController {
  OpenMatchRepository repository = OpenMatchRepository();
  RxBool isProcessing = false.obs;
  var option = ''.obs;
  late RazorpayPaymentService _paymentService;

  RxList<Map<String, dynamic>> teamA = <Map<String, dynamic>>[{
    "name": "",
    "image": "",
    "userId": "",
  }].obs;

  RxList<Map<String, dynamic>> teamB = <Map<String, dynamic>>[].obs;

  Map<String, dynamic> localMatchData = {
    "clubName": "Unknown club",
    "courtName":"Court 1",
    "clubId": "clubid",
    "matchDate": "Unknown date",
    "matchTime": "Unknown time",
    "skillLevel": "A",
    "skillDetails":[],
    "playerLevel":"",
    "price": "Unknown price",
    "address": "add here",
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
      SnackBarUtils.showSuccessSnackBar("Payment successful! Creating match...");

      // Keep processing true while creating match
      isProcessing.value = true;

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
  Future<void> createMatchAfterPayment() async {
    try {
      // Handle slots: convert to required format
      final slotData = localMatchData["slot"] as List<Slots>? ?? [];
      final slotsJson = slotData.map((slot) => {
        "slotId": slot.sId,
        "businessHours": slot.businessHours?.map((bh) => {
          "time": bh.time,
          "day": bh.day,
        }).toList() ?? [],
        "slotTimes": [{
          "time": slot.time,
          "amount": slot.amount,
        }],
        "courtName": localMatchData["courtName"] ?? "",
        "bookingDate": DateTime.now().toIso8601String(),
      }).toList();

      // Format matchDate
      final matchDate = localMatchData["matchDate"];
      final matchDateString = matchDate is DateTime
          ? DateFormat('yyyy-MM-dd').format(matchDate)
          : matchDate.toString();

      // Prepare request body
      final body = {
        "slot": slotsJson,
        "clubId": localMatchData["clubId"],
        "matchDate": matchDateString,
        "skillLevel": localMatchData["skillLevel"],
        "skillDetails": localMatchData["skillDetails"],
        // Include the selected player level (fallback to any existing match-level value)
        "playerLevel": (playerLevel.value.isNotEmpty
            ? playerLevel.value
            : (localMatchData["playerLevel"]?.toString() ?? "")),
        "matchStatus": "open",
        "matchTime": localMatchData["matchTime"],
        "teamA": teamA
            .where((p) => (p["userId"] ?? p["_id"]) != null && (p["userId"] ?? p["_id"]).toString().isNotEmpty)
            .map((p) => p["userId"] ?? p["_id"])
            .toList(),
        "teamB": teamB
            .where((p) => (p["userId"] ?? p["_id"]) != null && (p["userId"] ?? p["_id"]).toString().isNotEmpty)
            .map((p) => p["userId"] ?? p["_id"])
            .toList(),      };

      log("Request Body: $body");
      final response = await repository.createMatch(data: body);

      // Show match created successfully message
      SnackBarUtils.showSuccessSnackBar("Match created successfully!");
      log("Match Created -> ${response.toJson()}");

      // Navigate to bottom navigation after successful match creation
      Get.offAllNamed(RoutesName.matchBooking,arguments: {
        "type": "detailPage"
      });
    } catch (e, st) {
      log("Match creation error: $e, $st");
      SnackBarUtils.showErrorSnackBar("Failed to create match: $e");
      throw e; // Re-throw to be caught by payment success handler
    }
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
  Future<void> startPayment() async {
    await initiatePaymentAndCreateMatch();
  }

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

  OpenMatchesController openMatchesController = Get.put(OpenMatchesController());
  ProfileController profileController = Get.put(ProfileController());
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  RxBool isLoading = false.obs;
  RxString gender = 'Male'.obs;
  RxString playerLevel = ''.obs;

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
          "image": "",
          "userId": response!.response!.sId!,
          "level": playerLevel.value, // ADD THIS LINE
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
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Dialog(
            insetPadding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                  maxHeight: Get.height * 0.8,
                  maxWidth: Get.width
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dialog Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
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
                          icon: Icon(Icons.close, color: AppColors.labelBlackColor),
                        ),
                      ],
                    ),
                  ),

                  // Dialog Body
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _textFieldWithLabel(
                            "First Name",
                            action: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            fullNameController,
                            context,
                          ),
                          _textFieldWithLabel(
                            "Email",
                            action: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            emailController,
                            context,
                          ),
                          _textFieldWithLabel(
                            "Phone Number",
                            action: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            phoneController,
                            maxLength: 10,
                            context,
                          ),

                          Text(
                            "Gender",
                            style: Get.textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.labelBlackColor,
                            ),
                          ).paddingOnly(top: Get.height * 0.02),

                          Obx(() => Row(
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
                                  groupValue: gender.value,
                                  onChanged: (value) => gender.value = value!,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              );
                            }).toList(),
                          )),

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
                                : null; // ✅ Prevents crash if value not in map

                            return DropdownButtonFormField<String>(
                              value: currentValue,
                              isDense: true,
                              dropdownColor: AppColors.whiteColor,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.textFieldColor,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              hint: Text(
                                "Select Player Level",
                                style: Get.textTheme.headlineMedium!.copyWith(
                                  color: AppColors.textColor.withOpacity(0.6),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.textColor,
                              ),
                              items: playerLevelMap.entries.map((entry) {
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
                            );
                          })
                        ],
                      ),
                    ),
                  ),

                  // Dialog Footer
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
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
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text("Cancel"),
                          ),
                        ),
                        SizedBox(width: 16),
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
      "image": profileController.profileModel.value?.response!.profilePic ?? "",
      "userId": profileController.profileModel.value?.response!.sId ?? "",
      // Store both label and short code where possible
      "levelLabel": skillLevel,
      "level": skillLevel.toString().split(' ').first,
    };

    teamA.first.addAll(profileData);

    super.onInit();
  }


  @override
  void onClose() {
    // Dispose payment service
    _paymentService.dispose();
    super.onClose();
  }
}