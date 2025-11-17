import '../../widgets/booking_exports.dart';

class AddPlayerScreen extends StatelessWidget {
  final AddPlayerController controller = Get.put(AddPlayerController());
  AddPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: primaryAppBar(
          centerTitle: true,
          title: const Text("Manual Booking"),
          context: context,
        ),
        bottomNavigationBar: bottomBar(context),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textFieldWithLabel(
                  "First Name",
                  textCapitalization: TextCapitalization.words,
                  controller.fullNameController,
                  context,
                  action: TextInputAction.next,
                  keyboardType: TextInputType.text,
                ),
                textFieldWithLabel(
                  "Email",
                  controller.emailController,
                  context,
                  action: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                ),
                textFieldWithLabel(
                  "Phone Number",
                  controller.phoneController,
                  context,
                  action: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                ),

                Text(
                  "Gender",
                  style: Get.textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.labelBlackColor,
                  ),
                ).paddingOnly(top: Get.height * 0.02),

                Obx(() => Row(
                  children: ["Female", "Male", "Other"].map((g) {
                    return Expanded(
                      child: RadioListTile<String>(
                        title: Text(
                          g,
                          style: Get.textTheme.headlineSmall,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        dense: true,
                        value: g,
                        groupValue: controller.gender.value.isEmpty
                            ? null // 👈 No gender selected by default
                            : controller.gender.value,
                        onChanged: (value) => controller.gender.value = value!,
                        contentPadding: EdgeInsets.zero,
                      ),
                    );
                  }).toList(),
                )),

                Text(
                  "Player Level",
                  style: Get.textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.labelBlackColor,
                  ),
                ).paddingOnly(
                    top: Get.height * 0.02, bottom: Get.height * 0.01),

                Obx(() => DropdownButtonFormField<String>(
                  initialValue: controller.playerLevel.value.isEmpty
                      ? null
                      : controller.playerLevel.value,
                  isDense: true,
                  dropdownColor: AppColors.whiteColor,

                  // 🔹 Dropdown menu items
                  items: controller.playerLevels.map((level) {
                    return DropdownMenuItem<String>(
                      value: level["value"],
                      child: Text(
                        level["label"] ?? "",
                        style: Get.textTheme.headlineSmall!.copyWith(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12, // 👈 smaller text so full label fits nicely
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }).toList(),

                  // 🔹 Selected item (shown when dropdown is closed)
                  selectedItemBuilder: (context) {
                    return controller.playerLevels.map((level) {
                      return Text(
                        level["label"] ?? "",
                        style: Get.textTheme.headlineMedium!.copyWith(color: AppColors.textColor,fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      );
                    }).toList();
                  },

                  // 🔹 Hint text
                  hint: Text(
                    "Select Player Level",
                    style: Get.textTheme.headlineMedium!.copyWith(color: AppColors.textColor,fontWeight: FontWeight.w500),
                  ),

                  onChanged: (value) => controller.playerLevel.value = value!,

                  // 🔹 Input field decoration
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: AppColors.textFieldColor,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ))
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
      decoration: const BoxDecoration(
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
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Obx(
                () => PrimaryButton(
              height: 50,
              onTap: () {
                controller.createUser();
              },
              text: "Confirm",
              child: controller.isLoading.value
                  ? const AppLoader(size: 30, strokeWidth: 5)
                  : null,
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
        TextInputType? keyboardType,
        TextInputAction? action,
        int? maxLength,
        TextCapitalization? textCapitalization
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
          textCapitalization: textCapitalization,
          maxLength: maxLength,
        ).paddingOnly(top: 10),
      ],
    );
  }
}
