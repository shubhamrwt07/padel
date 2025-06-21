import 'package:get/get.dart';

class SignUpController extends GetxController{
  RxString? selectedLocation = RxString('');
  List<String> locations = ['Delhi', 'Mumbai', 'Bangalore', 'Chennai'];
  RxBool isVisiblePassword = true.obs;
  RxBool isVisibleConfirmPassword = true.obs;
  void passwordToggle()=>isVisiblePassword.value =! isVisiblePassword.value;
  void confirmPasswordToggle()=>isVisibleConfirmPassword.value =! isVisibleConfirmPassword.value;

}