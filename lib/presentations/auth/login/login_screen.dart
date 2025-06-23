import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/primary_button.dart';
import 'package:padel_mobile/configs/components/primary_container.dart';
import 'package:padel_mobile/configs/components/primary_text_feild.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/generated/assets.dart';
import 'package:padel_mobile/presentations/auth/login/login_controller.dart';

import '../common_wigets/common_widgets.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      child: Scaffold(
        body: GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus!.unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                topTexts(context),
                formFields(),
                bottomButtonAndContent(context)
              ],
            ).paddingOnly(left: Get.width * 0.05, right: Get.width * 0.05),
          ),
        ),
      ),
    );
  }
  Widget topTexts(BuildContext context){
    return Column(
      children: [
        Text(
          "Login Here",
          style: Theme.of(context).textTheme.titleLarge,
        ).paddingOnly(bottom: Get.height * 0.03,top: Get.height*0.13),
        Text(
          "Welcome back you’ve \nbeen missed!",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: Get.height * 0.05),
      ],
    );
  }
  Widget formFields(){
    return Column(
      children: [
        PrimaryTextField(
          // scrollPadding: EdgeInsets.only(bottom: Get.height * 0.3),
          hintText: "Email",
        ).paddingOnly(bottom: Get.height * 0.03),
        Obx(
              ()=> PrimaryTextField(
            scrollPadding: EdgeInsets.only(bottom: Get.height * 0.25),
            hintText: "Password",
            obscureText: controller.isVisible.value,
            maxLine: 1,
            suffixIcon: IconButton(onPressed: ()=>controller.eyeToggle(), icon: Icon(controller.isVisible.value?Icons.visibility_off:Icons.visibility,color: AppColors.textColor,)),
          ).paddingOnly(bottom: Get.height * 0.03),
        ),
      ],
    );
  }
  Widget bottomButtonAndContent(BuildContext context){
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: (){
              Get.toNamed(RoutesName.forgotPassword);
              FocusManager.instance.primaryFocus!.unfocus();
            },
            child: Container(
              color: Colors.transparent,
              child: Text(
                "Forgot your password?",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ),
        PrimaryButton(onTap: (){
          FocusManager.instance.primaryFocus!.unfocus();
          Get.toNamed(RoutesName.home);
        }, text: "Sign in").paddingOnly(bottom: Get.height*0.03,top: Get.height*0.06),
        GestureDetector(
          onTap: ()=>Get.toNamed(RoutesName.signUp),
          child: Container(
              color: Colors.transparent,
              child: Text("Create new account",style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.textColor),).paddingOnly(bottom: Get.height*0.04)),
        ),
        Text("Or continue with",style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.primaryColor),).paddingOnly(bottom: Get.height*0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            socialContainer(Assets.imagesIcGoogle),
            socialContainer(Assets.imagesIcFacebook),
            socialContainer(Assets.imagesIcApple),
          ],
        ).paddingOnly(left: Get.width*0.05,right: Get.width*0.05),
      ],
    );
  }
}
