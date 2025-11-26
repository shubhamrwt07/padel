// SignUpController.dart
import 'dart:developer';
import 'package:padel_mobile/handler/text_formatter.dart';
import 'package:padel_mobile/data/request_models/authentication_models/sign_up_model.dart';
import 'package:padel_mobile/presentations/auth/sign_up/widgets/sign_up_exports.dart';
import 'package:padel_mobile/presentations/notification/notification_controller.dart';

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

  RxBool isLoading = false.obs;



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
  void onFieldSubmit() async {
    if (phoneFocusNode.hasFocus) {
      phoneFocusNode.unfocus();
      emailFocusNode.requestFocus();
    } else if (emailFocusNode.hasFocus) {
      emailFocusNode.unfocus();
      passwordFocusNode.requestFocus();
    } else if (passwordFocusNode.hasFocus) {
      passwordFocusNode.unfocus();
    }
  }

  //Password--------------------------------------------------------------------
  var hasSpecialChar = false.obs;
  var hasNumber = false.obs;
  var hasCapitalLetter = false.obs;
  RxBool isVisiblePassword = true.obs;
  var isPasswordFocused = false.obs;
  void passwordToggle() => isVisiblePassword.value = !isVisiblePassword.value;
  void checkPasswordConditions(String password) {
    hasSpecialChar.value = RegExp(r'[!@#\$&*~]').hasMatch(password);
    hasNumber.value = RegExp(r'[0-9]').hasMatch(password);
    hasCapitalLetter.value = RegExp(r'[A-Z]').hasMatch(password);
  }
  @override
  void onInit() async{
    await fetchLocations();
    passwordFocusNode.addListener(() {
      isPasswordFocused.value = passwordFocusNode.hasFocus;
    });
    super.onInit();
  }
  @override
  void onClose() {
    phoneFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    passwordController.dispose();
    super.onClose();
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
      "lastName": lastNameController.text.trim(),
      "countryCode": "+91",
      "phoneNumber": phoneController.text.trim(),
      "password": passwordController.text.trim(),
      "city": selectedLocation.value,
      "agreeTermsAndCondition": true,
      "location": {
        "type": "Point",
        "coordinates": [77.5946, 12.9716],
      },
    };

    log("Signup Body: $body");

    SignUpModel result = await signUpRepository.createAccount(body: body);

    if (result.status == "200") {
      // Try to read FCM token from storage; if empty, proactively fetch via NotificationController
      String? firebaseToken = storage.read('firebase_token');
      if (firebaseToken == null || firebaseToken.isEmpty) {
        final notificationController = NotificationController.instance;
        // Ensure permissions and try to refresh token
        await notificationController.requestPermissions();
        await notificationController.refreshToken();
        firebaseToken = notificationController.getStoredToken();
      }
      LoginModel result = await loginRepository.loginUser(
        body: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "fcmToken":firebaseToken??""
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
  
  ///Get Location Api----------------------------------------------------
  var isLocationLoading = false.obs;
  var locations = <GetLocationData>[].obs;
  var selectedLocation = ''.obs;
  Future<void>fetchLocations()async{
    isLocationLoading.value = true;
    try{
      final response = await signUpRepository.getLocations();
      if(response.status == true){
        locations.assignAll(response.data?.toList()??[]);
      }
    }catch(e){
      CustomLogger.logMessage(msg: "Error :-> $e", level: LogLevel.error);
    }finally{
      isLocationLoading.value = false;
    }
  }

}
