// SignUpController.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/components/snack_bars.dart';
import 'package:padel_mobile/core/network/dio_client.dart';
import 'package:padel_mobile/data/request_models/authentication_models/login_model.dart';
import 'package:padel_mobile/data/request_models/authentication_models/sign_up_model.dart';
import 'package:padel_mobile/handler/text_formatter.dart';
import 'package:padel_mobile/presentations/auth/otp/otp_controller.dart';
import 'package:padel_mobile/repositories/authentication_repository/login_repository.dart';
import 'package:padel_mobile/repositories/authentication_repository/sign_up_repository.dart';

import '../../../configs/routes/routes_name.dart';

class SignUpController extends GetxController {
  SignUpRepository signUpRepository = SignUpRepository();
  LoginRepository loginRepository = LoginRepository();

  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final emailFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  RxBool isLoading = false.obs;
  RxString? selectedLocation = RxString('');
  List<String> locations = ['Delhi', 'Mumbai', 'Bangalore', 'Chennai'];
  RxBool isVisiblePassword = true.obs;
  RxBool isVisibleConfirmPassword = true.obs;

  void passwordToggle() => isVisiblePassword.value = !isVisiblePassword.value;
  void confirmPasswordToggle() =>
      isVisibleConfirmPassword.value = !isVisibleConfirmPassword.value;

  String? validateEmail() {
    if (emailController.text.isEmpty) {
      return "Email is required";
    } else if (!GetUtils.isEmail(emailController.text)) {
      return "Invalid email format";
    }
    return null;
  }

  String? validatePhone() {
    if (phoneController.text.isEmpty) {
      return "Phone number is required";
    } else if (!GetUtils.isPhoneNumber(phoneController.text)) {
      return "Invalid phone number";
    }
    return null;
  }

  String? validatePassword() {
    if (passwordController.text.isEmpty) {
      return "Password is required";
    } else if (!passwordController.text.isValidPassword) {
      return "Invalid password format";
    }
    return null;
  }

  String? validateConfirmPassword() {
    if (confirmPasswordController.text.isEmpty) {
      return "Confirm Password is required";
    } else if (confirmPasswordController.text != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  void onFieldSubmit() async {
    if (phoneFocusNode.hasFocus) {
      phoneFocusNode.unfocus();
      emailFocusNode.requestFocus();
    } else if (emailFocusNode.hasFocus) {
      emailFocusNode.unfocus();
      passwordFocusNode.requestFocus();
    } else if (passwordFocusNode.hasFocus) {
      passwordFocusNode.unfocus();
      confirmPasswordFocusNode.requestFocus();
    }
  }

  Future<void> onCreate() async {
    FocusManager.instance.primaryFocus!.unfocus();
    if (formKey.currentState!.validate()) {
      try {
        if (isLoading.value) return;

        isLoading.value = true;

        await sendOTP();
      } catch (e) {
        log(e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> sendOTP() async {
    Map<String, dynamic> body = {
      "email": emailController.text.trim(),
      "type": "Signup",
    };
    var result = await signUpRepository.sendOTP(body: body);
    if (result.status == "200") {
      Get.toNamed(
        RoutesName.otp,
        arguments: {
          "email": emailController.text.trim(),
          "type": OtpScreenType.createAccount,
          // "name": firstNameController.text.trim(),
          // "lastName": lastNameController.text.trim(),
        },
      );
    } else {
      SnackBarUtils.showErrorSnackBar(result.message!);
    }
  }

  Future<void> createAccount() async {
    final body = {
      "email": emailController.text.trim(),
      "name": firstNameController.text.trim(),
      "lastname": lastNameController.text.trim(),
      "countryCode": "+91",
      "phoneNumber": phoneController.text.trim(),
      "password": passwordController.text.trim(),
      "city": selectedLocation?.value ?? "Chandigarh",
      "agreeTermsAndCondition": true,
      "location": {
        "type": "Point",
        "coordinates": [77.5946, 12.9716],
      },
    };

    log("Signup Body: $body");

    SignUpModel result = await signUpRepository.createAccount(body: body);

    if (result.status == "200") {
      LoginModel result = await loginRepository.loginUser(
        body: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );
      if (result.status == "200") {
        storage.write('token', result.response!.token);
        storage.write('userId', result.response!.user!.id);
        Get.offAllNamed(RoutesName.bottomNav);
      }
    } else {
      SnackBarUtils.showErrorSnackBar(result.message!);
    }
  }
}
