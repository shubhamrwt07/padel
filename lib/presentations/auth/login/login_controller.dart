import 'package:padel_mobile/presentations/auth/login/widgets/login_exports.dart';

class LoginController extends GetxController {
  // Text Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Focus Nodes
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  // Observable variables
  RxBool isVisible = true.obs;
  RxBool isLoading = false.obs;
  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;


  @override
  void onClose() {
    // Check if controllers are already disposed before disposing
    if (!emailController.hasListeners) {
      emailController.dispose();
    }
    if (!passwordController.hasListeners) {
      passwordController.dispose();
    }
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

  // Toggle password visibility
  void eyeToggle() {
    isVisible.value = !isVisible.value;
  }

  // Clear errors when user starts typing (optional - only clears errors, doesn't validate)
  void onEmailChanged(String value) {
    // Check if controller is still active before accessing reactive variables
    if (!_isDisposed && emailError.value.isNotEmpty) {
      emailError.value = '';
    }
  }

  void onPasswordChanged(String value) {
    // Check if controller is still active before accessing reactive variables
    if (!_isDisposed && passwordError.value.isNotEmpty) {
      passwordError.value = '';
    }
  }

  // Flag to track if controller is disposed
  final bool _isDisposed = false;

  // Validate form only on button click
  bool _validateForm() {
    bool isValid = true;

    // Clear previous errors
    emailError.value = '';
    passwordError.value = '';

    // Email validation
    if (emailController.text.isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!_isValidEmail(emailController.text)) {
      emailError.value = 'Please enter a valid email address';
      isValid = false;
    }

    // Password validation
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters long';
      isValid = false;
    }

    return isValid;
  }

  // Helper method to check valid email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  // Handle login process
  Future<void> handleLogin() async {
    // Unfocus any focused field
    FocusManager.instance.primaryFocus?.unfocus();

    // Validate form only when button is clicked
    if (!_validateForm()) {
      return;
    }

    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      String email = emailController.text.trim();
      String password = passwordController.text;

      if (email == "test@example.com" && password == "123456") {
        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.TOP,

          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Navigate to main screen after short delay
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(RoutesName.bottomNav);
      } else {
        Get.snackbar(
          'Error',
          'Invalid email or password',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.TOP,

        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }


  void clearFields() {
    if (!_isDisposed) {
      emailController.clear();
      passwordController.clear();
      emailError.value = '';
      passwordError.value = '';
    }
  }

  // Clear specific field errors
  void clearEmailError() {
    if (!_isDisposed) {
      emailError.value = '';
    }
  }

  void clearPasswordError() {
    if (!_isDisposed) {
      passwordError.value = '';
    }
  }
}

class ValidationUtils {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Trim whitespace
    value = value.trim();

    // Check email format
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }
}