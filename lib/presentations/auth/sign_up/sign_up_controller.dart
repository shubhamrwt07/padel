import 'dart:developer';

import 'package:padel_mobile/data/request_models/authentication_models/sign_up_model.dart';
import 'package:padel_mobile/handler/text_formatter.dart';
import 'package:padel_mobile/presentations/auth/login/login_controller.dart';
import 'package:padel_mobile/presentations/auth/sign_up/widgets/sign_up_exports.dart';
import 'package:padel_mobile/repositories/authentication_repository/login_repository.dart';
import 'package:padel_mobile/repositories/authentication_repository/sign_up_repository.dart';

import '../../../configs/components/snack_bars.dart';
import '../../../core/network/dio_client.dart';
import '../../../data/request_models/authentication_models/login_model.dart';

class SignUpController extends GetxController {
  //Sing up repository
  SignUpRepository signUpRepository = SignUpRepository();
  LoginRepository loginRepository= LoginRepository();
  //Form key
  final formKey = GlobalKey<FormState>();

  //Text controllers
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //Focus nodes
  final emailFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  //Observables values
  RxBool isLoading = false.obs;
  RxString? selectedLocation = RxString('');
  List<String> locations = ['Delhi', 'Mumbai', 'Bangalore', 'Chennai'];
  RxBool isVisiblePassword = true.obs;
  RxBool isVisibleConfirmPassword = true.obs;

  //Functions
  void passwordToggle() => isVisiblePassword.value = !isVisiblePassword.value;

  void confirmPasswordToggle() =>
      isVisibleConfirmPassword.value = !isVisibleConfirmPassword.value;

  //Validations
  String? validateEmail() {
    if (emailController.text.isEmpty) {
      return AppStrings.emailRequired;
    } else if (!GetUtils.isEmail(emailController.text)) {
      return AppStrings.invalidEmail;
    }
  }

  String? validatePhone() {
    if (phoneController.text.isEmpty) {
      return AppStrings.phoneRequired;
    } else if (!GetUtils.isPhoneNumber(phoneController.text)) {
      return AppStrings.invalidPhone;
    }
  }

  String? validatePassword() {
    if (passwordController.text.isEmpty) {
      return AppStrings.passwordRequired;
    } else if (!passwordController.text.isValidPassword) {
      return AppStrings.invalidPassword;
    }
  }

  String? validateConfirmPassword() {
    if (confirmPasswordController.text.isEmpty) {
      return AppStrings.passwordRequired;
    } else if (confirmPasswordController.text != passwordController.text) {
      return AppStrings.invalidConfirmPassword;
    }
  }

  void onFieldSubmit()async {
    if (phoneFocusNode.hasFocus) {
      phoneFocusNode.unfocus();
      emailFocusNode.requestFocus();
    } else if (emailFocusNode.hasFocus) {
      emailFocusNode.unfocus();
      passwordFocusNode.requestFocus();
    } else if (passwordFocusNode.hasFocus) {
      passwordFocusNode.unfocus();
      confirmPasswordFocusNode.requestFocus();
    await  createAccount();
    }
  }

  Future<void> createAccount() async {
    if (formKey.currentState!.validate()) {
      try {
        if (isLoading.value) return;

        isLoading.value = true;
        SignUpModel result = await signUpRepository.createAccount(
          body: {
            "email": emailController.text.trim(),
            "countryCode": "+91",
            "phoneNumber": phoneController.text.trim(),
            "password": passwordController.text.trim(),
            "city": selectedLocation?.value ?? "",
            "agreeTermsAndCondition": true,
            "location": {
              "type": "Point",
              "coordinates": [77.5946, 12.9716],
            },
          },
        );
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
      } catch (e) {
        log(e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }
}
