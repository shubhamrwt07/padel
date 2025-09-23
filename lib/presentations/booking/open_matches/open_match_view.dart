import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/components/custom_button.dart';
import '../../../data/response_models/openmatch_model/all_open_matches.dart';
import '../all_suggestions/all_suggestions.dart';
import '../widgets/booking_exports.dart';
import 'open_match_controller.dart';
class OpenMatchesScreen extends StatelessWidget {
  final OpenMatchesController controller =
  Get.put(OpenMatchesController());

  OpenMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: Get.height * .09,
        padding: const EdgeInsets.only(top: 10),
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
              "+ Create an Open Match",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(color: AppColors.whiteColor),
            ).paddingOnly(right: Get.width * 0.14),
            onTap: () {
             final booking = Get.put(BookSessionController());
              Get.toNamed(RoutesName.createOpenMatch, arguments: {"id":booking.argument});
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDatePicker(),
              Transform.translate(
                offset: Offset(0, -Get.height * 0.03),
                child: _buildSlotHeader(context),
              ),
              _buildTimeSlots(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Open matches",style: Get.textTheme.headlineMedium,),
                  GestureDetector(
                    onTap: ()=> Get.to(
                          () => AllSuggestions(),
                      transition: Transition.rightToLeft,
                    ),
                    child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                        alignment: Alignment.center,
                        child: Text("View all",style: Get.textTheme.labelMedium!.copyWith(color: AppColors.primaryColor),)),
                  ),
                ],
              ).paddingOnly(bottom: 10),
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: buildMatchCardShimmer());
                }
                final matches = controller.matchesBySelection.value;
                if (matches == null || (matches.data?.isEmpty ?? true)) {
                  return Center(
                    child: Column(
                      children: [
                        Icon(Icons.event_busy_outlined,size: 50,color: AppColors.darkGrey,),
                        Text(
                          'No matches available for this time',
                          style: Get.textTheme.labelLarge?.copyWith(color: AppColors.darkGrey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ).paddingOnly(top: 50),
                  );
                }
                return Column(
                  children: matches.data!
                      .map((m) => _buildMatchCardFromData(context, m))
                      .toList(),
                );
              }),
              const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- DATE PICKER ----------------
  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select date", style: Get.textTheme.labelLarge),
        Obx(
              () => Transform.translate(
            offset: Offset(0, -8),
            child: EasyDateTimeLinePicker.itemBuilder(
              headerOptions: HeaderOptions(
                headerBuilder: (_, context, date) => const SizedBox.shrink(),
              ),
              selectionMode: SelectionMode.alwaysFirst(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2030, 3, 18),
              focusedDate: controller.selectedDate.value,
              itemExtent: 65,
              itemBuilder: (context, date, isSelected, isDisabled, isToday, onTap) {
                final dayName = DateFormat('E').format(date);
                final monthName = DateFormat('MMM').format(date);

                return GestureDetector(
                  onTap: onTap,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      height: Get.height * 0.075,
                      width: Get.width * 0.13,
                      key: ValueKey(isSelected),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isSelected
                            ? Colors.black
                            : AppColors.playerCardBackgroundColor,
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : AppColors.blackColor.withAlpha(10),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayName,
                            style: Get.textTheme.bodySmall!.copyWith(
                              fontSize: 11,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            date.day.toString(),
                            style: Get.textTheme.titleMedium!.copyWith(
                              fontSize: 18,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textColor,
                            ),
                          ),
                          Text(
                            monthName,
                            style: Get.textTheme.bodySmall!.copyWith(
                              fontSize: 11,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).paddingSymmetric(vertical: 6);
              },
              onDateChange: (date) {
                controller.selectedDate.value = date;
                // ensure slot lists and selection are updated with new date
                controller.selectedTime = null;
                controller.selectedSlots.clear();
                controller.fetchMatchesForSelection();
              },
            ),
          ),
        ),
      ],
    );
  }

  /// ---------------- SLOT HEADER ----------------
  Widget _buildSlotHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Available Slots', style: Theme.of(context).textTheme.labelLarge),
        Row(
          children: [
            Text(
              'Show Unavailable Slots',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: AppColors.darkGrey),
            ),
            SizedBox(width: Get.width * .01),
            Transform.scale(
              scale: 0.7,
              child: Obx(
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
          ],
        ),
      ],
    );
  }

  /// ---------------- TIME SLOTS ----------------
  Widget _buildTimeSlots() {
    return Transform.translate(
      offset: Offset(0, -Get.height * 0.02),
      child: Obx(() {
        double spacing = Get.width * .015; // smaller spacing
        final double tileWidth = (Get.width - spacing * 5 - 32) / 4; // fit 5 per row

        final available = controller.availableSlots;
        final unavailable = controller.unavailableSlots;
        final showUnavailable = controller.viewUnavailableSlots.value;

        List<Widget> buildSlotTiles(List<String> slots, {required bool disabled}) {
          return slots.map((time) {
            final isSelected = controller.selectedSlots.contains(time);
            return GestureDetector(
              onTap: () {
                if (disabled) return;
                controller.selectedTime = time;
                controller.selectedSlots
                  ..clear()
                  ..add(time);
                controller.fetchMatchesForSelection();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                width: tileWidth,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.black
                      : disabled
                          ? AppColors.greyColor.withOpacity(.3)
                          : AppColors.timeTileBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: disabled ? AppColors.greyColor : AppColors.blackColor.withAlpha(10),
                  ),
                ),
                child: Text(
                  time,
                  style: Get.textTheme.labelLarge?.copyWith(
                    fontSize: 11,
                    color: isSelected
                        ? Colors.white
                        : disabled
                            ? AppColors.darkGrey
                            : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: spacing,
              runSpacing: Get.height * 0.008,
              children: buildSlotTiles(available, disabled: false),
            ),
            if (showUnavailable && unavailable.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: spacing,
                runSpacing: Get.height * 0.008,
                children: buildSlotTiles(unavailable, disabled: true),
              ),
            ],
          ],
        );
      }),
    );
  }


  /// ---------------- MATCH HEADER ----------------
  Widget _buildMatchHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Book a place in a match",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        GestureDetector(
          onTap: () => Get.to(
                () => AllSuggestions(),
            transition: Transition.rightToLeft,
          ),
          child: Container(
            height: 20,
            width: Get.width * 0.15,
            alignment: Alignment.centerRight,
            color: Colors.transparent,
            child: Text(
              "View all",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: AppColors.primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  /// ---------------- MATCH CARD ----------------
  Widget _buildMatchCard(BuildContext context) {
    return Container(
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
                          image: Assets.imagesImgCustomerPicBooking),
                      _buildPlayerSlot(
                          image: Assets.imagesImgCustomerPicBooking),
                      Container(width: 1, color: AppColors.greyColor),
                      _buildPlayerSlot(
                          image: Assets.imagesImgCustomerPicBooking),
                      _buildPlayerSlot(
                          image: Assets.imagesImgCustomerPicBooking),
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
                    width: Get.width * .64,
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
          ).paddingOnly(top: 5, bottom: 15, left: 15),
        ],
      ),
    );
  }

  Widget _buildPlayerSlot({required String image}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.greyColor,
          backgroundImage: AssetImage(image),
        ),
        const SizedBox(height: 5),
        Text(
          "Available",
          style: Get.textTheme.bodySmall!.copyWith(
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }

  // Rich card from API data
  Widget _buildMatchCardFromData(BuildContext context, MatchData data) {
    final dayStr = getDay(data.matchDate);
    final dateOnlyStr = getDate(data.matchDate);
    final timeStr = (data.matchTime ?? '').toLowerCase();
    final clubName = data.clubId?.clubName ?? '-';
    final address = data.clubId?.city != null && data.clubId?.zipCode != null
        ? '${data.clubId?.city} ${data.clubId?.zipCode}'
        : (data.clubId?.address ?? '-');
    final price = (data.slot?.isNotEmpty == true && data.slot!.first.slotTimes?.isNotEmpty == true)
        ? '₹${data.slot!.first.slotTimes!.first.amount ?? ''}'
        : '₹-';

    // Build players list (up to 4)
    final playerAvatars = <Widget>[];

    // Team A first player
    final teamAFirst = data.teamA != null && data.teamA!.isNotEmpty
        ? data.teamA!.first.userId?.profilePic
        : null;

    if (teamAFirst != null && teamAFirst.isNotEmpty) {
      playerAvatars.add(
        _buildFilledPlayer(teamAFirst, data.teamA!.first.userId?.name ?? ''),
      );
    }

    // Team B first player (currently placeholder since no userId defined in your model)
    final teamBFirst = data.teamB != null && data.teamB!.isNotEmpty
        ? data.teamB!.first.userId?.profilePic
        : null;

    if (teamBFirst != null && teamBFirst.isNotEmpty) {
      playerAvatars.add(
        _buildFilledPlayer(teamBFirst, data.teamB!.first.userId?.name ?? ''),
      );
    }

    // Fill remaining slots until 4 total
    while (playerAvatars.length < 4) {
      playerAvatars.add(_buildAvailableCircle());
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.playerCardBackgroundColor,
        border: Border.all(color: AppColors.greyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: date | time and level badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$dayStr ',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.w900),
                        ),
                        TextSpan(
                          text: '$dateOnlyStr | $timeStr',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ).paddingOnly(right: Get.width * 0.05),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data.skillLevel?.substring(0, 1).toUpperCase() ??
                          'A/B',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(
                          color: AppColors.whiteColor, fontSize: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    "${data.skillLevel?.capitalizeFirst ?? 'Professional'} |",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Icon(
                    data.gender == "female"
                        ? Icons.female
                        : data.gender == "male"
                        ? Icons.male
                        : Icons.wc,
                    size: 14,
                  ).paddingOnly(right: 5, left: 5),
                  Text(
                    data.matchType?.capitalizeFirst ?? 'Mixed',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              )
            ],
          ).paddingOnly(top: 15, bottom: 10,left: 15),

          // Players row with up to 4 slots
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Team A slots (first 2)
                  ...playerAvatars.take(2),

                  // Divider between teams
                  VerticalDivider(
                    color: AppColors.greyColor,
                    thickness: 1.5,
                    width: 0,
                  ),

                  // Team B slots (last 2)
                  ...playerAvatars.skip(2),
                ],
              ),
            ),
          ),

          Divider(thickness: 1.5, height: 0, color: AppColors.greyColor),

          // Footer club and price
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clubName,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14, color: AppColors.darkGrey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            address,
                            style: Theme.of(context).textTheme.labelSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: Get.width * .22,
                color: AppColors.playerCardBackgroundColor,
                child: Text(
                  price,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.primaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ).paddingOnly(top: 10, bottom: 12, left: 15),
        ],
      ),
    ).paddingOnly(bottom: 12);
  }


  Widget _buildFilledPlayer(String imageUrl, String name) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey.shade400,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: 48,
              height: 48,
              placeholder: (context, url) => CircularProgressIndicator(color: AppColors.primaryColor,),
              errorWidget: (context, url, error) => const Icon(Icons.person, size: 24),
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 60,
          child: Text(
            name,
            style: Get.textTheme.labelSmall,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableCircle() {
    return Column(
      children: [
        GestureDetector(
          onTap: ()=>Get.toNamed(RoutesName.addPlayer),
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryColor, width: 1),
            ),
            child: const Center(
              child: Icon(Icons.add, color: AppColors.primaryColor),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Available",
          style: Get.textTheme.labelSmall!.copyWith(color: AppColors.primaryColor),
        )
      ],
    );
  }

  String getDay(String? ymd) {
    if (ymd == null || ymd.isEmpty) return '';
    try {
      final parsed = DateFormat('yyyy-MM-dd').parse(ymd);
      return DateFormat('EEEE').format(parsed); // e.g. Monday
    } catch (_) {
      return ymd;
    }
  }

  String getDate(String? ymd) {
    if (ymd == null || ymd.isEmpty) return '';
    try {
      final parsed = DateFormat('yyyy-MM-dd').parse(ymd);
      return DateFormat('dd MMMM').format(parsed); // e.g. 16 September
    } catch (_) {
      return ymd;
    }
  }

  Widget buildMatchCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // color: Colors.white,
          border: Border.all(color: AppColors.greyColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header shimmer
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10, right: 15, left: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 12,
                              width: 60,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              height: 16,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              height: 10,
                              width: 80,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              height: 10,
                              width: 40,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Players shimmer row
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Team A placeholders
                    _circleShimmer(),
                    _circleShimmer(),

                    // Divider
                    VerticalDivider(
                      color: AppColors.greyColor,
                      thickness: 1.5,
                      width: 0,
                    ),

                    // Team B placeholders
                    _circleShimmer(),
                    _circleShimmer(),
                  ],
                ),
              ),
            ),

            Divider(thickness: 1.5, height: 0, color: AppColors.greyColor),

            // Footer shimmer
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 12, left: 15, right: 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 14,
                          width: 100,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 10,
                          width: 120,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: Get.width * .22,
                    height: 30,
                    color: Colors.grey,
                  ).paddingOnly(right: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    ).paddingOnly(bottom: 12);
  }

  Widget _circleShimmer() {
    return Container(
      height: 60,
      width: 60,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
    );
  }

}
