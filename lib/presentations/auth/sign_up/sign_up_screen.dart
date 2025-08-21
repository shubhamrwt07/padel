// SignUpScreen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/components/loader_widgets.dart';
import 'package:padel_mobile/presentations/auth/sign_up/widgets/sign_up_exports.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: PrimaryContainer(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: primaryAppBar(title: const SizedBox(), context: context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                topTexts(context),
                formFields(),
                locationField(context), // ✅ Added Location field
                bottomButtonAndContent(context),
              ],
            ).paddingOnly(left: Get.width * 0.05, right: Get.width * 0.05),
          ),
        ),
      ),
    );
  }

  Widget topTexts(BuildContext context) {
    return Column(
      children: [
        Text(
          "Create Account",
          style: Theme.of(context).textTheme.titleLarge,
        ).paddingOnly(bottom: Get.height * 0.02, top: Get.height * 0.02),
        Text(
          "Create an account so you can start booking.",
          style: Theme.of(context).textTheme.headlineMedium!
              .copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: Get.height * 0.06),
      ],
    );
  }

  Widget formFields() {
    return Obx(
          () => Form(
        key: controller.formKey,
        child: Column(
          children: [
            PrimaryTextField(
              keyboardType: TextInputType.name,
              action: TextInputAction.next,
              onFieldSubmitted: (v) => controller.onFieldSubmit(),
              controller: controller.firstNameController,
              hintText: "First Name",
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return "First name is required";
                }
                return null;
              },
            ).paddingOnly(bottom: Get.height * 0.03),

            PrimaryTextField(
              keyboardType: TextInputType.name,
              action: TextInputAction.next,
              onFieldSubmitted: (v) => controller.onFieldSubmit(),
              controller: controller.lastNameController,
              hintText: "Last Name",
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return "Last name is required";
                }
                return null;
              },
            ).paddingOnly(bottom: Get.height * 0.03),

            PrimaryTextField(
              keyboardType: TextInputType.phone,
              action: TextInputAction.next,
              maxLength: 10,
              onFieldSubmitted: (v) => controller.onFieldSubmit(),
              controller: controller.phoneController,
              focusNode: controller.phoneFocusNode,
              validator: (v) => controller.validatePhone(),
              hintText: "Phone Number",
            ).paddingOnly(bottom: Get.height * 0.03),

            PrimaryTextField(
              keyboardType: TextInputType.emailAddress,
              action: TextInputAction.next,
              onFieldSubmitted: (v) => controller.onFieldSubmit(),
              validator: (v) => controller.validateEmail(),
              controller: controller.emailController,
              focusNode: controller.emailFocusNode,
              hintText: "Email",
            ).paddingOnly(bottom: Get.height * 0.03),

            PrimaryTextField(
              keyboardType: TextInputType.visiblePassword,
              action: TextInputAction.next,
              onFieldSubmitted: (v) => controller.onFieldSubmit(),
              validator: (v) => controller.validatePassword(),
              controller: controller.passwordController,
              focusNode: controller.passwordFocusNode,
              hintText: "Password",
              obscureText: controller.isVisiblePassword.value,
              maxLine: 1,
              suffixIcon: IconButton(
                onPressed: () => controller.passwordToggle(),
                icon: Image.asset(
                  controller.isVisiblePassword.value
                      ? Assets.imagesIcEyeOff
                      : Assets.imagesIcEye,
                  color: AppColors.textColor,
                  height: 20,
                  width: 20,
                ),
              ),
            ).paddingOnly(bottom: Get.height * 0.03),
          ],
        ),
      ),
    );
  }

  /// ✅ New Location Dropdown
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
              AppStrings.preferenceLocation,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: AppColors.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textColor),
            dropdownColor: AppColors.textFieldColor,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
            ),
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
    ).paddingOnly(
      bottom: MediaQuery.of(context).viewInsets.bottom > 0
          ? Get.height * 0.05
          : Get.height * 0.1,
    );
  }
  Widget bottomButtonAndContent(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.offNamed(RoutesName.login);
          },
          child: Container(
            color: Colors.transparent,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Already have an account? ",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: AppColors.darkGreyColor,
                    ),
                  ),
                  TextSpan(
                    text: "Sign In",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).paddingOnly(bottom: Get.height * 0.03),
        Obx(
              () => PrimaryButton(
            onTap: () async {
              await controller.onCreate();
            },
            text: "Create",
            child: controller.isLoading.value
                ? AppLoader(size: 35, strokeWidth: 4)
                : null,
          ),
        ),
        SizedBox(height: Get.height * 0.04),
      ],
    );
  }
}
