import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:padel_mobile/configs/components/primary_button.dart';
import 'package:padel_mobile/configs/components/primary_container.dart';
import 'package:padel_mobile/configs/components/primary_text_feild.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/presentations/auth/sign_up/sign_up_controller.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      child: GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Scaffold(
          appBar: primaryAppBar(title: SizedBox(), context: context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                topTexts(context),
                formFields(),
                locationField(context),
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
          "Create Account",
          style: Theme.of(context).textTheme.titleLarge,
        ).paddingOnly(bottom: Get.height * 0.02,top: Get.height*0.05),
        Text(
          "Create an account so you can explore all\nthe existing jobs",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: Get.height * 0.06),
      ],
    );
  }
  Widget formFields(){
    return Obx(
      ()=> Column(
        children: [
          PrimaryTextField(
            hintText: "Email",
          ).paddingOnly(bottom: Get.height * 0.03),
          PrimaryTextField(
            hintText: "Password",
            obscureText: controller.isVisiblePassword.value,
            maxLine: 1,
            suffixIcon: IconButton(onPressed: ()=>controller.passwordToggle(), icon: Icon(controller.isVisiblePassword.value?Icons.visibility_off:Icons.visibility,color: AppColors.textColor,)),
          ).paddingOnly(bottom: Get.height * 0.03),
          PrimaryTextField(
            hintText: "Confirm Password",
            obscureText: controller.isVisibleConfirmPassword.value,
            maxLine: 1,
            suffixIcon: IconButton(onPressed: ()=>controller.confirmPasswordToggle(), icon: Icon(controller.isVisibleConfirmPassword.value?Icons.visibility_off:Icons.visibility,color: AppColors.textColor,)),
          ).paddingOnly(bottom: Get.height * 0.03),
        ],
      ),
    );
  }
  Widget locationField(BuildContext context) {
    final controller = Get.find<SignUpController>();

    return Container(
      height: 55,
      width: Get.width,
      decoration: BoxDecoration(
        color: AppColors.textFieldColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
      child: Obx(() {
        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedLocation!.isEmpty
                ? null
                : controller.selectedLocation!.value,
            hint: Text(
              'Location',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: AppColors.textColor,
              ),
            ),
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textColor),
            dropdownColor: AppColors.textFieldColor,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.textColor),
            onChanged: (value) {
              if (value != null) controller.selectedLocation!.value = value;
            },
            items: controller.locations.map((location) {
              return DropdownMenuItem<String>(
                value: location,
                child: Text(location),
              );
            }).toList(),
          ),
        );
      }),
    ).paddingOnly(bottom: Get.height * 0.07);
  }
  Widget bottomButtonAndContent(BuildContext context){
    return Column(
      children: [
        PrimaryButton(onTap: (){}, text: "Create").paddingOnly(bottom: Get.height*0.04),
        GestureDetector(
          onTap: (){
            Get.toNamed(RoutesName.login);
          },
          child: Container(
            color: Colors.transparent,
            child: RichText(text: TextSpan(
              children:[
                TextSpan(
                  text: "Already have an account ",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.darkGreyColor)
                ),
                TextSpan(
                    text: "Sign in",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.primaryColor)
                ),
              ]
            )),
          ),
        )
      ],
    );
  }
}
