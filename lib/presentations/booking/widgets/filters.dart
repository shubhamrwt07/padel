import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:padel_mobile/presentations/booking/booking_controller.dart';

import '../../../configs/components/primary_button.dart';


class Filters extends GetView<BookingController> {
  const Filters({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: Get.height * .1,
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
          child: PrimaryButton(
            height: 40,

            onTap: () {
              Get.back();
            },
            text: "Apply Filter",
          ).paddingOnly(left: 20,right: 20),
        ),
      ),

      appBar: primaryAppBar(
        title: const Text("Filters"),
        context: context,
        centerTitle: true,
        action: [
          InkWell(
            onTap: () {
            controller.clearAllFilters();
            },
            child: Text(
              "Clear all",
              style: Get.textTheme.headlineSmall!.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("AM/PM", style: Get.textTheme.headlineSmall),
                Transform.scale(
                  scale: 0.65, // reduce switch size
                  child: Obx(
                    () => Switch(
                      value: controller.isAmPm.value,
                      onChanged: (v) {
                        controller.isAmPm.value = v;
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Text("Location", style: Get.textTheme.headlineMedium),

            const SizedBox(height: 8),

            Obx(
              () => SizedBox(
                height: 50,
                child: DropdownButtonFormField<String>(
                  dropdownColor: Colors.white,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  value: controller.selectedLocation.value.isEmpty
                      ? null
                      : controller.selectedLocation.value,
                  hint: Text(
                    "Enter Location",
                    style: Get.textTheme.headlineSmall,
                  ),
                  items: controller.locations
                      .map(
                        (String location) => DropdownMenuItem<String>(
                          value: location,
                          child: Text(
                            location,
                            style: Get.textTheme.headlineSmall,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    controller.selectedLocation.value = newValue ?? '';
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text("Date", style: Get.textTheme.headlineMedium),
            const SizedBox(height: 8),

            // Start Date
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  commonPicker(
                    hintText: "Start Date",
                    value: controller.startDate.value.isEmpty
                        ? null
                        : controller.startDate.value,
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        controller.startDate.value = picked.toString().split(
                          ' ',
                        )[0];
                      }
                    },
                    icon: Icons.date_range,
                  ),
                  commonPicker(
                    hintText: "End Date",
                    value: controller.endDate.value.isEmpty
                        ? null
                        : controller.endDate.value,
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        controller.endDate.value = picked.toString().split(
                          ' ',
                        )[0];
                      }
                    },
                    icon: Icons.date_range,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Text("Time", style: Get.textTheme.headlineMedium),
            const SizedBox(height: 8),

            // Start Time
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  commonPicker(
                    hintText: "Start Time",
                    value: controller.startTime.value.isEmpty
                        ? null
                        : controller.startTime.value,
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        controller.startTime.value = picked.format(context);
                      }
                    },
                    icon: Icons.watch_later_outlined,
                  ),
                  commonPicker(
                    hintText: "End Time",
                    value: controller.endTime.value.isEmpty
                        ? null
                        : controller.endTime.value,
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        controller.endTime.value = picked.format(context);
                      }
                    },
                    icon: Icons.watch_later_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            sortByWidget(),
            playWithWidget(),
            amenitiesFilters(),
            priceRangeSlider(),
          ],
        ).paddingOnly(bottom: 16, left: 16, right: 16, top: 8),
      ),
    );
  }

  Widget commonPicker({
    required String hintText,
    required VoidCallback onTap,
    String? value,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 40,
        width: Get.width * .4,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey), // grey border
          borderRadius: BorderRadius.circular(6), // radius 6
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ?? hintText,
              style: Get.textTheme.headlineSmall!.copyWith(
                color: value == null ? Colors.grey : Colors.black,
              ),
            ),
            if (icon != null) ...[
              Icon(icon, size: 18, color: AppColors.textHintColor),
            ],
          ],
        ).paddingOnly(left: 15, right: 15),
      ),
    );
  }

  Widget playWithWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Play With", style: Get.textTheme.headlineMedium),
        const SizedBox(height: 8),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.playWithOptions.length,
          itemBuilder: (context, index) {
            final option = controller.playWithOptions[index];
            return Obx(
              () => Transform.translate(
                offset: Offset(-9, 0),

                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(option, style: Get.textTheme.headlineSmall),
                  value: controller.selectedPlayWith.value == option,
                  onChanged: (_) {
                    // Toggle behavior: if already selected, deselect
                    if (controller.selectedPlayWith.value == option) {
                      controller.selectedPlayWith.value = '';
                    } else {
                      controller.selectedPlayWith.value = option;
                    }
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget sortByWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Sort By", style: Get.textTheme.headlineMedium),
        const SizedBox(height: 8),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.sortOptions.length,
          itemBuilder: (context, index) {
            final option = controller.sortOptions[index];
            return Obx(
              () => Transform.translate(
                offset: Offset(-9, 0),
                child: RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,

                  visualDensity: VisualDensity.compact,

                  title: Text(option, style: Get.textTheme.headlineSmall),
                  value: option,
                  groupValue: controller.selectedOption.value,
                  onChanged: (value) {
                    controller.selectedOption.value = value!;
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
  Widget amenitiesFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Amenities Filters", style: Get.textTheme.headlineMedium),
        const SizedBox(height: 8),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.amenitiesFilters.length,
          itemBuilder: (context, index) {
            final option = controller.amenitiesFilters[index];
            return Obx(
                  () => Transform.translate(          offset: Offset(-9, 0),

                    child: CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                    controlAffinity: ListTileControlAffinity.leading, // Checkbox on the left
                                    title: Text(option, style: Get.textTheme.headlineSmall),
                                    value: controller.selectedAmenities.value == option,
                                    onChanged: (_) {
                    // Toggle logic for single-select using checkbox
                    if (controller.selectedAmenities.value == option) {
                      controller.selectedAmenities.value = '';
                    } else {
                      controller.selectedAmenities.value = option;
                    }
                                    },
                                  ),
                  ),
            );
          },
        ),
      ],
    );
  }
  Widget priceRangeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Price Range", style: Get.textTheme.headlineMedium),
        const SizedBox(height: 8),
        Obx(() {
          return Column(
            children: [
              Slider(
                value: controller.selectedPrice.value,
                min: controller.minPrice.value,
                max: controller.maxPrice.value,
                divisions: null, // No divisions
                activeColor: AppColors.primaryColor,
                inactiveColor: Colors.grey.shade300,
                label: "\$${controller.selectedPrice.value.round()}",
                onChanged: (value) {
                  controller.selectedPrice.value = value;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("₹${controller.selectedRange.value.start.round()}"),
                  Text("₹${controller.selectedRange.value.end.round()}"),
                ],
              ),
            ],
          );
        }),
      ],
    );
  }

}
