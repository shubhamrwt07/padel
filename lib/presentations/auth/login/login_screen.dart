import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/primary_button.dart';
import 'package:padel_mobile/configs/components/primary_container.dart';
import 'package:padel_mobile/configs/components/primary_text_feild.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/presentations/auth/login/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusManager.instance.primaryFocus!.unfocus(),
      child: PrimaryContainer(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    topTexts(context),
                    formFields(context),
                  ],
                ),
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
          "Login here",
          style: Theme.of(context).textTheme.titleLarge,
        ).paddingOnly(bottom: Get.height * 0.03,top: Get.height*0.15),
        Text(
          "Welcome back you’ve \nbeen missed!",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: Get.height * 0.06),
      ],
    );
  }
  Widget formFields(BuildContext context){
    return Column(
      children: [
        PrimaryTextField(
          // scrollPadding: EdgeInsets.only(bottom: Get.height * 0.3),
          hintText: "Email",
        ).paddingOnly(bottom: Get.height * 0.03),
        Obx(
              ()=> PrimaryTextField(
            // scrollPadding: EdgeInsets.only(bottom: Get.height * 0.25),
            hintText: "Password",
            obscureText: controller.isVisible.value,
            maxLine: 1,
            suffixIcon: IconButton(onPressed: ()=>controller.eyeToggle(), icon: Icon(controller.isVisible.value?Icons.visibility_off:Icons.visibility,color: AppColors.textColor,)),
          ).paddingOnly(bottom: Get.height * 0.02),
        ),
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
        ).paddingOnly(
    bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? Get.height * 0.03 : Get.height * 0.32,),
      ],
    );
  }
  Widget bottomButtonAndContent(BuildContext context){
    return Column(
      children: [
        GestureDetector(
          onTap: ()=>Get.toNamed(RoutesName.signUp),
          child: Container(
              color: Colors.transparent,
              child: Text("Create new account",style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.textColor),).paddingOnly(bottom: Get.height*0.025)),
        ),
        PrimaryButton(onTap: (){
          FocusManager.instance.primaryFocus!.unfocus();
          Get.toNamed(RoutesName.bottomNav);
        }, text: "Sign in",),
        SizedBox(height: Get.height*0.05,)
      ],
    );
  }
}
