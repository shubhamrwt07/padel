import 'package:padel_mobile/presentations/auth/login/widgets/login_exports.dart';

class LoginController extends GetxController{
 RxBool isVisible = true.obs;
 void eyeToggle(){
   isVisible.value =! isVisible.value;
 }
}