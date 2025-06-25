import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:padel_mobile/configs/components/primary_button.dart';
import 'package:padel_mobile/configs/components/search_field.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/generated/assets.dart';
import 'package:padel_mobile/presentations/home/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: primaryAppBar(
          showLeading: false,
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Hello!\n",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: "Jane Cooper",
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ).paddingOnly(left: Get.width * 0.02),
          action: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    blurRadius: 1.4,
                    spreadRadius: 2.2,
                  ),
                ],
              ),
              child: Icon(Icons.notifications_none_rounded),
            ).paddingOnly(right: Get.width * 0.02),
          ],
          context: context,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchField(),
            clubTicketList(context),
            Text(
              "New Booking",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
            ).paddingOnly(bottom: Get.width * 0.02, left: Get.width * 0.05),
            locationAndDateTime(context),
            addToCart(context),
          ],
        ).paddingOnly(),
      ),
    );
  }

  Widget searchField() {
    return SearchField(
      suffixIcon: Icon(CupertinoIcons.search, color: AppColors.textColor),
      hintText: "Search",
      onChanged: (v) {},
    ).paddingOnly(
      top: Get.height * 0.01,
      bottom: Get.height * 0.02,
      left: Get.width * 0.05,
      right: Get.width * 0.05,
    );
  }

  Widget clubTicketList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Booking",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
        ).paddingOnly(bottom: Get.width * 0.02),
        SizedBox(
          height: 100,
          child: ListView.builder(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                height: 95,
                width: 193,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.lightBlueColor),
                ),
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 34,
                          width: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.greyColor),
                            image: DecorationImage(
                              image: AssetImage(Assets.imagesImgHomeLogo),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "The Good Club",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined, size: 13),
                                Text(
                                  "Chandigarh 160001",
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: AppColors.secondaryColor,
                                  size: 15,
                                ),
                                Text(
                                  "4.9",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.directions,
                              color: AppColors.secondaryColor,
                              size: 13,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "29/06/2025",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "8:00am-10:00am",
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor,
                                  ),
                            ),
                            Text(
                              "( 60mins )",
                              style: Theme.of(context).textTheme.labelSmall!
                                  .copyWith(color: AppColors.labelBlackColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ).paddingOnly(right: 10);
            },
          ),
        ),
      ],
    ).paddingOnly(left: Get.width * 0.05, bottom: Get.height * 0.02);
  }

  Widget locationAndDateTime(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            final RxString searchQuery = ''.obs;
            final scrollController = ScrollController();
            final searchController = TextEditingController();

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: Get.height * 0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 40,
                              height: 2,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Select Locations",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: searchController,
                              onChanged: (value) => searchQuery.value = value,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Search location...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Divider(thickness: 1, color: Colors.grey[300]),
                            Obx(() {
                              final filteredList = controller.dummyLocations
                                  .where((loc) => loc.toLowerCase().contains(searchQuery.value.toLowerCase()))
                                  .toList();

                              if (filteredList.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.only(top: 20, bottom: 40),
                                  child: Center(child: Text("No locations found")),
                                );
                              }

                              return Flexible(
                                child: Scrollbar(
                                  controller: scrollController,
                                  thumbVisibility: true,
                                  radius: const Radius.circular(10),
                                  child: ListView.builder(
                                    controller: scrollController,
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final location = filteredList[index];
                                      return Obx(() {
                                        final isSelected = controller.selectedLocations.contains(location);
                                        return CheckboxListTile(
                                          dense: true,
                                          title: Text(location,style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w500),),
                                          value: isSelected,
                                          onChanged: (value) {
                                            if (value == true) {
                                              controller.selectedLocations.add(location);
                                            } else {
                                              controller.selectedLocations.remove(location);
                                            }
                                          },
                                          controlAffinity: ListTileControlAffinity.leading,
                                          activeColor: AppColors.primaryColor,
                                        );
                                      });
                                    },
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                log("Selected Locations: ${controller.selectedLocations.join(', ')}");
                              },
                              child: const Text("Done"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Container(
            height: 30,
            width: Get.width * 0.62,
            decoration: BoxDecoration(
              color: AppColors.textFieldColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.03,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Container(
                  width: Get.width*0.45,
                  color: Colors.transparent,
                  child: Text(
                    controller.selectedLocations.isEmpty
                        ? "Location"
                        : controller.selectedLocations.join(", "),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: AppColors.textColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: AppColors.textColor,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.selectDate(context);
          },
          child: Container(
            height: 30,
            width: Get.width * 0.25,
            decoration: BoxDecoration(
              color: AppColors.textFieldColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.03,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                      () => Text(
                    controller.selectedDate.value != null
                        ? DateFormat('dd/MM/yyyy').format(controller.selectedDate.value)
                        : 'Date / Time',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_month_outlined,
                  size: 20,
                  color: AppColors.textColor,
                ),
              ],
            ),
          ),
        ),

      ],
    ).paddingOnly(
      left: Get.width * 0.05,
      right: Get.width * 0.05,
      bottom: Get.height * 0.02,
    );
  }

  Widget addToCart(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        radius: Radius.circular(10),
        thickness: 8,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Get.toNamed(RoutesName.booking);
                FocusManager.instance.primaryFocus!.unfocus();
              },
              child: Container(
                height: Get.height * 0.13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.lightBlueColor),
                ),
                padding: EdgeInsets.all(10),
                // color: Colors.red,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 95,
                          width: 113,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(Assets.imagesImgCart),
                            ),
                          ),
                        ).paddingOnly(right: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Padel Haus",
                                  style: Theme.of(context).textTheme.headlineSmall!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined, size: 13),
                                    Text(
                                      "Chandigarh 160001",
                                      style: Theme.of(context).textTheme.bodyLarge!
                                          .copyWith(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Text(
                                  "4 Courts | Free parking | Shed",
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(color: AppColors.labelBlackColor),
                                ),
                              ],
                            ),
                            PrimaryButton(
                              height: 25,
                              textStyle: Theme.of(context).textTheme.displayLarge!.copyWith(color: AppColors.whiteColor,fontSize: 7),
                              width: Get.width * 0.2,
                              onTap: () {
                                Get.toNamed(RoutesName.booking);
                                FocusManager.instance.primaryFocus!.unfocus();
                              },
                              text: "Add to Cart",
                            ).paddingOnly(bottom: 5),
                          ],
                        ),
                      ],
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Row(
                            //   children: [
                            //     Image.asset(
                            //       Assets.imagesIcLocation,
                            //       color: AppColors.primaryColor,
                            //       scale: 4,
                            //     ) ,                               Text(
                            //       "Chandigarh 160001",),
                            //     Icon(
                            //       Icons.star,
                            //       color: AppColors.secondaryColor,
                            //       size: 15,
                            //     ),
                            //     Text(
                            //       "4.9",
                            //       style: Theme.of(context).textTheme.bodyLarge!
                            //           .copyWith(fontWeight: FontWeight.w500),
                            //     ),
                            //   ],
                            // ),
                            // Icon(
                            //   Icons.directions,
                            //   color: AppColors.secondaryColor,
                            //   size: 13,
                            // ),
                            Row(
                              children: [

                                Icon(
                                  Icons.star,
                                  color: AppColors.secondaryColor,
                                  size: 15,
                                ),
                                Text(
                                  "4.9",
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.directions,
                              color: AppColors.secondaryColor,
                              size: 13,
                            ),
                          ],
                        ),
                        Text(
                          "₹ 1200",
                          style: Theme.of(context).textTheme.headlineLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        ).paddingOnly(bottom: 5),
                      ],
                    ),
                  ],
                ),
              ).paddingOnly(
                left: Get.width * 0.05,
                right: Get.width * 0.05,
                bottom: 8,
              ),
            );
          },
        ),
      ),
    );
  }
}

//
