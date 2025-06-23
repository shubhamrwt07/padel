import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:padel_mobile/configs/components/primary_button.dart';
import 'package:padel_mobile/configs/components/primary_container.dart';
import 'package:padel_mobile/configs/components/primary_text_feild.dart';
import 'package:padel_mobile/presentations/auth/forgot_password/forgot_password_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
        child: GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus!.unfocus();
          },
          child: Scaffold(
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
            ).paddingOnly(left: Get.width * 0.05, right: Get.width * 0.05),
          ),
        )
    );
  }
  Widget forgotPassword(BuildContext context, ForgotPasswordController controller){
    return Column(
      children: [
        Center(
          child: Text(
            "Forgot Password ?",
            style: Theme.of(context).textTheme.titleLarge,
          ).paddingOnly(bottom: Get.height * 0.03,top: Get.height*0.13),
        ),
        Text(
          "Let’ help you get back in. enter the email linked to your account.",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: Get.height * 0.05),
        PrimaryTextField(
          hintText: "Email",
        ).paddingOnly(bottom: Get.height * 0.03),
        PrimaryButton(onTap: ()=>controller.goToOtp(), text: "Send OTP").paddingOnly(bottom: Get.height*0.03,top: Get.height*0.06),
      ],
    );
  }
  Widget enterOtp(BuildContext context, ForgotPasswordController controller){
    return Column(
      children: [
        Center(
          child: Text(
            "Enter OTP",
            style: Theme.of(context).textTheme.titleLarge,
          ).paddingOnly(bottom: Get.height * 0.03,top: Get.height*0.13),
        ),
        Text(
          "A security code has been sent to your email. Please enter it below",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: Get.height * 0.057),
        PinCodeTextField(
          textStyle: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(fontWeight: FontWeight.w400, fontSize: 30),
          animationCurve: Curves.easeInCubic,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(10),
            fieldHeight: 60,
            fieldWidth: 60,
            inactiveColor: AppColors.greyColor,
            selectedColor: AppColors.primaryColor,
            activeColor: AppColors.primaryColor,
            inactiveBorderWidth: 1,
            selectedBorderWidth: 1,
            activeBorderWidth: 1,
          ),
          autoDisposeControllers: true,
          enablePinAutofill: true,
          appContext: context,
          hintStyle:  TextStyle(color: AppColors.greyColor, fontSize: 22),
          hintCharacter: '●',
          blinkWhenObscuring: true,
          cursorColor: AppColors.primaryColor,
          keyboardType: TextInputType.number,
          backgroundColor: Colors.transparent,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          length: 4,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
        ).paddingOnly(left: Get.width*0.06, right: Get.width*0.06,bottom: Get.height*0.02),
        Text(
          "00:00",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        PrimaryButton(onTap: ()=>controller.goToResetPassword(), text: "Verify").paddingOnly(bottom: Get.height*0.04,top: Get.height*0.03),
        RichText(
            text: TextSpan(
            children: [
              TextSpan(
                  text: "Don’t receive code? ",
                  style:Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.darkGreyColor)
              ),
              TextSpan(
                  text: "Re-send",
                  style:Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.primaryColor)
              ),
            ]
        ))
      ],
    );
  }
  Widget resetPassword(BuildContext context,ForgotPasswordController controller){
    return Column(
      children: [
        Center(
          child: Text(
            "Reset Password",
            style: Theme.of(context).textTheme.titleLarge,
          ).paddingOnly(bottom: Get.height * 0.03,top: Get.height*0.13),
        ),
        Text(
          "Enter and confirm a new password to finish resetting.",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: Get.height * 0.05),
        PrimaryTextField(
          scrollPadding: EdgeInsets.only(bottom: Get.height * 0.3),
          hintText: "Password",
        ).paddingOnly(bottom: Get.height * 0.03),
        PrimaryTextField(
          scrollPadding: EdgeInsets.only(bottom: Get.height * 0.3),
          hintText: "Confirm Password",
        ).paddingOnly(bottom: Get.height * 0.05),
        PrimaryButton(onTap: ()=>controller.goToDone(), text: "Change Password").paddingOnly(bottom: Get.height*0.03),

      ],
    );
  }
  Widget welcomeBack(BuildContext context){
    return Column(
      children: [
        Center(
          child: Text(
            "Welcome Back !",
            style: Theme.of(context).textTheme.titleLarge,
          ).paddingOnly(bottom: Get.height * 0.03,top: Get.height*0.23),
        ),
        Text(
          "Your Password has been successfully\nupdated",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: Get.height * 0.05),
        PrimaryButton(onTap: ()=>Get.back(), text: "Done").paddingOnly(bottom: Get.height*0.03),

      ],
    );
  }
}
