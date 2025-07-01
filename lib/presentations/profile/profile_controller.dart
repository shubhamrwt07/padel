import 'package:padel_mobile/presentations/profile/widgets/profile_exports.dart';

class ProfileController extends GetxController{

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.areYouSureToLogout,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ).paddingOnly(top: Get.height*0.02),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    Get.offAllNamed(RoutesName.login);
                  },
                  child: Container(
                    height: Get.height*0.04,
                    width: Get.width*0.22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.textColor,
                        borderRadius: BorderRadius.circular(6)
                    ),
                    child: Text(AppStrings.yes,style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600,color: AppColors.whiteColor),),
                  ).paddingOnly(right: 10),
                ),
                GestureDetector(
                  onTap: ()=>Get.back(),
                  child: Container(
                    height: Get.height*0.04,
                    width: Get.width*0.22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(6)
                    ),
                    child: Text(AppStrings.no,style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600,color: AppColors.whiteColor),),
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