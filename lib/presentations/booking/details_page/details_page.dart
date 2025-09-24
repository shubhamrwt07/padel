import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/presentations/booking/details_page/details_model.dart';
import 'package:padel_mobile/presentations/booking/open_matches/addPlayer/add_player_screen.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/components/app_bar.dart';
import '../../../configs/components/primary_button.dart';
import '../../../configs/routes/routes_name.dart';
import '../../../generated/assets.dart';
import 'details_page_controller.dart';

class DetailsScreen extends GetView<DetailsController> {
  final DetailsController controller = Get.put(DetailsController());

  DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = controller.localMatchData;

    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: primaryAppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextColor: AppColors.whiteColor,
          leadingButtonColor: AppColors.whiteColor,
          title: Text("Details"),
          context: context,
          centerTitle: true,
          action: [
            appBarAction(
              Colors.white,
              const Icon(Icons.share_outlined, color: Colors.black, size: 18),
            ),
            SizedBox(width: Get.width * .04),
            PopupMenuButton<String>(
              offset: Offset(0, Get.height * .05),
              color: Colors.white,
              onSelected: (value) {
                switch (value) {
                  case 'share':
                    break;
                  case 'refresh':
                    break;
                  case 'settings':
                    break;
                  case 'logout':
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'refresh',
                  child: Row(
                    children: [
                      Icon(Icons.refresh, size: 18, color: Colors.black54),
                      SizedBox(width: 8),
                      Text("Refresh"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings, size: 18, color: Colors.black54),
                      SizedBox(width: 8),
                      Text("Settings"),
                    ],
                  ),
                ),
              ],
              child: appBarAction(
                AppColors.whiteColor,
                Icon(Icons.more_vert, color: AppColors.blackColor),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child:




              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // club + date card
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.whiteColor,
                    border: Border.all(
                      color: AppColors.blackColor.withAlpha(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          data['clubName'] ?? "Unknown club",
                          style: Get.textTheme.headlineLarge?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ) ??
                              const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        subtitle: Text(
                          "${data['matchDate'] ?? ""} | ${data['matchTime']?? ""}",
                          style: Get.textTheme.displaySmall?.copyWith(
                            fontSize: 11,
                            color: AppColors.darkGreyColor,
                          ) ??
                              const TextStyle(fontSize: 11),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 1,
                          width: Get.width * .88,
                          color: AppColors.blackColor.withAlpha(30),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          gameDetails(
                            "Gender",
                            "${data['gender']}",
                            AppColors.blackColor,
                            13,
                          ),
                          gameDetails(
                            "Game Level",
                            data['skillLevel'] ?? "-",
                            AppColors.blackColor,
                            13,
                          ),
                          gameDetails(
                            "Price",
                            data['price'],
                            AppColors.primaryColor,
                            16,
                          ),
                        ],
                      ).paddingOnly(
                        top: Get.height * 0.01,
                        bottom: Get.height * 0.01,
                      ),
                    ],
                  ),
                ).paddingOnly(top: Get.height * 0.03),

                // match type
                Container(
                  height: Get.height * .045,
                  width: Get.width,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: const Color(0xFFf4f6fc),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.blackColor.withAlpha(10),
                    ),
                  ),
                  child: Text(
                    "Open match",
                    style: Get.textTheme.bodyLarge,
                  ).paddingOnly(left: 14),
                ).paddingOnly(
                  top: Get.height * .015,
                  bottom: Get.height * .015,
                ),

                // game card
                 gameCard(
                      teamA: controller.teamA ?? [],
                      teamB: controller.teamB??[],
                    ),


                SizedBox(height: Get.height * .015),

                // club info card
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withAlpha(10),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.blackColor.withAlpha(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: Get.height * .1,
                        width: Get.width * .3,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withAlpha(10),
                          border: Border.all(
                            color: AppColors.blackColor.withAlpha(10),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            Assets.imagesImgDummy2,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        color: const Color(0xFFf4f6fc),
                        width: Get.width * .51,
                        height: Get.height * .1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data['clubName'] ?? "",
                                  style:
                                  Get.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ) ??
                                      const TextStyle(
                                          fontWeight: FontWeight.w500),
                                ),
                                Icon(
                                  Icons.directions,
                                  color: AppColors.secondaryColor,
                                ),
                              ],
                            ).paddingOnly(bottom: 5),
                            Text(
                              data['address'] ??
                                  "Unknown address, please update",
                              overflow: TextOverflow.ellipsis,
                              style: Get.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                              ) ??
                                  const TextStyle(fontSize: 11),
                            ).paddingOnly(bottom: 10),
                            Text(
                              "More Info",
                              style: Get.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primaryColor,
                              ) ??
                                  const TextStyle(
                                      fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).paddingAll(15),
                ),

                information(),
              ],
            ).paddingAll(16)

        ),
      ),
    );
  }

  Widget appBarAction(Color backgroundColor, Widget child) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 1),
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

  Widget gameDetails(
      String title, String subtitle, Color color, double fontSize) {
    return Container(
      alignment: Alignment.center,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: Get.textTheme.bodyLarge),
          SizedBox(height: Get.height * .01),
          Text(
            subtitle,
            style: Get.textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ) ??
                TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize,
                ),
          ),
        ],
      ),
    );
  }

  Widget playerCard(String name, bool showSubtitle, String image) {
    log("IMage ${image}");
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color:
                image.isNotEmpty ? AppColors.whiteColor : AppColors.primaryColor,
              ),
            ),
            child: image.isEmpty
                ? const Icon(
              CupertinoIcons.profile_circled,
              size: 20,
              color: AppColors.primaryColor,
            )
                : ClipOval(
              child: Image.network(image,fit: BoxFit.cover,)
            ),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: Get.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ) ??
                const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 0),
          showSubtitle
              ? Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            height: 16,
            width: 30,
            child: Text(
              "B/C",
              style: Get.textTheme.bodyLarge?.copyWith(
                color: Colors.green,
              ) ??
                  const TextStyle(color: Colors.green),
            ),
          )
              : const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget gameCard({required List  teamA, required List  teamB}) {
    return Container(
      height: Get.height * .20,
      width: Get.width,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.blackColor.withAlpha(10)),
        color: const Color(0xFFf4f6fc),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Players",
              style: Get.textTheme.headlineLarge?.copyWith(
                color: AppColors.blackColor,
              ) ??
                  const TextStyle(color: AppColors.blackColor),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Team A Players
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 2, // Maximum 2 players per team
                      itemBuilder: (BuildContext context, int index) {
                        // Check if player exists at this index
                        bool hasPlayer = index < teamA.length &&
                            teamA[index].isNotEmpty &&
                            teamA[index]['name'] != null &&
                            teamA[index]['name'].toString().isNotEmpty;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: hasPlayer
                              ? playerCard(
                            teamA[index]['name'] ?? "Unknown",
                            true, // isPlayer = true
                            teamA[index]['image']??"" ,

                          )
                              :GestureDetector(
                            onTap: (){
                              controller.showDailogue(context,index: index,team: "teamA");
                            },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white
                                      ),
                                               height: 50,
                                                         width: 50,
                                                         child: Icon(CupertinoIcons.add),
                                                              ),
                                    Text("Available")
                                  ],
                                ),
                              )
                        );
                      },
                    ),
                  ),
                ),

                // Divider
                Container(
                  height: Get.height * .1,
                  width: 1,
                  color: AppColors.blackColor.withAlpha(30),
                ),

                // Team B Players
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 2, // Maximum 2 players per team
                      itemBuilder: (BuildContext context, int index) {
                        // Check if player exists at this index
                        bool hasPlayer = index < teamB.length &&
                            teamB[index].isNotEmpty &&
                            teamB[index]['name'] != null &&
                            teamB[index]['name'].toString().isNotEmpty;

                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: hasPlayer
                              ? playerCard(
                            teamB[index]['name'] ?? "Unknown",
                            true, // isPlayer = true
                            teamB[index]['image'] ?? "assets/images/default_avatar.svg",

                          )
                              : GestureDetector(
                            onTap: (){
                              controller.showDailogue(context,index: index,team: "teamB");
                            },
                                child: Column(
                                                            children: [
                                Container(

                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white
                                  ),
                                  child: Icon(CupertinoIcons.add),
                                ),
                                Text("Available")
                                                            ],
                                                          ),
                              )
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Team A",
                  style: Get.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ) ??
                      const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  "Team B",
                  style: Get.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ) ??
                      const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ).paddingOnly(left: 15, right: 15, top: 10, bottom: 5),
      ),
    );
  }

  Widget information() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Information",
          style: Get.textTheme.headlineLarge?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ) ??
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        ListTile(
          title: Text("Type of Court ( 2 court )",
              style: Get.textTheme.bodyLarge),
          subtitle:
          Text("${controller.localMatchData['courtType']}", style: Get.textTheme.headlineLarge),
        ),
        ListTile(
          leading: Icon(Icons.calendar_month_outlined,
              color: AppColors.textColor),
          title: Text("End registration", style: Get.textTheme.bodyLarge),
          subtitle: Text("Today at 10:00 PM",
              style: Get.textTheme.headlineLarge),
        ),
      ],
    ).paddingOnly(top: Get.height * 0.01);
  }
  Widget bottomBar(BuildContext context) {
    return Container(
      height: Get.height * .12,
      padding: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Center(
        child: Container(
          height: 55,
          width: Get.width * 0.9,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: PrimaryButton(
            height: 50,
            onTap: () {},
            text: "Book Now",
          ),
        ).paddingOnly(bottom: Get.height * 0.03),
      ),
    );
  }
}

class BackgroundContainer extends StatelessWidget {
  final Widget child;

  const BackgroundContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: AppColors.whiteColor,
      child: Stack(
        children: [
          Container(
            height: 200,
            width: Get.width,
            decoration: const BoxDecoration(color: AppColors.primaryColor),
          ),
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(31, 65, 187, 0.4),
                  Color.fromRGBO(61, 190, 100, 0.4),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
