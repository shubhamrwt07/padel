import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../configs/app_colors.dart';
import '../../configs/components/app_bar.dart';
import '../../configs/components/loader_widgets.dart';
import '../../configs/components/primary_button.dart';
import '../../configs/components/primary_text_feild.dart';
import 'add_player_controller.dart';
class ManualBookingOpenMatchesScreen extends StatelessWidget {
  final ManualBookingOpenMatchesController controller = Get.put(ManualBookingOpenMatchesController());
  ManualBookingOpenMatchesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: primaryAppBar(
            centerTitle: true,
            title: Text("Manual Booking"), context: context),
        bottomNavigationBar: bottomBar(context),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textFieldWithLabel(
                  "First Name",
                  action: TextInputAction.next,
                  controller.fullNameController,
                  context,
                ),
                textFieldWithLabel(
                  "Email",
                  action: TextInputAction.next,
                  controller.emailController,
                  context,
                ),
                textFieldWithLabel(
                  "Phone Number",
                  action: TextInputAction.next,
                  controller.phoneController,
                  maxLength: 10,
                  context,
                ),

                Text("Gender",style: Get.textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.labelBlackColor,
                ),).paddingOnly(top: Get.height*0.02),
                Obx(() => Row(
                  children: ["Female", "Male", "Other"].map((g) {
                    return Expanded(
                      child: RadioListTile<String>(
                        title: Text(
                          g,
                          style: Get.textTheme.headlineSmall,
                          overflow: TextOverflow.ellipsis, // Prevent overflow to new line
                          maxLines: 1, // Force single line
                        ),
                        dense: true, // Compact layout
                        value: g,
                        groupValue: controller.gender.value,
                        onChanged: (value) => controller.gender.value = value!,
                        contentPadding: EdgeInsets.zero, // Optional: tighter spacing
                      ),
                    );
                  }).toList(),
                )),
                Text("Player Level",style: Get.textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.labelBlackColor,
                ),).paddingOnly(top: Get.height*0.02,bottom: Get.height*0.01),
                Obx(() => DropdownButtonFormField<String>(
                  value: controller.playerLevel.value,
                  isDense: true, // reduces overall height
                  items: controller.playerLevels.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level,style:Get.textTheme.labelLarge),
                    );
                  }).toList(),
                  onChanged: (value) => controller.playerLevel.value = value!,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: AppColors.textFieldColor,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                )),

              ],
            ),
          ),
        ),
      ),
    );
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
          child:Obx(
                ()=> PrimaryButton(
              height: 50,
              onTap: () {
                // controller.createUser();
              },
              text:"Confirm",
              // child: controller.isLoading.value
              //     ? AppLoader(size: 30, strokeWidth: 5)
              //     : null,
            ),
          ),
        ).paddingOnly(bottom: Get.height * 0.03),
      ),
    );
  }
  Widget textFieldWithLabel(
      String label,
      TextEditingController? controller,
      BuildContext context, {
        bool readOnly = false,
        TextInputType? keyboardType, TextInputAction? action,
        int? maxLength
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Get.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.labelBlackColor,
          ),
        ).paddingOnly(top: Get.height * .02),
        PrimaryTextField(
          hintText: "Enter $label",
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          action: action,
          maxLength:maxLength,
          // scrollPadding: EdgeInsets.only(bottom: Get.height*0.3),
          // contentPadding: EdgeInsets.symmetric(
          //   horizontal: Get.width * 0.04,
          //   vertical: (57) * 0.22,
          // ),
        ).paddingOnly(top: 10),
      ],
    );
  }
}
