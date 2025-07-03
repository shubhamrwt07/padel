import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/presentations/auth/forgot_password/widgets/forgot_password_exports.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusManager.instance.primaryFocus!.unfocus(),
      child: PrimaryContainer(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: primaryAppBar(
                title: SizedBox(), context: context),
            body: forgotPassword(context, controller)
          )
      ),
    );
  }
  Widget forgotPassword(BuildContext context, ForgotPasswordController controller){
    return Column(
      children: [
        Center(
          child: Text(
            AppStrings.forgotPassword,
            style: Theme.of(context).textTheme.titleLarge,
          ).paddingOnly(bottom: Get.height * 0.03,top: Get.height*0.15),
        ),
        Text(
          AppStrings.letHelpYouBackIn,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: Get.height * 0.05),
        PrimaryTextField(
          hintText: AppStrings.email,
        ).paddingOnly(bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? Get.height * 0.03 : Get.height * 0.36,),
        PrimaryButton(onTap: ()=>Get.toNamed(RoutesName.otp), text: AppStrings.sendOtp).paddingOnly(bottom: Get.height*0.03,top: Get.height*0.06),
      ],
    ).paddingOnly(left: Get.width*0.05,right: Get.width*0.05);
  }


}
