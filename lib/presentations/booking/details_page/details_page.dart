import 'package:flutter/cupertino.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

class DetailsPage extends GetView<DetailsPageController> {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomButton(),
      appBar: primaryAppBar(
        title: Text("Details"),
        context: context,
        centerTitle: true,
        action: [
          appBarAction(
            Colors.white,
            Icon(Icons.share_outlined, color: Colors.black, size: 18),
          ),
          SizedBox(width: Get.width * .04),
          appBarAction(
            AppColors.primaryColor,
            Icon(Icons.message_outlined, color: Colors.white, size: 18),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Get.height * .16,
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
                    title: Text("PADEL", style: Get.textTheme.headlineSmall),
                    subtitle: Text(
                      "21 June | 9:00am - 10:00am",
                      style: Get.textTheme.labelLarge!.copyWith(
                        color: AppColors.darkGreyColor,
                      ),
                    ),
                  ),
               Center(child: Container(height: 1,width: Get.width*.88,color: AppColors.greyColor,)),
                  Flexible(
                      child: Transform.translate(
                        offset: Offset(0,-Get.height*.008),
                        child: Row(
                          children: [
                            Expanded(child: gameDetails("Gender", "All Players")),
                            Expanded(child: gameDetails("Game Level", "B/C")),
                            Expanded(child: gameDetails("Price", "₹2000")),
                          ],
        
                                          ),
                      ),
                  ),
                ],
              ),
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
              // height: Get.height * .16,
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColors.playerCardBackgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.greyColor),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: Get.height * .12,
                    width: Get.width * .3,
        
                    decoration: BoxDecoration(
                      color: AppColors.playerCardBackgroundColor,
                      border: Border.all(color: AppColors.greyColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(Assets.imagesImgDummy2,fit: BoxFit.cover,)),
                  ),
                  SizedBox(
                    width: Get.width*.51,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("The Good Club", style: Get.textTheme.bodySmall),
                            SvgPicture.asset(Assets.imagesDirections,),
        
                          ],
                        ),
                        Text(
                          "Sukhna Enclave, behind Rock Garden, Kaimbwala, Kansal, Chandigarh 160001",
                          style: Get.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "More Info",
                          style: Get.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primaryColor, // Blue underline
        
                          ),
                        ),
                      ],
                    ).paddingOnly(right: 0),
                  ),
                ],
              ).paddingAll(15),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 8.0),
            //   child: Text("Information",style: Get.textTheme.titleSmall,),
            // ),
            // // ListTile(
            // //   leading: SvgPicture.asset(Assets.imagesCourt),
            // //   title: Text('Type of Court ( 2 court)',style: Get.textTheme.bodySmall,),
            // //   subtitle:   Text('Outdoor, crystal, Double',style: Get.textTheme.headlineSmall,),
            // // ),
            // Row(
            //   children: [
            //     SvgPicture.asset(Assets.imagesCourt),
            //     const SizedBox(width: 10), // space between image and text
            //     Expanded(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(
            //             'Type of Court (2 court)',
            //             style: Get.textTheme.bodySmall,
            //           ).paddingOnly(top: 5),
            //           Text(
            //             'Outdoor, crystal, Double',
            //             style: Get.textTheme.headlineSmall,
            //           ),
            //         ],
            //       )
            //     ),
            //   ],
            // ).paddingOnly(top: Get.height*.01),
        
        
        
          ],
        ).paddingAll(16),
      ),
    );
  }

  Widget bottomButton(){
    return Container(
      height: Get.height * .14,
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
        child: CustomButton(
            width: Get.width*0.9,
            onTap: (){
              Get.toNamed(RoutesName.paymentMethod);
            },
            child: Row(
              children: [
                Text(
                  "₹ ",
                  style: Get.textTheme.titleMedium!.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Roboto"
                  ),
                ).paddingOnly(left: Get.width*.07),
                Text(
                  "2000",
                  style: Get.textTheme.titleMedium!.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ).paddingOnly(
                  right: Get.width * 0.29,
                ),
                Text(
                  "Book Now",
                  style: Get.textTheme.headlineMedium!
                      .copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
              ],
            )).paddingOnly(left: 20,right: 20),
      ),
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
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Get.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 10,
              color: AppColors.darkGrey
            ),
          ),
          SizedBox(height: Get.height * .01),
          Text(subtitle, style: Get.textTheme.headlineLarge),
        ],
      ),
    );
  }

  Widget playerCard(String name, bool showSubtitle,String image) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color:image.isNotEmpty?AppColors.whiteColor
            :AppColors.primaryColor),
          ),
          child: image.isNotEmpty
              ? ClipOval(

            child: Image.asset(image, fit: BoxFit.cover),
          )
              : Icon(CupertinoIcons.plus, color: AppColors.primaryColor),
        ),

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
      // height: Get.height * .22,
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
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              playerCard("Courtney", true,Assets.imagesImgCustomerPicBooking),
              playerCard("Courtney", true,Assets.imagesImgCustomerPicBooking),
              Container(
                height: Get.height * .09,
                width: 2,
                color: AppColors.greyColor,
              ),
              playerCard("Add me", false,''),
              playerCard("Add me", false,''),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Team A",style: Get.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),), Text("Team B",style: Get.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),)],
          ).paddingOnly(top: 10),
        ],
      ).paddingOnly(left: 15, right: 15, top: 10,bottom: 5),
    );
  }
}
