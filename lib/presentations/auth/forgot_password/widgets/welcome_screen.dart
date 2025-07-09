import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/presentations/auth/forgot_password/widgets/forgot_password_exports.dart';
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: welcomeBack(context),
      ),
    );
  }
  Widget welcomeBack(BuildContext context){
    return Column(
      children: [
        Center(
          child: Text(
              AppStrings.welcomeBack,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 30)
          ).paddingOnly(bottom: Get.height * 0.03,top: Get.height*0.28),
        ),
        Text(
          AppStrings.passwordSuccessfullyUpdate,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? Get.height * 0.03 : Get.height * 0.395),
        PrimaryButton(onTap: ()=>Get.toNamed(RoutesName.login), text: AppStrings.done).paddingOnly(bottom: Get.height*0.03),
      ],
    ).paddingOnly(left: Get.width*0.05,right: Get.width*0.05);
  }
}
