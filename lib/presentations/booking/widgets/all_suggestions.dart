import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/primary_button.dart';
import 'package:padel_mobile/presentations/booking/widgets/details_page.dart';
import 'package:padel_mobile/presentations/booking/widgets/filters.dart';
import '../../../../configs/components/app_bar.dart';
import '../../../../generated/assets.dart';
import '../../../configs/components/custom_button.dart';

class AllSuggestions extends StatefulWidget {
  const AllSuggestions({super.key});

  @override
  State<AllSuggestions> createState() => _AllSuggestionsState();
}

class _AllSuggestionsState extends State<AllSuggestions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppBar(
        centerTitle: true,
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
          child: CustomButton(
              width: Get.width*0.9,
              child: Text(
                "+ Start a match",
                style: Theme.of(context).textTheme.headlineMedium!
                    .copyWith(
                  color: AppColors.whiteColor,
                ),
              ).paddingOnly(right: Get.width*0.14),
              onTap: (){}),
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
                            "Slots",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(width: 10),
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
                      const SizedBox(height: 5),
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
                  InkWell(
                    onTap: () => Get.to(Filters()),
                    child: Image.asset(
                      Assets.imagesIcFilter,
                      height: 40,
                      width: 20,
                    ),
                  ),
                ],
              ),

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
    return InkWell(
      onTap: ()=>
        Get.to(DetailsPage()),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.playerCardBackgroundColor,
          border: Border.all(color: AppColors.greyColor),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
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
              ],
            ).paddingOnly(top: 15, bottom: 10, right: 15, left: 15),
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
                        _buildPlayerSlot(
                          imageUrl: Assets.imagesImgCustomerPicBooking,
                          name: 'Courtney Henry',
                        ).paddingOnly(bottom: 6),
                        _buildPlayerSlot(
                          imageUrl: Assets.imagesImgCustomerPicBooking,
                          name: 'Devon Lane',
                        ).paddingOnly(bottom: 6),
                        Container(width: 1, color: AppColors.greyColor),
                        _buildPlayerSlot(
                          imageUrl: '',
                          name: '',
                        ).paddingOnly(bottom: 6),
                        _buildPlayerSlot(
                          imageUrl: '',
                          name: '',
                        ).paddingOnly(bottom: 6),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(thickness: 1.5, height: 0, color: AppColors.greyColor),

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
                    SizedBox(
                       width: Get.width * .61,
                      child: Text(
                        'Sukhna Enclave, behind Rock Garden, Kaimbwala, Kansal, Chandigarh 160001',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                       width: Get.width * .16,
                      child: Text(
                        '₹2000',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.primaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ).paddingOnly(right: Get.width * .04),
                  ],
                ),
              ],
            ).paddingOnly(top: 5, bottom: 15, right: 0, left: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerSlot({required String imageUrl, required String name}) {
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
          child: imageUrl.isEmpty
              ? Icon(CupertinoIcons.add, color: AppColors.primaryColor)
              : ClipOval(
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 50, // match container size
                    height: 50,
                  ),
                ),
        ),
        const SizedBox(height: 7),
        Text(
          name.isNotEmpty ? name : 'Available',
          style: Get.textTheme.bodySmall!.copyWith(
            color: name.isNotEmpty
                ? AppColors.darkGreyColor
                : AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
