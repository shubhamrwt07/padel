import 'package:padel_mobile/presentations/auth/sign_up/widgets/sign_up_exports.dart';

class SignUpController extends GetxController{
  RxString? selectedLocation = RxString('');
  List<String> locations = ['Delhi', 'Mumbai', 'Bangalore', 'Chennai'];
  RxBool isVisiblePassword = true.obs;
  RxBool isVisibleConfirmPassword = true.obs;
  void passwordToggle()=>isVisiblePassword.value =! isVisiblePassword.value;
  void confirmPasswordToggle()=>isVisibleConfirmPassword.value =! isVisibleConfirmPassword.value;

}