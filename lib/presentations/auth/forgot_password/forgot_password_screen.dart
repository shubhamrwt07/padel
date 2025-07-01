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
                leading: GestureDetector(
                  onTap: () {
                    controller.handleBack();
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: 30,
                    width: 40,
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.blackColor,
                      size: 18,
                    ),
                  ),
                ),
                title: SizedBox(), context: context),
            body: SingleChildScrollView(
              child: Obx(() {
                switch (controller.currentStep.value) {
                  case ForgotPasswordStep.emailEntry:
                    return forgotPassword(context, controller);
                  case ForgotPasswordStep.otpEntry:
                    return enterOtp(context, controller);
                  case ForgotPasswordStep.resetPassword:
                    return resetPassword(context, controller);
                  case ForgotPasswordStep.done:
                    return welcomeBack(context);
                }
              }).paddingSymmetric(horizontal: Get.width * 0.05),
            ).paddingOnly(left: Get.width * 0.0, right: Get.width * 0.00),
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
        PrimaryButton(onTap: ()=>controller.goToOtp(), text: AppStrings.sendOtp).paddingOnly(bottom: Get.height*0.03,top: Get.height*0.06),
      ],
    );
  }
  Widget enterOtp(BuildContext context, ForgotPasswordController controller){
    return Column(
      children: [
        Center(
          child: Text(
            AppStrings.enterOtp,
            style: Theme.of(context).textTheme.titleLarge,
          ).paddingOnly(bottom: Get.height * 0.03,top: Get.height*0.15),
        ),
        Text(
          AppStrings.aSecurityCodeHasBeenSent,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: Get.height * 0.057),
        PinCodeTextField(
          appContext: context,
          length: 4,
          cursorColor: AppColors.primaryColor,
          textStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 30,
            color: Colors.black,
          ),
          animationType: AnimationType.fade,
          keyboardType: TextInputType.number,
          animationCurve: Curves.easeInCubic,
          enableActiveFill: true,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(12),
            fieldHeight: 60,
            fieldWidth: 60,

            // Hide borders
            inactiveColor: Colors.transparent,
            selectedColor: AppColors.primaryColor,
            activeColor: Colors.transparent,
            borderWidth: 2,

            // Fill colors for background of boxes
            inactiveFillColor: Colors.grey.shade100,
            selectedFillColor: const Color(0xFFF1F4FF),
            activeFillColor: const Color(0xFFF1F4FF),
          ),
          backgroundColor: Colors.transparent,
          blinkWhenObscuring: true,
          autoDisposeControllers: true,
          beforeTextPaste: (text) => true,
          onChanged: (value) {},
        )
            .paddingOnly(left: Get.width*0.06, right: Get.width*0.06,bottom: Get.height*0.02),
        Text(
          "00:00",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? Get.height * 0.03 : Get.height * 0.295),
        RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                      text: AppStrings.doNotReceiveCode,
                      style:Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.darkGreyColor)
                  ),
                  TextSpan(
                      text: AppStrings.resend,
                      style:Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.primaryColor)
                  ),
                ]
            )),
        PrimaryButton(onTap: ()=>controller.goToResetPassword(), text: AppStrings.verify).paddingOnly(bottom: Get.height*0.04,top: Get.height*0.03),
      ],
    );
  }
  Widget resetPassword(BuildContext context,ForgotPasswordController controller){
    return Column(
      children: [
        Center(
          child: Text(
            AppStrings.resetPassword,
            style: Theme.of(context).textTheme.titleLarge,
          ).paddingOnly(bottom: Get.height * 0.03,top: Get.height*0.15),
        ),
        Text(
          AppStrings.enterAndConfirmNewPass,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: Get.height * 0.05),
        PrimaryTextField(
          hintText: AppStrings.password,
          obscureText: controller.isVisiblePassword.value,
          maxLine: 1,
          suffixIcon: IconButton(
            onPressed: () => controller.passwordToggle(),
            icon: Image.asset(
              controller.isVisiblePassword.value
                  ? Assets.imagesIcEyeOff: Assets.imagesIcEye,
              color: AppColors.textColor,
              height: 24,
              width: 24,
            ),
          ),
        ).paddingOnly(bottom: Get.height * 0.03),
        PrimaryTextField(
          hintText: AppStrings.confirmPassword,
          obscureText: controller.isVisibleConfirmPassword.value,
          maxLine: 1,
          suffixIcon: IconButton(
            onPressed: () => controller.confirmPasswordToggle(),
            icon: Image.asset(
              controller.isVisibleConfirmPassword.value
                  ? Assets.imagesIcEyeOff: Assets.imagesIcEye,
              color: AppColors.textColor,
              height: 24,
              width: 24,
            ),
          ),          ).paddingOnly(bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? Get.height * 0.03 : Get.height * 0.335),
        PrimaryButton(onTap: ()=>controller.goToDone(), text: AppStrings.changePassword).paddingOnly(bottom: Get.height*0.03),

      ],
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
        PrimaryButton(onTap: ()=>Get.back(), text: AppStrings.done).paddingOnly(bottom: Get.height*0.03),

      ],
    );
  }
}
