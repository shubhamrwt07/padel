import 'package:get/get.dart';

class RoleController extends GetxController {
  var  role = ''.obs;

   void setRole(String newRole) {
    role.value= newRole;
  }



}