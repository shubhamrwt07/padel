import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';

import '../../../configs/components/primary_button.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: Get.height * .1,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.center,
          child: PrimaryButton(
            height: 40,

            onTap: () {
              Get.back();
            },
            text: "Apply Filter",
          ).paddingOnly(left: 20,right: 20),
        ),
      ),
      appBar: primaryAppBar(
        title: Text("Details"),
        context: context,
        action: [
          appBarAction(
            Colors.white,
            Icon(Icons.share, color: Colors.black, size: 18),
          ),
          SizedBox(width: Get.width * .04),
          appBarAction(
            AppColors.primaryColor,
            Icon(Icons.message, color: Colors.white, size: 18),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: Get.height * .18,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.playerCardBackgroundColor,
              border: Border.all(color: AppColors.greyColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: SvgPicture.asset('assets/images/padel_icon.svg'),
                  title: Text("Padel", style: Get.textTheme.headlineSmall),
                  subtitle: Text(
                    "21 June | 9:00am - 10:00am",
                    style: Get.textTheme.labelLarge!.copyWith(
                      color: AppColors.darkGreyColor,
                    ),
                  ),
                ),
                Divider(color: AppColors.greyColor),
                Flexible(
                  child: Row(
                    children: [
                      Expanded(child: gameDetails("Gender", "All Players")),
                      Expanded(child: gameDetails("Level", "0.92 - 0.132")),
                      Expanded(child: gameDetails("Price", "₹2000")),
                    ],
                  ),
                ),
              ],
            ).paddingAll(10),
          ),
          SizedBox(height: Get.height * .015),
          Container(
            height: Get.height * .05,
            width: Get.width,
            decoration: BoxDecoration(
              color: AppColors.playerCardBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.greyColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Court Number"), Text('1')],
            ).paddingOnly(left: 15, right: 15),
          ),
          SizedBox(height: Get.height * .015),
          gameCard(),
          SizedBox(height: Get.height * .015),
          Container(
            height: Get.height * .16,
            width: Get.width,
            decoration: BoxDecoration(
              color: AppColors.playerCardBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.greyColor),
            ),
            child: Row(
              children: [
                Container(
                  height: Get.height * .14,
                  width: Get.width * .3,

                  decoration: BoxDecoration(
                    color: AppColors.playerCardBackgroundColor,
                    border: Border.all(color: AppColors.greyColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width * .49,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("The Good Club", style: Get.textTheme.bodySmall),
                          Icon(CupertinoIcons.location),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: Get.height * .09,
                      width: Get.width * .49,
                      child: Text(
                        "Sukhna Enclave, behind Rock Garden, Kaimbwala, Kansal, Chandigarh 160001",
                        style: Get.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ).paddingOnly(right: 10),
              ],
            ).paddingAll(15),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text("Information",style: Get.textTheme.titleSmall,),
          )
        ],
      ).paddingAll(16),
    );
  }

  Widget appBarAction(Color backgroundColor, Widget child) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: backgroundColor,
        child: child,
      ),
    );
  }

  Widget gameDetails(String title, String subtitle) {
    return Container(
      alignment: Alignment.center,
      height: Get.height * .1,
      color: AppColors.playerCardBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Get.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: Get.height * .01),
          Text(subtitle, style: Get.textTheme.labelLarge),
        ],
      ),
    );
  }

  Widget playerCard(String name, bool showSubtitle) {
    return Column(
      children: [
        CircleAvatar(radius: 25),
        SizedBox(height: 5),
        Text(
          name,
          style: Get.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 5),
        showSubtitle
            ? Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 20,
                width: 40,
                child: Text(
                  "B/C",
                  style: Get.textTheme.bodyLarge!.copyWith(color: Colors.green),
                ),
              )
            : SizedBox(height: 20),
      ],
    );
  }

  Widget gameCard() {
    return Container(
      height: Get.height * .2,
      width: Get.width,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor),
        color: AppColors.playerCardBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Players", style: Get.textTheme.headlineSmall),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              playerCard("Courtney Henry", true),
              playerCard("Devon Lane", true),
              Container(
                height: Get.height * .09,
                width: 2,
                color: AppColors.greyColor,
              ),
              playerCard("Devon Lane", false),
              playerCard("Devon Lane", false),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Team A"), Text("Team B")],
          ),
        ],
      ).paddingOnly(left: 15, right: 15, top: 15),
    );
  }
}
