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
      bottomNavigationBar: bottomButton(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSlotSelector(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "For your level",
                  style: Get.textTheme.headlineLarge,
                ),
                InkWell(
                  onTap: () => Get.to(Filters()),
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        color: AppColors.playerCardBackgroundColor,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Image.asset(
                      Assets.imagesIcFilter,
                      scale: 3.5,
                    ),
                  ),
                ),
              ],
            ).paddingOnly(left: Get.width*.025,right: Get.width*.025,top: Get.height*0.01),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Slots :", style: Get.textTheme.headlineSmall),
          const SizedBox(width: 10),
          Expanded(
            child: Obx(
                  () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: controller.slots.map((slot) {
                    final isSelected = controller.selectedSlot.value == slot;
                    return GestureDetector(
                      onTap: () => controller.selectSlot(slot),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 3),
                        margin: const EdgeInsets.only(left: 10),
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
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: Get.textTheme.headlineLarge!.copyWith(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          child: Text(slot),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildMatchCard(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(DetailsPage()),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.playerCardBackgroundColor,
          border: Border.all(color: AppColors.greyColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMatchHeader(context),
            _buildPlayerRow(),
             Divider(thickness: 1.5, height: 0, color: AppColors.blackColor.withAlpha(50)).paddingOnly(bottom: 3),
            _buildMatchFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("21 June | 9:00am", style: Get.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w600,fontSize: 13)),
        Text("Competitive",
            style: Get.textTheme.labelSmall),
      ],
    ).paddingOnly(bottom: 8);
  }

  Widget _buildPlayerRow() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPlayerSlot(
            imageUrl: Assets.imagesImgCustomerPicBooking,
            name: 'Courtney',
          ).paddingOnly(bottom: 6),
          _buildPlayerSlot(
            imageUrl: Assets.imagesImgCustomerPicBooking,
            name: 'Devon Lane',
          ).paddingOnly(bottom: 6),
          Container(width: 1, color: AppColors.blackColor.withAlpha(50)).paddingOnly(bottom: 10),
          _buildPlayerSlot(imageUrl: '', name: '').paddingOnly(bottom: 6),
          _buildPlayerSlot(imageUrl: '', name: '').paddingOnly(bottom: 6),
        ],
      ),
    );
  }

  Widget _buildMatchFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("The Good Club", style: Get.textTheme.labelLarge!.copyWith(fontSize: 11)),
            Row(
              children: [
                Image.asset(
                  Assets.imagesIcLocation,
                  scale: 3,
                ),
                Text(
                  'Chandigarh 160001',
                  style: Get.textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '₹ ',
              style: Get.textTheme.titleMedium!.copyWith(
                  color: AppColors.primaryColor,
                  fontFamily: "Roboto"
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '2000',
              style: Get.textTheme.titleMedium!.copyWith(
                color: AppColors.primaryColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),

      ],
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
        Text(
          name.isNotEmpty ? name : 'Available',
          style: Get.textTheme.bodySmall!.copyWith(
            color: name.isNotEmpty ? AppColors.darkGreyColor : AppColors.primaryColor,fontSize: 11
          ),
        ).paddingOnly(top: Get.height*0.003),
      ],
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
          width: Get.width * 0.9,
          child: Text(
            "+ Start a match",
            style: Get.textTheme.headlineMedium!.copyWith(color: AppColors.whiteColor),
          ).paddingOnly(right: Get.width * 0.14),
          onTap: () {
            Get.to(() => DetailsPage(), transition: Transition.rightToLeft);
          },
        ),
      ),
    );
  }
}
