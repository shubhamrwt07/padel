import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:padel_mobile/presentations/booking/details_page/details_model.dart';
import 'package:padel_mobile/repositories/openmatches/open_match_repository.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/components/primary_button.dart';
class DetailsController extends GetxController{
  OpenMatchRepository repository=OpenMatchRepository();
  Rx<OpenMatchDetailsModel> model=OpenMatchDetailsModel().obs;
  ///show Cancel Match Dialog Box---------------------------------------
  void showCancelMatchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Cancel Match',style: Get.textTheme.headlineMedium,),
        content: Text('Are you sure you want to cancel this match?',style: Get.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w400),),
        actions: [
          PrimaryButton(
              height: 45,
              width: 80,
              // color: AppColors.textColor.withValues(alpha: 0.5),
              onTap: (){
                Get.back();
              }, text: "No").paddingOnly(right: 5),
          PrimaryButton(
              height: 45,
              width: 80,
              // borderRadius: BorderRadius.circular(10),
              onTap: (){
                Get.close(2);
                // createManualBooking();
              }, text: "Yes"),
        ],
      ),
    );
  }
    getMatch()async{
    log("message");
    model.value = await repository.getParticularMatch();
  }
  @override
  void onInit() {

    getMatch();
    super.onInit();
  }
}