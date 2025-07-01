import 'package:flutter/cupertino.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

class AllSuggestions extends StatelessWidget {
  AllSuggestions({super.key});
  final AllSuggestionsController controller = Get.put(AllSuggestionsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppBar(
        centerTitle: true,

        title: const Text("All Suggestions"),
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
            width: Get.width * 0.9,
            child: Text(
              "+ Start a match",
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: AppColors.whiteColor,
                fontSize: 13,
                fontWeight: FontWeight.w600
              ),
            ).paddingOnly(right: Get.width * 0.14),
            onTap: () {
              Get.to(() => DetailsPage(), transition: Transition.rightToLeft);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSlotSelector(context),
            const SizedBox(height: 10),
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
            ).paddingOnly(left: Get.width*.03,right: Get.width*.03),
            ListView.builder(
              physics: const ClampingScrollPhysics(),
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
    );
  }

  Widget _buildSlotSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Slots", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 5),
        Obx(
              () => Row(
            children: controller.slots.map((slot) {
              final isSelected = controller.selectedSlot.value == slot;
              return Padding(
                padding: const EdgeInsets.all(.0),
                child: GestureDetector(
                  onTap: () => controller.selectSlot(slot),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.black
                          : AppColors.playerCardBackgroundColor,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey.shade400,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      slot,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ).paddingOnly(left: 10),
                ),
              );
            }).toList(),
          ).paddingOnly(top: 10),
        ),
      ],
    ).paddingOnly(left: Get.width*.03,right: Get.width*.03);
  }

  Widget _buildMatchCard(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(DetailsPage()),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.playerCardBackgroundColor,
          border: Border.all(color: AppColors.greyColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMatchHeader(context),
            const SizedBox(height: 12),
            _buildPlayerRow(),
            const Divider(thickness: 1.5, height: 0, color: AppColors.greyColor),
            const SizedBox(height: 10),
            _buildMatchFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 10, right: 15, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("21 June | 9:00am", style: Theme.of(context).textTheme.headlineSmall),
          Text("The first player sets the match type",
              style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }

  Widget _buildPlayerRow() {
    return Padding(
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
            _buildPlayerSlot(imageUrl: '', name: '').paddingOnly(bottom: 6),
            _buildPlayerSlot(imageUrl: '', name: '').paddingOnly(bottom: 6),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 15, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("The Good Club", style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                Assets.imagesIcLocation,
                scale: 3,
              ),
              SizedBox(
                width: Get.width * .61,

                child:

                Text(
                  'Chandigarh 160001',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: Get.width * .16,
                child: Row(
                  children: [
                    Text(
                      '₹',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.primaryColor,
                        fontFamily: "Roboto"
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '2000',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ).paddingOnly(right: Get.width * .04),
            ],
          ),
        ],
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
            border: Border.all(color:imageUrl.isEmpty? AppColors.primaryColor: Colors.transparent),
          ),
          child: imageUrl.isEmpty
              ? const Icon(CupertinoIcons.add,size: 20, color: AppColors.primaryColor)
              : ClipOval(
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            ),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          name.isNotEmpty ? name : 'Available',
          style: Get.textTheme.bodySmall!.copyWith(
            color: name.isNotEmpty ? AppColors.darkGreyColor : AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
