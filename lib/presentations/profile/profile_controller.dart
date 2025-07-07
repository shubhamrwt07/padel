// ✅ FILE: profile_controller.dart
import 'dart:developer';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/components/snack_bars.dart';
import 'package:padel_mobile/core/network/dio_client.dart';
import 'package:padel_mobile/data/response_models/home_models/profile_model.dart';
import 'package:padel_mobile/handler/logger.dart';
import 'package:padel_mobile/presentations/profile/widgets/profile_exports.dart';
import 'package:padel_mobile/repositories/home_repository/profile_repository.dart';

class ProfileController extends GetxController {
  // Repositories
  ProfileRepository profileRepository = ProfileRepository();

  // Text Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  Rx<TextEditingController> dobController = TextEditingController().obs;

  // Observables
  Rx<ProfileModel> profileModel = ProfileModel(
    response: ProfileResponse(
      email: "example@gmail.com",
      name: "Unknown",
      gender: "",
      dob: "",
      countryCode: "",
      phoneNumber: 0000000,
      location: Location(type: "Location"),
    ),
  ).obs;

  RxBool isLoading = false.obs;
  RxString selectedGender = ''.obs;
  Rx<XFile?> profileImage = Rx<XFile?>(null);
  RxBool isProfileUpdated = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchUserProfile();
    });
  }

  void setValues() {
    nameController.text = profileModel.value.response?.name ?? '';
    emailController.text = profileModel.value.response?.email ?? '';
    phoneController.text =
        profileModel.value.response?.phoneNumber.toString() ?? '';
    selectedGender.value = profileModel.value.response!.gender ?? "";
    dobController.value.text = profileModel.value.response?.dob ?? '';
  }

  void selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      dobController.value.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  Future<void> showImageSourceActionSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: EdgeInsets.only(top: 12, bottom: 8),
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'Select Image Source',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),

                // Divider
                Divider(height: 1, thickness: 1, color: Colors.grey[200]),

                // Options
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildOptionTile(
                        context: context,
                        icon: Icons.camera_alt,
                        iconColor: Colors.blue,
                        title: 'Take a photo',
                        subtitle: 'Use camera to capture',
                        onTap: () async {
                          Get.back();
                          await pickImage(ImageSource.camera);
                        },
                      ),

                      SizedBox(height: 8),

                      _buildOptionTile(
                        context: context,
                        icon: Icons.photo_library,
                        iconColor: Colors.green,
                        title: 'Choose from gallery',
                        subtitle: 'Select from your photos',
                        onTap: () async {
                          Get.back();
                          await pickImage(ImageSource.gallery);
                        },
                      ),

                      SizedBox(height: 16),

                      // Cancel button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom padding
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> updateProfile() async {
    FocusManager.instance.primaryFocus!.unfocus();
    try {
      if (isLoading.value) return;
      isLoading.value = true;

      Map<String, dynamic> locationJson = {
        "type": "Point",
        "coordinates": [77.5947, 12.9717],
      };
      String formattedDate;
      if (dobController.value.text.isNotEmpty) {
        DateTime dateTime = parseDateFromString(dobController.value.text);
        formattedDate = dateTime.toIso8601String();
      } else {
        formattedDate = DateTime.now().toIso8601String();
      }

      final updatedProfile = await profileRepository.updateUserProfile(
        name: nameController.text.trim(),
        // countryCode: "+91",
        // phoneNumber: phoneController.text.trim(),
        gender: selectedGender.value,
        dob: formattedDate,
        city: "city",
        location: locationJson,
      );

      if (updatedProfile.status == "200") {
        Get.back();
        fetchUserProfile();
      } else {
        log("UPDATE PROFILE ERROR");
      }
    } catch (e, st) {
      log('Error updating profile: $e');
      log('Stack trace: $st');
    } finally {
      isLoading.value = false;
    }
  }

  DateTime parseDateFromString(String dateString) {
    try {
      if (dateString.contains('/')) {
        List<String> parts = dateString.split('/');
        if (parts.length == 3) {
          int month = int.parse(parts[0]);
          int day = int.parse(parts[1]);
          int year = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      }

      // Handle DD/MM/YYYY format (alternative)
      if (dateString.contains('/')) {
        List<String> parts = dateString.split('/');
        if (parts.length == 3) {
          int day = int.parse(parts[0]);
          int month = int.parse(parts[1]);
          int year = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      }

      // Handle YYYY-MM-DD format
      if (dateString.contains('-')) {
        return DateTime.parse(dateString);
      }

      // Default fallback
      return DateTime.now();
    } catch (e) {
      log('Error parsing date: $e');
      return DateTime.now();
    }
  }

  // Helper method to format date properly
  String formatDateForServer(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  // Alternative helper method if you need more control over the format
  String formatDateForServerCustom(DateTime dateTime) {
    return '${dateTime.year.toString().padLeft(4, '0')}-'
        '${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')}T'
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}:'
        '${dateTime.second.toString().padLeft(2, '0')}.'
        '${dateTime.millisecond.toString().padLeft(3, '0')}';
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      profileImage.value = image;
    }
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      ProfileModel result = await profileRepository.fetchUserProfile();
      if (result.status == "200") {
        profileModel.value = result;
        setValues();
        log("PROFILE MODEL => ${profileModel.value}");
        update();
      } else {
        SnackBarUtils.showErrorSnackBar(
          result.message ?? 'Failed to fetch profile',
        );
      }
    } catch (e, st) {
      CustomLogger.logMessage(msg: e.toString(), level: LogLevel.error, st: st);
    } finally {
      isLoading.value = false;
    }
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppStrings.areYouSureToLogout, textAlign: TextAlign.center),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await storage.erase();
                    Get.offAllNamed(RoutesName.login);
                  },
                  child: Container(
                    height: Get.height * 0.04,
                    width: Get.width * 0.22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.textColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      AppStrings.yes,
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                  ).paddingOnly(right: 10),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    height: Get.height * 0.04,
                    width: Get.width * 0.22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      AppStrings.no,
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
