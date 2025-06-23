import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/primary_button.dart';
import 'package:padel_mobile/presentations/auth/booking/booking_controller.dart';

import '../../../../configs/components/app_bar.dart';
import '../../../../generated/assets.dart';

class AllSuggestions extends StatefulWidget {
  const AllSuggestions({super.key});

  @override
  State<AllSuggestions> createState() => _AllSuggestionsState();
}

class _AllSuggestionsState extends State<AllSuggestions> {
  @override
  Widget build(BuildContext context) {
    final List<String> slots = ['Morning', 'Afternoon', 'Evening'];
    return Scaffold(
      appBar: primaryAppBar(
        leading: BackButton(),
        title: Text("All Suggestions"),
        context: context,
      ),
      bottomNavigationBar: Container(
        height: Get.height * .12,
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
          child: Container(
            height: 55,
            width: Get.width * 0.9,
            decoration: BoxDecoration(
              color: Theme.of(Get.context!).primaryColor,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
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
              text: "Book the first spot",
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatefulBuilder(
                builder: (context, setState) {
                  String selectedSlot = 'Morning';
                  final List<String> slots = [
                    'Morning',
                    'Afternoon',
                    'Evening',
                  ];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Slot",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(width: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: slots.map((slot) {
                              final isSelected = selectedSlot == slot;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedSlot = slot;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.black
                                          : AppColors.playerCardBackgroundColor,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.grey.shade400,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      slot,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                    ],
                  );
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "For your level",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Icon(Icons.filter_list),
                ],
              ),
              SizedBox(height: Get.height * .03),

              ListView.builder(
                physics: ClampingScrollPhysics(),
                itemCount: 4,

                shrinkWrap: true,
                itemBuilder: (context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildMatchCard(context),
                  );
                },
              ),
            ],
          ).paddingOnly(bottom: 10),
        ),
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context) {
    return Container(
      height: Get.height * 0.25,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.playerCardBackgroundColor,
        border: Border.all(color: AppColors.greyColor),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "21 June | 9:00am",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            "The first player sets the match type",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPlayerSlot().paddingOnly(bottom: 6),

                      _buildPlayerSlot().paddingOnly(bottom: 6),
                      Container(width: 1, color: Colors.black),
                      _buildPlayerSlot().paddingOnly(bottom: 6),
                      _buildPlayerSlot().paddingOnly(bottom: 6),
                    ],
                  ),
                ),
              ),
              const Divider(thickness: 1, height: 0, color: Colors.black),
            ],
          ),

          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The Good Club',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(Assets.imagesLocation, height: 20),
                      Container(
                        width: Get.width * .55,
                        child: Text(
                          'Sukhna chandigarh 160001',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,

                    width: Get.width * .15,
                    child: Text(
                      '2000',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ).paddingOnly(right: Get.width * .04),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerSlot() {
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.whiteColor,
            border: Border.all(color: AppColors.primaryColor),
          ),
          child: Icon(CupertinoIcons.add, color: AppColors.primaryColor),
        ),
        const SizedBox(height: 7),
        Text(
          "Available",
          style: Get.textTheme.bodySmall!.copyWith(
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
