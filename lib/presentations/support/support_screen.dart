import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';

import '../../configs/app_colors.dart';
import '../../configs/components/app_bar.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppBar(
        showLeading: true,
        centerTitle: true,
        title: Text(
          " Help & Support",
          style: Theme.of(context).textTheme.titleMedium,
        ).paddingOnly(left: Get.width * 0.02),

        context: context,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(Icons.email_outlined, color: AppColors.labelBlackColor),
              Text(
                "Email",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(left: 10),
            ],
          ),
          Row(
            children: [
              Icon(
                CupertinoIcons.phone,
                // Example of a Cupertino-style caption/chat icon
                color: AppColors.labelBlackColor,
              ),
              Text(
                "Phone Number",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.labelBlackColor,
                ),
              ).paddingOnly(left: 10),
            ],
          ).paddingOnly(top: 20),
          GestureDetector(onTap: (){Get.toNamed(RoutesName.chat);},
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  Icon(Icons.chat, color: AppColors.primaryColor),
                  Text(
                    "Chat",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ).paddingOnly(left: 10),
                ],
              ).paddingOnly(top: 20),
            ),
          ),
        ],
      ).paddingOnly(left: Get.width * .09, right: Get.width * .07, top: 20),
    );
  }
}
