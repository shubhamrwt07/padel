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

            Focus(
              onFocusChange: (hasFocus) {
                controller.isPasswordFocused.value = hasFocus;
              },
              child: PrimaryTextField(
                keyboardType: TextInputType.visiblePassword,
                action: TextInputAction.next,
                onChanged: (v) => controller.checkPasswordConditions(v),
                onFieldSubmitted: (v) => controller.onFieldSubmit(),
                validator: (v) => controller.validatePassword(),
                controller: controller.passwordController,
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
              ),
            ).paddingOnly(bottom: controller.isPasswordFocused.value? 0: Get.height * 0.03),

            Obx(() {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  // Fade + slight slide from top
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: controller.isPasswordFocused.value
                    ? Column(
                  key: const ValueKey("conditions"),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPasswordCondition(
                      "At least 1 Capital Letter",
                      controller.hasCapitalLetter.value,
                    ),
                    _buildPasswordCondition(
                      "At least 1 Special Character",
                      controller.hasSpecialChar.value,
                    ),
                    _buildPasswordCondition(
                      "At least 1 Number",
                      controller.hasNumber.value,
                    ),
                  ],
                )
                    : const SizedBox.shrink(
                  key: ValueKey("empty"),
                ),
              );
            }),

          ],
        ),
      ),
    );
  }
  Widget _buildPasswordCondition(String text, bool value) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.8,
          child: Checkbox(
            value: value,
            onChanged: null,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            fillColor: WidgetStateProperty.resolveWith<Color>(
                  (states) {
                if (value) return Colors.green;
                return Colors.grey.shade50;
              },
            ),
            checkColor: Colors.white,
          ),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
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
    ).paddingOnly(bottom: Get.height * 0.05);
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
