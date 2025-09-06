import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/components/app_bar.dart';
import '../../../configs/components/primary_button.dart';
import '../../../configs/routes/routes_name.dart';
import '../../../generated/assets.dart';
import 'details_page_controller.dart';
class DetailsScreen extends GetView<DetailsController> {
   DetailsController controller=Get.put(DetailsController());


    DetailsScreen({super.key});


  @override
  Widget build(BuildContext context) {
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
              Icon(Icons.share_outlined, color: Colors.black, size: 18),
            ),
            SizedBox(width: Get.width * .04),
            PopupMenuButton<String>(
              offset:Offset(0,Get.height * .05),
              color: Colors.white,
              onSelected: (value) {
                switch (value) {
                  case 'share':
                  // handle share
                    break;
                  case 'refresh':
                  // handle refresh
                    break;
                  case 'settings':
                  // open settings
                    break;
                  case 'logout':
                  // handle logout
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'refresh',
                  child: Row(
                    children: [
                      Icon(Icons.refresh, size: 18, color: Colors.black54),
                      SizedBox(width: 8),
                      Text("Refresh"),
                    ],
                  ),
                ),
                PopupMenuItem(
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
                AppColors.whiteColor,Icon(Icons.more_vert,color: AppColors.blackColor,)

              ),
            )

          ],
        ),
        body: SingleChildScrollView(
          physics:ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // height: Get.height * .16,
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.whiteColor,
                  border: Border.all(color: AppColors.blackColor.withAlpha(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      // leading: SvgPicture.asset(Assets.imagesIcPadelIcon),
                      title: Text(controller.data!.data!.clubName.toString()??"", style: Get.textTheme.headlineLarge!.copyWith(fontSize: 15,fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        "21 June | 9:00am - 10:00am",
                        style: Get.textTheme.displaySmall!.copyWith(fontSize: 11,
                          color: AppColors.darkGreyColor,
                        ),
                      ),
                    ),
                    Center(child: Container(height: 1,width: Get.width*.88,color: AppColors.blackColor.withAlpha(30),)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        gameDetails("Gender", "All Players",AppColors.blackColor,13,),
                        gameDetails("Game Level", "B/C",AppColors.blackColor,13),
                        gameDetails("Price", "₹2000",AppColors.primaryColor,16),
                      ],

                    ).paddingOnly(top: Get.height*0.01,bottom: Get.height*0.01),
                  ],
                ),
              ).paddingOnly(top: Get.height*0.03),
              Container(
                height: Get.height * .045,
                width: Get.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Color(0xFFf4f6fc),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.blackColor.withAlpha(10)),
                ),
                child: Text("Open match",style: Get.textTheme.bodyLarge,).paddingOnly(left: 14),
              ).paddingOnly(top:  Get.height * .015,bottom: Get.height * .015),
              gameCard(),
              SizedBox(height: Get.height * .015),
              Container(
                // height: Get.height * .16,
                width: Get.width,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withAlpha(10),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.blackColor.withAlpha(10)),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: Get.height * .1,
                      width: Get.width * .3,

                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withAlpha(10),
                        border: Border.all(color: AppColors.blackColor.withAlpha(10)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(Assets.imagesImgDummy2,fit: BoxFit.cover,)),
                    ),
                    Container(
                      color: Color(0xFFf4f6fc),
                      width: Get.width*.51,
                      height: Get.height * .1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("The Good Club", style: Get.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w500)),
                              Icon(Icons.directions,color: AppColors.secondaryColor,)
                            ],
                          ).paddingOnly(bottom: 5),
                          Text(
                            overflow: TextOverflow.ellipsis,
                            "Sukhna Enclave, behind Rock Garden, Kaimbwala, Kansal, Chandigarh 160001",
                            style: Get.textTheme.displaySmall!.copyWith(
                                fontWeight: FontWeight.w400,fontSize: 11
                            ),
                          ).paddingOnly(bottom: 10),
                          Text(
                            "More Info",
                            style: Get.textTheme.headlineLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primaryColor, // Blue underline

                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).paddingAll(15),
              ),
              information()
            ],
          ).paddingAll(16),
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

  Widget gameDetails(String title, String subtitle,Color color,double fontSize) {
    return Container(
      alignment: Alignment.center,
      // height: Get.height * .1,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Get.textTheme.bodyLarge,
          ),
          SizedBox(height: Get.height * .01),
          Text(subtitle, style: Get.textTheme.headlineMedium!.copyWith(color: color,fontWeight: FontWeight.w600,fontSize:fontSize )),
        ],
      ),
    );
  }

  Widget playerCard(String name, bool showSubtitle, String image) {
    return GestureDetector(
      onTap: () {
      //   if (name == "Add Me") {
      //     // Navigate to HomePage
      //     Get.offAllNamed(RoutesName.openMatch);
      //     // or Get.toNamed(RoutesName.home) if you want back navigation
      //   } else if (buttonType == "upcoming") {
      //     // Add other logic for upcoming matches if needed
      //     // Get.toNamed(RoutesName.openMatchesManualBooking);
      //   }
      },
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: image.isNotEmpty
                    ? AppColors.whiteColor
                    : AppColors.primaryColor,
              ),
            ),
            child: image.isEmpty
                ? const Icon(CupertinoIcons.add,
                size: 20, color: AppColors.primaryColor)
                : ClipOval(
              child: image.startsWith('http')
                  ? Image.network(
                image,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              )
                  : Image.asset(
                image,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: Get.textTheme.bodyLarge!
                .copyWith(fontWeight: FontWeight.w500),
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
              style: Get.textTheme.bodyLarge!
                  .copyWith(color: Colors.green),
            ),
          )
              : const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget gameCard() {
    return Container(
      height: Get.height * .19,
      width: Get.width,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.blackColor.withAlpha(10)),
        color: Color(0xFFf4f6fc),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Players", style: Get.textTheme.headlineLarge!.copyWith(color: AppColors.blackColor)),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                playerCard("Courtney",  false,getRandomImage()),
                playerCard("Courtney",   false,getRandomImage()),
                Container(
                  height: Get.height * .1,
                  width: 1,
                  color: AppColors.blackColor.withAlpha(30),
                ),
                playerCard( "Add Me",  false, getRandomImage()),
                playerCard("Add Me",   false,getRandomImage() ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("A",style: Get.textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w600),), Text("B",style: Get.textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w600),)],
            ).paddingOnly(top: 10),
          ],
        ).paddingOnly(left: 15, right: 15, top: 10,bottom: 5),
      ),
    );
  }
  String getRandomImage() {
    final randomId = DateTime.now().microsecondsSinceEpoch.remainder(1000);
    return "https://randomuser.me/api/portraits/men/${randomId % 90}.jpg";
  }

  Widget information(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Information", style: Get.textTheme.headlineLarge!.copyWith(fontSize: 15,fontWeight: FontWeight.w600)),
        ListTile(
          // leading: SvgPicture.asset(Assets.imagesIcMyClub,color: AppColors.textColor,),
          title: Text("Type of Court ( 2 court)",style: Get.textTheme.bodyLarge,),
          subtitle: Text("Outdoor, crystal, Double",style: Get.textTheme.headlineLarge,),
        ),
        ListTile(
          leading: Icon(Icons.calendar_month_outlined,color: AppColors.textColor,),
          title: Text("End registration",style: Get.textTheme.bodyLarge,),
          subtitle: Text("Today at 10:00 PM",style: Get.textTheme.headlineLarge,),
        ),
      ],
    ).paddingOnly(top: Get.height*0.01);
  }
  Widget bottomBar(BuildContext context) {
    return Container(
      height: Get.height * .12,
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
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
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child:PrimaryButton(
            height: 50,
            onTap: () {
              // controller.showCancelMatchDialog(context);
            },
            text:"Book Now",
            // child: controller.isLoading.value
            //     ? AppLoader(size: 30, strokeWidth: 5)
            //     : null,
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
        // fit: StackFit.expand,
        children: [
          Container(
            height: 200,
            width: Get.width,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
            ),
            // child: Image.asset(Assets.imagesImgDummyClub,fit: BoxFit.cover,),
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

