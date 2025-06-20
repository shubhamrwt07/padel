import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/primary_button.dart';
import 'package:padel_mobile/configs/components/primary_container.dart';
import 'package:padel_mobile/configs/components/primary_text_feild.dart';
import 'package:padel_mobile/generated/assets.dart';
import 'package:padel_mobile/presentations/login/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PrimaryContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Login Here",
                style: Theme.of(context).textTheme.titleLarge,
              ).paddingOnly(bottom: Get.height * 0.03,top: Get.height*0.13),
              Text(
                "Welcome back you’ve \nbeen missed!",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ).paddingOnly(bottom: Get.height * 0.05),
              PrimaryTextField(
                hintText: "Email",
              ).paddingOnly(bottom: Get.height * 0.03),
              Obx(
                ()=> PrimaryTextField(
                  hintText: "Password",
                  obscureText: controller.isVisible.value,
                  maxLine: 1,
                  suffixIcon: IconButton(onPressed: ()=>controller.eyeToggle(), icon: Icon(controller.isVisible.value?Icons.visibility_off:Icons.visibility)),
                ).paddingOnly(bottom: Get.height * 0.03),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot your password?",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ).paddingOnly(bottom: Get.height*0.06),
              ),
              PrimaryButton(onTap: (){}, text: "Sign in").paddingOnly(bottom: Get.height*0.03),
              Text("Create new account",style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.textColor),).paddingOnly(bottom: Get.height*0.04),
              Text("Or continue with",style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.primaryColor),).paddingOnly(bottom: Get.height*0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    socialContainer(Assets.imagesIcGoggle),
                    socialContainer(Assets.imagesIcFacebook),
                    socialContainer(Assets.imagesIcApple),
                ],
              ).paddingOnly(left: Get.width*0.05,right: Get.width*0.05),
            ],
          ).paddingOnly(left: Get.width * 0.05, right: Get.width * 0.05),
        ),
      ),
    );
  }
  Widget socialContainer(String imagePath){
    return Container(
      height: 44,
      width: 60,
      decoration: BoxDecoration(
          color: AppColors.greyColor,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Image.asset(imagePath,scale: 4.5,),
    ).paddingOnly(right: 10);
  }
}
