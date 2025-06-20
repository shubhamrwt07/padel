import 'package:get/get.dart';

class LoginController extends GetxController{
 RxBool isVisible = false.obs;
 void eyeToggle(){
   isVisible.value =! isVisible.value;
 }
}