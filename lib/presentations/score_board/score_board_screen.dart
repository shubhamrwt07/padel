import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/app_bar.dart';
import 'package:padel_mobile/presentations/score_board/score_board_controller.dart';
import 'package:padel_mobile/presentations/score_board/widgets/add_player_bottomsheet.dart';

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
                _buildMatchCard(context).paddingOnly(left: 15,right: 15,top: 10),
              ],
            ),
            const SizedBox(height: 12),
            _buildAddScoreButton(),
            _buildSetSection().paddingOnly(left: 15,right: 15),
          ],
        ),
      ),
    );
  }
  Widget _buildMatchCard(
      BuildContext context) {
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
                  spreadRadius: 0.6,
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
              child: RichText(
                overflow: TextOverflow.clip,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Friday",
                      style: Get.textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: "10 Nov | 3:00pm",
                      style: Get.textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  "Professional | ",
                  style: Get.textTheme.displaySmall!.copyWith(fontSize: 11),
                ),
                Icon(Icons.male,size: 15,),
                Text(
                  "Male Only",
                  style: Get.textTheme.displaySmall!.copyWith(fontSize: 11),
                ),
              ],
            ).paddingOnly(top: 2),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'The Good Club',
              style: Get.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Court 2',
              style: Get.textTheme.labelSmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        )
      ],
    ).paddingOnly(bottom: 8);
  }

  Widget _buildPlayerRow() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildAddPlayerSlot(),
          _buildAddPlayerSlot(),
          Container(
            width: 1,
            color: AppColors.blackColor.withAlpha(50),
          ).paddingOnly(bottom: 25),
          _buildAddPlayerSlot(),
          _buildAddPlayerSlot(),
        ],
      ),
    );
  }

  Widget _buildAddPlayerSlot() {
    return GestureDetector(
      onTap: (){
        Get.bottomSheet(
          AddPlayerBottomSheet(),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );

      },
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.whiteColor,
              border: Border.all(color: AppColors.primaryColor),
            ),
            child: const Icon(
              Icons.add,
              size: 24,
              color: AppColors.primaryColor,
            ),
          ),
          Container(
            color: Colors.transparent,
            width: Get.width * 0.13,
            child: Text(
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              "Available",
              style: Get.textTheme.bodySmall!.copyWith(
                color: AppColors.primaryColor,
                fontSize: 11,
              ),
            ).paddingOnly(top: Get.height * 0.003),
          ),
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
          width: Get.width,
          margin: const EdgeInsets.symmetric(horizontal: 0),
          padding: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    ...controller.sets.map((set) {
                      final int index = controller.sets.indexOf(set);
                      final bool isExpanded = controller.expandedSetIndex.value == index;

                      return ExpansionTile(
                        key: Key(index.toString()),
                        initiallyExpanded: isExpanded,
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        trailing: const SizedBox.shrink(),
                        minTileHeight: 30,
                        title: Transform.translate(
                          offset: Offset(15,0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.remove, color: Colors.black54, size: 16),
                              Row(
                                children: [
                                  Text(
                                    "Set ${set["set"]}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: Colors.black54,
                                    size: 16,
                                  ),
                                ],
                              ),
                              const Icon(Icons.remove, color: Colors.black54, size: 16),
                            ],
                          ),
                        ),
                        onExpansionChanged: (expanded) {
                          controller.toggleSetExpansion(index);
                        },
                        children: [
                          _buildScoreTable(set),
                        ],
                      );
                    }),
                    const SizedBox(height: 10),

                    // Show only if less than 8 sets
                    if (controller.sets.length < 8)
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
                  ],
                ),
              ),
              Divider(color: AppColors.greyColor,height: 0.1,),
              _buildMatchSummary()
            ],
          ),
        ),
      );
    });
  }
  Widget _buildScoreTable(Map<String, dynamic> set) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: Colors.grey.shade300),
          columnWidths: const {
            0: FixedColumnWidth(70),
            1: FlexColumnWidth(),
            2: FlexColumnWidth(),
            3: FlexColumnWidth(),
            4: FlexColumnWidth(),
            5: FlexColumnWidth(),
            6: FlexColumnWidth(),
          },
          children: [
            // Header Row
             TableRow(
              // decoration: BoxDecoration(color: Color(0xFFF5F6FA)),
              children: [
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Text('Set',style: Get.textTheme.labelLarge!.copyWith(color: AppColors.textColor), textAlign: TextAlign.center),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Text('R1',style: Get.textTheme.labelLarge!.copyWith(color: AppColors.textColor), textAlign: TextAlign.center),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Text('R2',style: Get.textTheme.labelLarge!.copyWith(color: AppColors.textColor), textAlign: TextAlign.center),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Text('R3',style: Get.textTheme.labelLarge!.copyWith(color: AppColors.textColor), textAlign: TextAlign.center),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Text('R4',style: Get.textTheme.labelLarge!.copyWith(color: AppColors.textColor), textAlign: TextAlign.center),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Text('R5',style: Get.textTheme.labelLarge!.copyWith(color: AppColors.textColor), textAlign: TextAlign.center),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Text('R6',style: Get.textTheme.labelLarge!.copyWith(color: AppColors.textColor), textAlign: TextAlign.center),
                ),
              ],
            ),
            // Team A row
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(6),
                  child: Text('Team A', textAlign: TextAlign.center),
                ),
                ...List.generate(6, (i) {
                  return const Padding(
                    padding: EdgeInsets.all(6),
                    child: Text('W',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green)),
                  );
                }),
              ],
            ),
            // Team B row
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(6),
                  child: Text('Team B', textAlign: TextAlign.center),
                ),
                ...List.generate(6, (i) {
                  return const Padding(
                    padding: EdgeInsets.all(6),
                    child: Text('-',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey)),
                  );
                }),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text(
              "High Score: Team A (3:2)",
              style: Get.textTheme.bodySmall,
            ),
            Container(
              alignment: AlignmentGeometry.center,
              height: 25,padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(5),

              ),
              child: const Text(
                "+ Add Score",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

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
