import 'package:get/get.dart';

enum ForgotPasswordStep {
  emailEntry,
  otpEntry,
  resetPassword,
  done,
}

class ForgotPasswordController extends GetxController {
  Rx<ForgotPasswordStep> currentStep = ForgotPasswordStep.emailEntry.obs;

  RxBool isVisiblePassword = true.obs;
  RxBool isVisibleConfirmPassword = true.obs;

  void passwordToggle() {
    isVisiblePassword.value = !isVisiblePassword.value;
  } void confirmPasswordToggle() {
    isVisibleConfirmPassword.value = !isVisibleConfirmPassword.value;
  }

  void goToOtp() {
    currentStep.value = ForgotPasswordStep.otpEntry;
  }

  void goToResetPassword() {
    currentStep.value = ForgotPasswordStep.resetPassword;
  }

  void goToDone() {
    currentStep.value = ForgotPasswordStep.done;
  }

  void handleBack() {
    if (currentStep.value == ForgotPasswordStep.emailEntry) {
      Get.back();
    } else if (currentStep.value == ForgotPasswordStep.otpEntry) {
      currentStep.value = ForgotPasswordStep.emailEntry;
    } else if (currentStep.value == ForgotPasswordStep.resetPassword) {
      currentStep.value = ForgotPasswordStep.otpEntry;
    } else if (currentStep.value == ForgotPasswordStep.done) {
      Get.back();
    }
  }
}
