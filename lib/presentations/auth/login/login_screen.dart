import 'package:padel_mobile/presentations/auth/login/widgets/login_exports.dart';

import '../../../configs/components/loader_widgets.dart';

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
                Column(children: [headerContent(context), formFields(context)]),
                bottomButtonAndContent(context),
              ],
            ).paddingOnly(left: Get.width * 0.05, right: Get.width * 0.05),
          ),
        ),
      ),
    );
  }

  Widget headerContent(BuildContext context) {
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
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          PrimaryTextField(
            controller: controller.emailController,
            focusNode: controller.emailFocusNode,
            hintText: AppStrings.email,
            keyboardType: TextInputType.emailAddress,
            action: TextInputAction.next,
            validator: (v) {
              return controller.validateEmail(v);
            },
            onFieldSubmitted: (_) => controller.onFieldSubmitted,
          ).paddingOnly(bottom: Get.height * 0.03),

          Obx(
            () => PrimaryTextField(
              controller: controller.passwordController,
              focusNode: controller.passwordFocusNode,
              hintText: AppStrings.password,
              obscureText: controller.isVisible.value,
              maxLine: 1,
              action: TextInputAction.done,
              validator: (v) {
                return controller.validatePassword(v);
              },
              onFieldSubmitted: (_) => controller.onFieldSubmitted,
              suffixIcon: IconButton(
                onPressed: () => controller.eyeToggle(),
                icon: SizedBox(
                  height: 20,
                  width: 20,
                  child: Image.asset(
                    controller.isVisible.value
                        ? Assets.imagesIcEyeOff
                        : Assets.imagesIcEye,
                    color: AppColors.textColor,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

            ).paddingOnly(bottom: Get.height * 0.02),
          ),

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
      ),
    );
  }

  Widget bottomButtonAndContent(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Get.offNamed(RoutesName.signUp),
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
            onTap: ()async {
            await  controller.onLogin();
            },
            text:

                 AppStrings.signIn,
            child:controller.isLoading.value?AppLoader(size: 35,strokeWidth: 4,):null,
          ),
        ),

        SizedBox(height: Get.height * 0.05),
      ],
    );
  }
}


