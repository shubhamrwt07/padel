import 'package:padel_mobile/presentations/auth/login/widgets/login_exports.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: PrimaryContainer(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Column(children: [topTexts(context), formFields(context)]),
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
          AppStrings.login,
          style: Theme.of(context).textTheme.titleLarge,
        ).paddingOnly(bottom: Get.height * 0.03, top: Get.height * 0.15),
        Text(
          AppStrings.welcome,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: Get.height * 0.06),
      ],
    );
  }

  Widget formFields(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryTextField(
                controller: controller.emailController,
                focusNode: controller.emailFocusNode,
                hintText: AppStrings.email,
                keyboardType: TextInputType.emailAddress,
                action: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    controller.passwordFocusNode.requestFocus(),
                onChanged: controller.onEmailChanged,
              ),

              if (controller.emailError.value.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8, left: Get.width * 0.04),
                  child: Text(
                    controller.emailError.value,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ).paddingOnly(bottom: Get.height * 0.03),

        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryTextField(
                controller: controller.passwordController,
                focusNode: controller.passwordFocusNode,
                hintText: AppStrings.password,
                obscureText: controller.isVisible.value,
                maxLine: 1,
                action: TextInputAction.done,
                onFieldSubmitted: (_) => controller.handleLogin(),
                onChanged: controller.onPasswordChanged,
                suffixIcon: IconButton(
                  onPressed: () => controller.eyeToggle(),
                  icon: Image.asset(
                    controller.isVisible.value
                        ? Assets.imagesIcEyeOff
                        : Assets.imagesIcEye,
                    color: AppColors.textColor,
                    height: Get.height * .05,
                    width: Get.width * .05,
                  ),
                ),
              ),

              if (controller.passwordError.value.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8, left: Get.width * 0.04),
                  child: Text(
                    controller.passwordError.value,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ).paddingOnly(bottom: Get.height * 0.02),

        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              Get.toNamed(RoutesName.forgotPassword);
              FocusManager.instance.primaryFocus!.unfocus();
            },
            child: Container(
              color: Colors.transparent,
              child: Text(
                AppStrings.forgotYourPassword,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ).paddingOnly(
          bottom: MediaQuery.of(context).viewInsets.bottom > 0
              ? Get.height * 0.03
              : Get.height * 0.32,
        ),
      ],
    );
  }

  Widget bottomButtonAndContent(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Get.toNamed(RoutesName.signUp),
          child: Container(
            color: Colors.transparent,
            child: Text(
              AppStrings.createNewAccount,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(color: AppColors.textColor),
            ).paddingOnly(bottom: Get.height * 0.025),
          ),
        ),

        Obx(
          () => PrimaryButton(
            onTap: () {
              controller.handleLogin();
            },
            text: controller.isLoading.value
                ? "Signing In..."
                : AppStrings.signIn,
          ),
        ),

        SizedBox(height: Get.height * 0.05),
      ],
    );
  }
}
