// ✅ FILE: profile_controller.dart
 import 'dart:developer';
import 'package:padel_mobile/core/network/dio_client.dart';
import 'package:padel_mobile/data/response_models/home_models/profile_model.dart';
import 'package:padel_mobile/presentations/profile/widgets/profile_exports.dart';

class ProfileController extends GetxController {
  // Repositories
  ProfileRepository profileRepository = ProfileRepository();
  var selectedIndex = (-1).obs;
  // Text Controllers
  RxBool isLoading = false.obs;
 
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchUserProfile();
    });
  }
var profileModel = Rxn<ProfileModel>();
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      ProfileModel result = await profileRepository.fetchUserProfile();
      if (result.status == "200") {
        profileModel.value = result;
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = false;
      });
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
