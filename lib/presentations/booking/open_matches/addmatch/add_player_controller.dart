import 'package:get/get.dart';
import 'package:flutter/material.dart';
class ManualBookingOpenMatchesController extends GetxController{
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  RxString gender = 'Male'.obs;
  RxString playerLevel = 'All Players'.obs;

  List<String> playerLevels = [
    'All Players',
    'A',
    'B',
    'C',
    'D',
    'A/B',
    'B/C',
    'C/D',
  ];
}