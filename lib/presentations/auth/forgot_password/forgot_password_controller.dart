import 'package:get/get.dart';
enum ForgotPasswordStep {
  emailEntry,
  otpEntry,
  resetPassword,
  done
}
class ForgotPasswordController extends GetxController{
  var currentStep = ForgotPasswordStep.emailEntry.obs;

  void goToOtp() => currentStep.value = ForgotPasswordStep.otpEntry;
  void goToResetPassword() => currentStep.value = ForgotPasswordStep.resetPassword;
  void goToDone() => currentStep.value = ForgotPasswordStep.done;

  void handleBack() {
    switch (currentStep.value) {
      case ForgotPasswordStep.done:
        currentStep.value = ForgotPasswordStep.resetPassword;
        break;
      case ForgotPasswordStep.resetPassword:
        currentStep.value = ForgotPasswordStep.otpEntry;
        break;
      case ForgotPasswordStep.otpEntry:
        currentStep.value = ForgotPasswordStep.emailEntry;
        break;
      case ForgotPasswordStep.emailEntry:
        Get.back();
        break;
    }
  }
}