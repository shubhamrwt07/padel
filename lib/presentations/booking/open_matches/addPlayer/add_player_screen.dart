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
            child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textFieldWithLabel(
                  "First Name",
                  textCapitalization: TextCapitalization.words,
                  controller.firstNameController,
                  context,
                  action: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  readOnly: controller.isLoginUserAdding.value,
                ),
                 textFieldWithLabel(
                  "Last Name",
                  textCapitalization: TextCapitalization.words,
                  controller.lastNameController,
                  context,
                  action: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  readOnly: controller.isLoginUserAdding.value,
                ),
                textFieldWithLabel(
                  "Email",
                  controller.emailController,
                  context,
                  action: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: controller.isLoginUserAdding.value,
                ),
                textFieldWithLabel(
                  "Phone Number",
                  controller.phoneController,
                  context,
                  action: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  readOnly: controller.isLoginUserAdding.value,
                ),

                Text(
                  "Gender",
                  style: Get.textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.labelBlackColor,
                  ),
                ).paddingOnly(top: Get.height * 0.02),

                RadioGroup<String>(
                  groupValue: controller.gender.value.isEmpty ? null : controller.gender.value,
                  onChanged: controller.isLoginUserAdding.value 
                      ? (_) {} 
                      : (value) => controller.gender.value = value!,
                  child: Row(
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
                          contentPadding: EdgeInsets.zero,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                Text(
                  "Player Level",
                  style: Get.textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.labelBlackColor,
                  ),
                ).paddingOnly(
                    top: Get.height * 0.02, bottom: Get.height * 0.01),

                controller.isLoadingLevels.value
                    ? Container(
                        height: 50,
                        decoration: const BoxDecoration(
                          color: AppColors.textFieldColor,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: const Center(
                          child: LoadingWidget(color: AppColors.primaryColor,),
                        ),
                      )
                    : DropdownButtonFormField<String>(
                        initialValue: controller.playerLevel.value.isEmpty ||
                               !controller.playerLevels.any((level) => level["value"] == controller.playerLevel.value)
                            ? null
                            : controller.playerLevel.value,
                        isDense: true,
                        dropdownColor: AppColors.whiteColor,

                        items: controller.playerLevels.map((level) {
                          return DropdownMenuItem<String>(
                            value: level["value"],
                            child: Text(
                              level["label"] ?? "",
                              style: Get.textTheme.headlineSmall!.copyWith(
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList(),

                        selectedItemBuilder: (context) {
                          return controller.playerLevels.map((level) {
                            return Text(
                              level["label"] ?? "",
                              style: Get.textTheme.headlineMedium!.copyWith(
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w500
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            );
                          }).toList();
                        },

                        hint: Text(
                          "Select Player Level",
                          style: Get.textTheme.headlineMedium!.copyWith(
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w500
                          ),
                        ),

                        onChanged: (value) => controller.playerLevel.value = value ?? '',

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
                      )
              ],
            )),
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
              text: controller.isLoginUserAdding.value ? "Add Me" : "Confirm",
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
        ).paddingOnly(top: Get.height * .01),
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
