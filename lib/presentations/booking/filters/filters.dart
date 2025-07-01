import 'package:flutter/cupertino.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

class Filters extends StatelessWidget {
   Filters({super.key});
   final FiltersController controller = Get.put(FiltersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: Get.height * .1,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
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
          child:  CustomButton(
              width: Get.width*0.9,
              child: Text(
                "Apply filter",
                style: Theme.of(context).textTheme.headlineMedium!
                    .copyWith(
                  color: AppColors.whiteColor,
                ),
              ).paddingOnly(right: Get.width*0.14),
              onTap: (){
                Get.back();
              }).paddingOnly(left: 20,right: 20),
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
                  scale: 0.65,
                  child: Theme(
                    data: ThemeData(
                      // This affects only this switch
                      unselectedWidgetColor: Colors.red, // Track color when off
                    ),
                    child:Obx(
                          () => CupertinoSwitch(
                        value: controller.viewUnavailableSlots.value,
                        activeTrackColor: Theme.of(context).primaryColor,
                        inactiveTrackColor: Colors.grey.shade300,
                        thumbColor: Colors.white,
                        onChanged: (value) {
                          controller.viewUnavailableSlots.value = value;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text("Location", style: Get.textTheme.headlineMedium).paddingOnly(bottom: Get.height*0.01),
          Obx(
                () => Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.lightBlueColor.withAlpha(40),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.blackColor.withAlpha(20)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(5), // Use our own alignment
                    isDense: true, // Helps reduce extra padding
                  ),
                  dropdownColor: AppColors.whiteColor,
                  value: controller.selectedLocation.value.isEmpty
                      ? null
                      : controller.selectedLocation.value,
                  hint: Row(
                    children: [
                      Text(
                        "Enter Location",
                        style: Get.textTheme.headlineSmall,
                      ),
                    ],
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
                  // Align the selected text to the left (center vertically by default)
                  selectedItemBuilder: (context) => controller.locations.map((location) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        location,
                        style: Get.textTheme.headlineSmall,
                        textAlign: TextAlign.left,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
            const SizedBox(height: 10),
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
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              textTheme: const TextTheme(
                                // Customize as needed
                                titleLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                bodyLarge: TextStyle(fontSize: 14),
                                bodyMedium: TextStyle(fontSize: 12),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        controller.startDate.value = picked.toString().split(
                          ' ',
                        )[0];
                      }
                    },
                    icon: Icons.calendar_month_outlined,
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
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              textTheme: const TextTheme(
                                // Customize as needed
                                titleLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                bodyLarge: TextStyle(fontSize: 14),
                                bodyMedium: TextStyle(fontSize: 12),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        controller.endDate.value = picked.toString().split(
                          ' ',
                        )[0];
                      }
                    },
                    icon: Icons.calendar_month_outlined,
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
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              textTheme: const TextTheme(
                                // Customize as needed
                                titleLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                bodyLarge: TextStyle(fontSize: 14),
                                bodyMedium: TextStyle(fontSize: 12),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        controller.startTime.value = picked.format(context);
                      }
                    },
                    icon: CupertinoIcons.timer,
                  ),
                  commonPicker(
                    hintText: "End Time",
                    value: controller.endTime.value.isEmpty
                        ? null
                        : controller.endTime.value,
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              textTheme: const TextTheme(
                                titleLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                bodyLarge: TextStyle(fontSize: 14),
                                bodyMedium: TextStyle(fontSize: 12),
                              ),
                            ),
                            child: child!,
                          );
                        },
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        controller.endTime.value = picked.format(context);
                      }
                    },
                    icon: CupertinoIcons.timer,
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
        width: Get.width * .44,
        decoration: BoxDecoration(
          color: AppColors.lightBlueColor.withAlpha(50),
          border: Border.all(color: AppColors.blackColor.withAlpha(20)), // grey border
          borderRadius: BorderRadius.circular(6), // radius 6
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ?? hintText,
              style: Get.textTheme.headlineSmall!.copyWith(
                color:Colors.black,
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
                  Text("₹${controller.selectedRange.value.start.round()}",style: TextStyle(fontFamily: "Roboto"),),
                  Text("₹${controller.selectedRange.value.end.round()}",style: TextStyle(fontFamily: "Roboto")),
                ],
              ),
            ],
          );
        }),
      ],
    );
  }

}
