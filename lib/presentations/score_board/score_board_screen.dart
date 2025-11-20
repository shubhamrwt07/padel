import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:padel_mobile/configs/components/loader_widgets.dart';
import 'package:padel_mobile/handler/text_formatter.dart';
import 'package:padel_mobile/presentations/score_board/score_board_controller.dart';
import 'package:padel_mobile/presentations/score_board/widgets/add_player_bottomsheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class ScoreBoardScreen extends StatelessWidget {
  final ScoreBoardController controller = Get.put(ScoreBoardController());

  ScoreBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backGroundColor: AppColors.primaryColor,
          titleTextColor: Colors.white,
          leadingButtonColor: Colors.white,
          title: Text("Scoreboard"),
          centerTitle: true,
          action: [
            IconButton(
              icon: const Icon(Icons.share_outlined, color: Colors.white,size: 20,),
              onPressed: () {},
            ),
          ],
          context: context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 120,
                  color: AppColors.primaryColor,
                  width: Get.width,
                ),
                Obx(() => controller.isLoading.value
                    ? _buildMatchCardShimmer(context).paddingOnly(left: 15, right: 15, top: 10)
                    : _buildMatchCard(context).paddingOnly(left: 15, right: 15, top: 10)),
              ],
            ),
            const SizedBox(height: 12),
            _buildAddScoreButton(),
            const SizedBox(height: 12),
            Obx(() => controller.isLoading.value
                ? _buildSetSectionShimmer().paddingOnly(left: 15, right: 15)
                : _buildSetSection().paddingOnly(left: 15, right: 15)),
          ],
        ),
      ),
    );
  }

  // Shimmer loader for Match Card
  Widget _buildMatchCardShimmer(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: AppColors.blackColor.withAlpha(10)),
          boxShadow: [
            BoxShadow(
                color: AppColors.greyColor,
                blurRadius: 0.5,
                spreadRadius: 0.6,
                offset: Offset(0, 2)
            )
          ]
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: Get.width * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      height: 12,
                      width: Get.width * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 12,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ).paddingOnly(bottom: 8),

            // Players shimmer
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ...List.generate(2, (index) => _buildPlayerShimmer()),
                  Container(
                    width: 1,
                    color: AppColors.blackColor.withAlpha(50),
                  ).paddingOnly(bottom: 25),
                  ...List.generate(2, (index) => _buildPlayerShimmer()),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Status shimmer
            Center(
              child: Container(
                height: 24,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerShimmer() {
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Container(
          height: 10,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  // Shimmer loader for Set Section
  Widget _buildSetSectionShimmer() {
    return Card(
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 500,   // 👈 Start with 500
        ),
        width: Get.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Set items shimmer
              ...List.generate(5, (index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 10,
                      width: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                        // shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      height: 14,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      height: 10,
                      width: 36,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)
                        // shape: BoxShape.circle,
                      ),
                    ),
                  ],
                );
              }),

              Column(
                children: [
                   SizedBox(height: Get.height*0.15),

                  // Add Set button shimmer
                  Container(
                    height: 32,
                    width: 220,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Divider(color: AppColors.greyColor, height: 0.1),

                  // Match Summary shimmer
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(3, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 12,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                Container(
                                  height: 12,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(color: AppColors.blackColor.withAlpha(10)),
              boxShadow: [
                BoxShadow(
                    color: AppColors.greyColor,
                    blurRadius: 0.5,
                    spreadRadius: 0.1,
                    offset: Offset(0, 2)
                )
              ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMatchHeader(context,),
              _buildPlayerRow(),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child:  Text(
                    "🕒 Waiting",
                    style: Get.textTheme.labelSmall!.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMatchHeader(BuildContext context,) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.transparent,
              width: Get.width * 0.58,
              child: Obx(() {
                String raw = controller.matchDate.value.toString().trim();

                DateTime? date;
                try {
                  date = DateTime.parse(raw);
                } catch (e) {
                  log("DATE PARSE ERROR: '$raw'");
                  date = null;
                }

                return Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "${DateFormat('EEEE').format(date!)} ",
                        style: Get.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 13
                        ),
                      ),
                      TextSpan(
                        text:
                        "${DateFormat('dd MMM').format(date)} | ${formatTimeSlot(controller.matchTime.value)}",
                        style: Get.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w500,fontSize: 13
                        ),
                      ),
                    ],
                  ),
                );
              }),
            )
          ],
        ),
        Obx(
              ()=> Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                controller.clubName.value,
                style: Get.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                controller.courtName.value,
                style: Get.textTheme.labelSmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        )
      ],
    ).paddingOnly(bottom: 8);
  }

  Widget _buildPlayerRow() {
    return Obx(() {
      log("=== BUILDING PLAYER ROW ===");
      log("Teams count: ${controller.teams.length}");

      final teamAPlayers = controller.teams.isNotEmpty
          ? controller.teams[0]["players"] as List
          : [];

      log("Team A players: ${teamAPlayers.length}");
      for (int i = 0; i < teamAPlayers.length; i++) {
        log("  Team A Player $i: ${teamAPlayers[i]['name']}");
      }

      final teamBPlayers = controller.teams.length > 1
          ? controller.teams[1]["players"] as List
          : [];

      log("Team B players: ${teamBPlayers.length}");
      for (int i = 0; i < teamBPlayers.length; i++) {
        log("  Team B Player $i: ${teamBPlayers[i]['name']}");
      }

      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Team A player 1
            _buildPlayerSlot(teamAPlayers, 0, "Team A"),

            // Team A player 2
            _buildPlayerSlot(teamAPlayers, 1, "Team A"),

            // divider
            Container(
              width: 1,
              color: AppColors.blackColor.withAlpha(50),
            ).paddingOnly(bottom: 25),

            // Team B player 1
            _buildPlayerSlot(teamBPlayers, 0, "Team B"),

            // Team B player 2
            _buildPlayerSlot(teamBPlayers, 1, "Team B"),
          ],
        ),
      );
    });
  }

  Widget _buildPlayerSlot(List players, int index, String teamName) {
    bool hasPlayer = index < players.length;

    return GestureDetector(
      onTap: () {
        if (!hasPlayer) {
          Get.bottomSheet(
            AddPlayerBottomSheet(teamName: teamName,scoreBoardId: controller.scoreboardId.value,),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
        }
      },
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppColors.primaryColor),
            ),
            child: hasPlayer
                ? (players[index]["pic"] != null && players[index]["pic"].toString().isNotEmpty)
                ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: players[index]["pic"],
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: LoadingWidget(color: AppColors.primaryColor,),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.person,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
              ),
            )
                : Center(
              child: Text(
                getNameInitials(players[index]["name"], players[index]["lastName"]),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            )
                : const Icon(
              Icons.add,
              size: 24,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(
            width: Get.width * 0.13,
            child: Text(
              hasPlayer ? players[index]["name"].toString().split(' ').first.trim() : "Available",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Get.textTheme.bodySmall!.copyWith(
                color: AppColors.primaryColor,
                fontSize: 11,
              ),
            ).paddingOnly(top: Get.height * 0.003),
          ),
          hasPlayer?
          Container(
            height: 17,
            width: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.secondaryColor.withAlpha(20),
            ),
            child: Text(
              players[index]["level"] ?? "-",
              style: Get.textTheme.labelMedium!.copyWith(color: AppColors.secondaryColor),
            ),
          ).paddingOnly(top: 4):SizedBox.shrink()
        ],
      ),
    );
  }

  Widget _buildAddScoreButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () {},
        child: const Text(
          "+ Add Score",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildSetSection() {
    return Obx(() {
      return Card(
        child: Container(
          constraints:  BoxConstraints(
            minHeight: Get.height*0.5,
          ),
          width: Get.width,
          margin: const EdgeInsets.symmetric(horizontal: 0),
          padding: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    ...controller.sets.asMap().entries.map((entry) {
                      final index = entry.key;
                      final set = entry.value;

                      return Dismissible(
                        key: ValueKey("set_${set["set"]}"),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) async {
                          // Ensure UI waits before removing -> prevents the error
                          await Future.delayed(Duration(milliseconds: 10));
                          controller.removeSet(index);
                          return true;
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white, size: 22),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.remove, color: Colors.black54, size: 16),
                              Text(
                                "Set ${set["set"]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  fontSize: 15,
                                ),
                              ),
                              const Icon(Icons.remove, color: Colors.black54, size: 16),
                            ],
                          ),
                        ),
                      );
                    }),

                  ],
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 10),
                  // Show only if less than 8 sets
                  if (controller.sets.length < 10)
                    GestureDetector(
                      onTap: (){
                        controller.addSet();
                      },
                      child: Container(
                        alignment: AlignmentGeometry.center,
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            border: Border.all(color: AppColors.textColor),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.greyColor,
                                  blurRadius: 0.5,
                                  spreadRadius: 0.6,
                                  offset: Offset(0, 2)
                              )
                            ]
                        ),
                        child: const Text(
                          "+ Add Set",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ).paddingOnly(left: 10,right: 10),
                    ),
                  const SizedBox(height: 20),
                  Divider(color: AppColors.greyColor,height: 0.1,),
                  _buildMatchSummary(),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  // Widget _buildScoreTable(Map<String, dynamic> set) {
  //   return Column(
  //     children: [
  //       const SizedBox(height: 8),
  //       Table(
  //         border: TableBorder.all(color: Colors.grey.shade300),
  //         columnWidths: const {
  //           0: FixedColumnWidth(70),
  //           1: FlexColumnWidth(),
  //           2: FlexColumnWidth(),
  //           3: FlexColumnWidth(),
  //           4: FlexColumnWidth(),
  //           5: FlexColumnWidth(),
  //           6: FlexColumnWidth(),
  //         },
  //         children: [
  //           // Header Row
  //           TableRow(
  //             children: [
  //               Padding(
  //                 padding: EdgeInsets.all(6),
  //                 child: Text('Set',style: Get.textTheme.labelLarge!.copyWith(color: AppColors.textColor), textAlign: TextAlign.center),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.all(6),
  //                 child: Text('R1',style: Get.textTheme.labelLarge!.copyWith(color: AppColors.textColor), textAlign: TextAlign.center),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.all(6),
  //                 child: Text('R2',style: Get.textTheme.labelLarge!.copyWith(color: AppColors.textColor), textAlign: TextAlign.center),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.all(6),
  //                 child: Text('R3',style: Get.textTheme.labelLarge!.copyWith(color: AppColors.textColor), textAlign: TextAlign.center),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.all(6),
  //                 child: Text('R4',style: Get.textTheme.labelLarge!.copyWith(color: AppColors.textColor), textAlign: TextAlign.center),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.all(6),
  //                 child: Text('R5',style: Get.textTheme.labelLarge!.copyWith(color: AppColors.textColor), textAlign: TextAlign.center),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.all(6),
  //                 child: Text('R6',style: Get.textTheme.labelLarge!.copyWith(color: AppColors.textColor), textAlign: TextAlign.center),
  //               ),
  //             ],
  //           ),
  //           // Team A row
  //           TableRow(
  //             children: [
  //               const Padding(
  //                 padding: EdgeInsets.all(6),
  //                 child: Text('Team A', textAlign: TextAlign.center),
  //               ),
  //               ...List.generate(6, (i) {
  //                 return const Padding(
  //                   padding: EdgeInsets.all(6),
  //                   child: Text('W',
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(color: Colors.green)),
  //                 );
  //               }),
  //             ],
  //           ),
  //           // Team B row
  //           TableRow(
  //             children: [
  //               const Padding(
  //                 padding: EdgeInsets.all(6),
  //                 child: Text('Team B', textAlign: TextAlign.center),
  //               ),
  //               ...List.generate(6, (i) {
  //                 return const Padding(
  //                   padding: EdgeInsets.all(6),
  //                   child: Text('-',
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(color: Colors.grey)),
  //                 );
  //               }),
  //             ],
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 8),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             "High Score: Team A (3:2)",
  //             style: Get.textTheme.bodySmall,
  //           ),
  //           Container(
  //             alignment: AlignmentGeometry.center,
  //             height: 25,padding: EdgeInsets.symmetric(horizontal: 10),
  //             decoration: BoxDecoration(
  //               color: AppColors.primaryColor,
  //               borderRadius: BorderRadius.circular(5),
  //
  //             ),
  //             child: const Text(
  //               "+ Add Score",
  //               style: TextStyle(color: Colors.white, fontSize: 12),
  //             ),
  //           )
  //         ],
  //       ),
  //       const SizedBox(height: 12),
  //     ],
  //   );
  // }

  Widget _buildMatchSummary() {
    return Obx(() {
      return Container(
        width: Get.width,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Match Summary",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Team A Wins:"),
                Text("${controller.teamAWins.value}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Team B Wins:"),
                Text("${controller.teamAWins.value}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Winner:"),
                Text(controller.winner.value),
              ],
            ),
          ],
        ),
      );
    });
  }
}