
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/presentations/auth/forgot_password/forgot_password_controller.dart';
import 'package:padel_mobile/presentations/auth/forgot_password/widgets/reset_password_screen.dart';
import 'package:padel_mobile/repositories/authentication_repository/sign_up_repository.dart';

import '../../../configs/components/snack_bars.dart';
import '../sign_up/sign_up_controller.dart';

enum OtpScreenType { createAccount, forgotPassword }

class OtpController extends GetxController {
  SignUpRepository signUpRepository = SignUpRepository();
  SignUpController signUpController = Get.put(SignUpController());
  ForgotPasswordController forgotPasswordController = Get.put(ForgotPasswordController());

  final TextEditingController valueController = TextEditingController();
  final arguments = Get.arguments;
  RxBool isLoading = false.obs;

  Future<void> verifyOTP() async {
    FocusManager.instance.primaryFocus!.unfocus();
    try {
      if (isLoading.value) return;
      isLoading.value = true;
      Map<String, dynamic> body = {
        "email": arguments['email'],
        "otp": valueController.text.trim(),
      };
      var result = await signUpRepository.verifyOTP(body: body);
      if (result.status == "200") {
        getPurpose();
      } else {
        SnackBarUtils.showErrorSnackBar(result.message!);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void getPurpose() async {
    if (OtpScreenType.createAccount == arguments['type']) {
      await signUpController.createAccount();
    } else {
     Get.to(()=>ResetPasswordScreen());
    }
  }



  void resendOtp() async{
  await forgotPasswordController.sendOTP();
    startTimer();
  }
  Timer? _timer;
  RxInt secondsRemaining = 60.obs;
  void startTimer() {
    _timer?.cancel();
    secondsRemaining.value = 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        _timer?.cancel();
      }
    });
  }
  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
