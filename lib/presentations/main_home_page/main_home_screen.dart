import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/app_strings.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/generated/assets.dart';
import 'package:padel_mobile/presentations/drawer/zoom_drawer_controller.dart';
import 'package:padel_mobile/presentations/main_home_page/main_home_controller.dart';
import 'package:padel_mobile/presentations/notification/notification_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
class MainHomeScreen extends StatelessWidget {
  final MainHomeController controller = Get.put(MainHomeController());
   MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: primaryAppBar(
        toolbarHeight: 70,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backGroundColor: AppColors.primaryColor,
        showLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
          color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
        title: Row(
          children: [
            // Drawer menu icon
            IconButton(
              icon: Icon(Icons.menu,color: Colors.white,size: 26,),
              onPressed: () {
                final drawerController = Get.find<CustomZoomDrawerController>();
                drawerController.toggleDrawer();
              },
            ),


            // Space between icon and title
            const SizedBox(width: 0),

            // Existing title widget
            Expanded(child: _buildAppBarTitle(context)),
          ],
        ),
        action: [
          GestureDetector(
            onTap: () {
              Get.toNamed(RoutesName.notification);
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: AppColors.whiteColor,
                    size: 25,
                  ),
                ),
                Positioned(
                  top: -2,
                  right: -2,
                  child: Obx(() {
                    final count = Get.find<NotificationController>().unreadNotificationCount.value;
                    if (count == 0) return const SizedBox.shrink();

                    return Container(
                      height: 16,
                      width: 16,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        count > 99 ? '99+' : '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ).paddingOnly(right: 5),
        ],
        context: context,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _banner(),
            const SizedBox(height: 20),
            _quickActions(),
            const SizedBox(height: 15),
            _sectionTitle("Courts Near you",(){Get.toNamed(RoutesName.home);}),
            _courtCard(),
            const SizedBox(height: 15),
            _sectionTitle("Top players near you",(){}),
            _players(),
            // const SizedBox(height: 24),
            // _sectionTitle("Upcoming Tournaments"),
            // _tournamentCard(),
          ],
        ),
      ),
    );
  }
  Widget _buildAppBarTitle(BuildContext context) {
    return Obx(() {
      final profile = controller.profileController.profileModel.value;
      if (controller.profileController.isLoading.value) {
        return Container(
          width: 120,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.textFieldColor.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }

      final name = profile?.response?.name?.capitalizeFirst??"";
      final displayName =
      (name.trim().isEmpty) ? 'Guest' : name;
      final location = profile?.response?.city??"";

      return SizedBox(
        width: Get.width * 0.34,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: AppStrings.hello,
                    style: Get
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 15),
                  ),
                  TextSpan(
                    text: displayName,
                    style: Get
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700,color: Colors.white,fontSize: 15),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(-3, 0),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.green, size: 14),
                  Text(location,
                    style: Get
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.w500,color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).paddingOnly(left: 5);
    });
  }


  /// BANNER
  Widget _banner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 150,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage(Assets.imagesImgBookNow),
            fit: BoxFit.cover,
            alignment: Alignment(0, -0.3),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.1), // light top
                Colors.black.withValues(alpha: 0.4), // mid
                Colors.black.withValues(alpha: 0.65), // dark bottom
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Discover, Book\nand Play",
                style: Get.textTheme.titleMedium!
                    .copyWith(color: Colors.white),
              ),
              const Spacer(),
              Container(
                width: Get.width * 0.4,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "BOOK NOW!",
                      style: Get.textTheme.titleSmall!
                          .copyWith(fontSize: 15),
                    ).paddingOnly(left: 10),
                    CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      child: const Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// QUICK ACTIONS
  Widget _quickActions() {
    final items = [
      {"icon": Icons.sports_tennis, "title": "Book a Court"},
      {"icon": Icons.groups, "title": "Open Match"},
      {"icon": Icons.emoji_events, "title": "Americano"},
      {"icon": Icons.sports, "title": "Challenge"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items
          .map(
            (e) => Column(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.primaryColor,
              ),
              child: Icon(e["icon"] as IconData,
                  color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(e["title"] as String,style: Get.textTheme.labelSmall!.copyWith(fontSize: 12),),
          ],
        ),
      )
          .toList(),
    );
  }

  /// SECTION TITLE
  Widget _sectionTitle(String title,VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(title,
              style:
              Get.textTheme.headlineMedium),
          const Spacer(),
          GestureDetector(
            onTap: onTap,
            child: Container(
              color: Colors.transparent,
              child: Text("See all",
                  style: Get.textTheme.labelLarge!.copyWith(color: AppColors.primaryColor)),
            ),
          ),
        ],
      ),
    );
  }

  /// COURT CARD
  Widget _courtCard() {
    final courts = List.generate(5, (i) => {
      "name": "Padel Haus",
      "location": "Chandigarh",
      "rating": "4.9",
      "price": "₹ 2000",
      "image": Assets.imagesImgBookNow, // replace with network if needed
    });

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: CarouselSlider.builder(
        itemCount: courts.length,
        itemBuilder: (context, index, realIndex) {
          final court = courts[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Stack(
                children: [
                  /// IMAGE
                  Positioned.fill(
                    child: Image.asset(
                      court["image"]!,
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// BLACK GRADIENT
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.15),
                            Colors.black.withOpacity(0.35),
                            Colors.black.withOpacity(0.75),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// CONTENT
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          court["name"]!,
                          style: Get.textTheme.titleMedium!
                              .copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),

                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.green, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              court["location"]!,
                              style: Get.textTheme.bodySmall!
                                  .copyWith(color: Colors.white70),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "4 Courts | Free parking | Shed",
                          style: Get.textTheme.bodySmall!
                              .copyWith(color: Colors.white70),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.green, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  court["rating"]!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              court["price"]!,
                              style: Get.textTheme.titleMedium!
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 260,
          viewportFraction: 0.78, // 👈 overlap effect
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          enableInfiniteScroll: true,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
        ),
      ),
    );
  }


  /// PLAYERS
  Widget _players() {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) => Container(
          width: 120,
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.4),
                spreadRadius: 1.5,
                blurRadius: 5.0
              )
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.secondaryColor,
                child: CachedNetworkImage(
                  imageUrl: "https://picsum.photos/100/100?random=$i",
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: 24,
                    backgroundImage: imageProvider,
                  ),
                  placeholder: (context, url) => CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.secondaryColor,
                  ),
                  errorWidget: (context, url, error) => CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.secondaryColor,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, -5),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.secondaryColor
                  ),
                  child: Text("1000 XP",
                      style: Get.textTheme.labelMedium!.copyWith(color: Colors.white)),
                ),
              ),
              Text("Vaibhav Kumar",
                  style: Get.textTheme.labelLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("100 XP",style: Get.textTheme.labelMedium,),
                  Text("100 XP",style: Get.textTheme.labelMedium,),
                ],
              ),Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("100 XP",style: Get.textTheme.labelMedium,),
                  Text("100 XP",style: Get.textTheme.labelMedium,),
                ],
              )
            ],
          ),
        ).paddingOnly(top: 10,bottom: 10),
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemCount: 5,
      ),
    );
  }

  /// TOURNAMENT CARD
  Widget _tournamentCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF4FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Friday 21 June | 9:00 AM - 10:00 AM",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text("Professional | Mixed"),
            SizedBox(height: 12),
            Text("The Good Club"),
            SizedBox(height: 8),
            Text("₹ 2000",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
