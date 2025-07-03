import 'dart:developer';

import 'package:padel_mobile/configs/routes/routes.dart';
import 'package:padel_mobile/core/network/dio_client.dart';
import 'package:padel_mobile/data/request_models/authentication_models/login_model.dart';
import 'package:padel_mobile/handler/text_formatter.dart';
import 'package:padel_mobile/presentations/auth/login/widgets/login_exports.dart';
import 'package:padel_mobile/repositories/authentication_repository/login_repository.dart';

import '../../../configs/components/snack_bars.dart';

class LoginController extends GetxController {
  //Login Repository
  final LoginRepository loginRepository = LoginRepository();

  // Text Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Focus Nodes
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  // Observable variables
  RxBool isVisible = true.obs;
  RxBool isLoading = false.obs;

  //Form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Toggle password visibility
  void eyeToggle() {
    isVisible.value = !isVisible.value;
  }

  void onFieldSubmitted() async {
    if (emailFocusNode.hasFocus) {
      emailFocusNode.unfocus();
      passwordFocusNode.requestFocus();
    } else {
      passwordFocusNode.unfocus();
      await onLogin();
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired;
    } else if (!value.isValidEmail) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    } else if (!value.isValidPassword) {
      return AppStrings.invalidPassword;
    }
    return null;
  }

  Future<void> onLogin() async {
    if (formKey.currentState!.validate()) {
      try {
        if (isLoading.value) return;

        isLoading.value = true;
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

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }
}
