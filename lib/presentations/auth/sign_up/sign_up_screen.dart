import 'package:padel_mobile/presentations/auth/sign_up/widgets/sign_up_exports.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusManager.instance.primaryFocus!.unfocus(),
      child: PrimaryContainer(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: primaryAppBar(title: SizedBox(), context: context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                topTexts(context),
                formFields(),
                locationField(context),
                bottomButtonAndContent(context)
              ],
            ).paddingOnly(left: Get.width * 0.05, right: Get.width * 0.05),
          ),
        ),
      ),
    );
  }
  Widget topTexts(BuildContext context){
    return Column(
      children: [
        Text(
          AppStrings.createAccount,
          style: Theme.of(context).textTheme.titleLarge,
        ).paddingOnly(bottom: Get.height * 0.02,top: Get.height*0.02),
        Text(
          AppStrings.createAnAccountSo,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: Get.height * 0.06),
      ],
    );
  }
  Widget formFields(){
    return Obx(
      ()=> Column(
        children: [
          PrimaryTextField(
            hintText: AppStrings.phoneNumber,
          ).paddingOnly(bottom: Get.height * 0.03),
          PrimaryTextField(
            hintText: AppStrings.email,
          ).paddingOnly(bottom: Get.height * 0.03),
          PrimaryTextField(
            hintText: AppStrings.password,
            obscureText: controller.isVisiblePassword.value,
            maxLine: 1,
            suffixIcon: IconButton(
              onPressed: () => controller.passwordToggle(),
              icon: Image.asset(
                controller.isVisiblePassword.value
                    ? Assets.imagesIcEyeOff: Assets.imagesIcEye,
                color: AppColors.textColor,
                height: 24,
                width: 24,
              ),
            ),
          ).paddingOnly(bottom: Get.height * 0.03),
          PrimaryTextField(
            hintText: AppStrings.confirmPassword,
            obscureText: controller.isVisibleConfirmPassword.value,
            maxLine: 1,
            suffixIcon: IconButton(
              onPressed: () => controller.confirmPasswordToggle(),
              icon: Image.asset(
                controller.isVisibleConfirmPassword.value
                    ? Assets.imagesIcEyeOff: Assets.imagesIcEye,
                color: AppColors.textColor,
                height: 24,
                width: 24,
              ),
            ),          ).paddingOnly(bottom: Get.height * 0.03),
        ],
      ),
    );
  }
  Widget locationField(BuildContext context) {
    final controller = Get.find<SignUpController>();

    return Container(
      height: 55,
      width: Get.width,
      decoration: BoxDecoration(
        color: AppColors.textFieldColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
      child: Obx(() {
        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedLocation!.isEmpty
                ? null
                : controller.selectedLocation!.value,
            hint: Text(
              AppStrings.preferenceLocation,
              style: Theme.of(context)
                  .textTheme.headlineMedium!.copyWith(color: AppColors.textColor,fontWeight: FontWeight.w500),
            ),
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textColor),
            dropdownColor: AppColors.textFieldColor,
            style: Theme.of(context)
                .textTheme.headlineMedium!.copyWith(color: AppColors.textColor,fontWeight: FontWeight.w500),
            onChanged: (value) {
              if (value != null) controller.selectedLocation!.value = value;
            },
            items: controller.locations.map((location) {
              return DropdownMenuItem<String>(
                value: location,
                child: Text(location),
              );
            }).toList(),
          ),
        );
      }),
    ).paddingOnly(bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? Get.height * 0.05 : Get.height * 0.1,);
  }
  Widget bottomButtonAndContent(BuildContext context){
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            Get.toNamed(RoutesName.login);
          },
          child: Container(
            color: Colors.transparent,
            child: RichText(text: TextSpan(
                children:[
                  TextSpan(
                      text: AppStrings.alreadyHaveAccount,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.darkGreyColor)
                  ),
                  TextSpan(
                      text: AppStrings.signIn,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: AppColors.primaryColor)
                  ),
                ]
            )),
          ),
        ).paddingOnly(bottom: Get.height*0.03),
        PrimaryButton(onTap: (){ Get.toNamed(RoutesName.bottomNav);}, text: AppStrings.create),
        SizedBox(height: Get.height*0.04,)
      ],
    );
  }
}
