import 'package:get/get.dart';

class LoginController extends GetxController{
 RxBool isVisible = true.obs;
 void eyeToggle(){
   isVisible.value =! isVisible.value;
 }
}