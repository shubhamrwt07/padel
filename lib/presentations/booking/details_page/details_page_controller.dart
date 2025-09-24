import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:padel_mobile/presentations/booking/details_page/details_model.dart';
import 'package:padel_mobile/presentations/booking/open_matches/open_match_controller.dart';
import 'package:padel_mobile/presentations/profile/profile_controller.dart';
import 'package:padel_mobile/repositories/openmatches/open_match_repository.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/components/loader_widgets.dart';
import '../../../configs/components/primary_button.dart';
import '../../../configs/components/primary_text_feild.dart';
import '../../../configs/components/snack_bars.dart';
import '../../../handler/logger.dart';
import '../open_matches/addPlayer/add_player_controller.dart';

class DetailsController extends GetxController {
  OpenMatchRepository repository = OpenMatchRepository();

  RxList<Map<String, dynamic>> teamA = <Map<String, dynamic>>[].obs;

  RxList<Map<String, dynamic>> teamB = <Map<String, dynamic>>[].obs;

  Map<String, dynamic> localMatchData = {
    "clubName": "Unknown club",
    "clubId": "clubid",
    "matchDate": "Unknown date",
    "matchTime": "Unknown time",
    "skillLevel": "Unknown level",
    "price": "Unknown price",
    "address": "add here",
    "gender": "",
    "teamA": [{}],
    "teamB": [],
    "courtType": "",
    "court": {"type": "", "endRegistration": "Today at 10:00 PM"}
  };

  ///show Cancel Match Dialog Box---------------------------------------
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
  RxString playerLevel = 'All Players'.obs;

  List<String> playerLevels = [
    'All Players',
    'A',
    'B',
    'C',
    'D',
    'A/B',
    'B/C',
    'C/D',
  ];

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
        // Create player data object with explicit typing
        Map<String, dynamic> newPlayer = <String, dynamic>{
          "name": fullNameController.text.trim(),
          "image": "",
          "userId": response!.response!.sId!,
        };

        // Add player to correct team and index
        addPlayerToTeam(team, index, newPlayer);

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
    playerLevel.value = 'All Players';
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

                          Obx(() => DropdownButtonFormField<String>(
                            value: playerLevel.value,
                            isDense: true,
                            dropdownColor: AppColors.whiteColor,
                            items: playerLevels.map((level) {
                              return DropdownMenuItem(
                                value: level,
                                child: Text(
                                  level,
                                  style: Get.textTheme.headlineMedium!.copyWith(
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) => playerLevel.value = value!,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColors.textFieldColor,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          )),

                          SizedBox(height: 20),
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
    WidgetsBinding.instance.addPostFrameCallback((v) {
      profileController.fetchUserProfile();
      // Create a new map to ensure type safety
      Map<String, dynamic> profileData = <String, dynamic>{
        "name": profileController.profileModel.value?.response!.name ?? "",
        "image": profileController.profileModel.value?.response!.profilePic ?? "",
        "userId": profileController.profileModel.value?.response!.sId ?? ""
      };
      teamA.first.addAll(profileData);
    });
    super.onInit();
  }
}