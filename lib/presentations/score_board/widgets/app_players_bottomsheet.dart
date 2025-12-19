import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/primary_text_feild.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';

import '../../../repositories/openmatches/open_match_repository.dart';

class AppPlayersController extends GetxController {
  RxList<Map<String, dynamic>> nearbyPlayers = <Map<String, dynamic>>[].obs;
  RxBool isLoadingNearbyPlayers = false.obs;
  RxString requestingPlayerId = ''.obs;
  final OpenMatchRepository repository = OpenMatchRepository();

  Future<void> fetchNearByPlayers() async {
    try {
      isLoadingNearbyPlayers.value = true;
      nearbyPlayers.clear();
      
      final response = await repository.findNearByPlayer();
      if(response.status == 200 && response.players != null){
        nearbyPlayers.value = response.players!.map((player) => {
          'id': player.id ?? '',
          'name': player.name ?? '',
          'profilePic': player.profilePic ?? '',
          'city': player.city ?? '',
          'level': player.level ?? '',
        }).toList();
      }
    } catch (e) {
      isLoadingNearbyPlayers.value = false;
    } finally {
      isLoadingNearbyPlayers.value = false;
    }
  }
}

class AppPlayersBottomSheet extends StatelessWidget {
  final String matchId;
  final String teamName;
  
  AppPlayersBottomSheet({super.key, required this.matchId, required this.teamName});
  
  final AppPlayersController controller = Get.put(AppPlayersController());

  @override
  Widget build(BuildContext context) {
    controller.fetchNearByPlayers();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            PrimaryTextField(
              hintStyle: Get.textTheme.headlineSmall!.copyWith(color: AppColors.textColor),
              suffixIcon: Icon(Icons.search, color: AppColors.textColor),
              hintText: 'Search by Name / Phone number',
            ),
            const SizedBox(height: 8),
            Text(
              'Nearby & match your level',
              style: Get.textTheme.labelLarge,
            ),
            const SizedBox(height: 12),
            _playersList(),
            const SizedBox(height: 12),
            _actionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'App Players',
          style: Get.textTheme.headlineMedium,
        ),
        Transform.translate(
          offset: Offset(8, 0),
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Get.back(),
          ),
        ),
      ],
    );
  }

  Widget _playersList() {
    return Obx(() {
      if (controller.isLoadingNearbyPlayers.value) {
        return const SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      
      if (controller.nearbyPlayers.isEmpty) {
        return SizedBox(
          height: 100,
          child: Center(
            child: Text(
              'No nearby players found',
              style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
            ),
          ),
        );
      }
      
      final itemCount = controller.nearbyPlayers.length;
      final displayCount = itemCount > 5 ? 5 : itemCount;
      final itemHeight = 60.0;
      final listHeight = displayCount * itemHeight + (displayCount - 1) * 1;
      
      return SizedBox(
        height: listHeight,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: itemCount,
          separatorBuilder: (_, __) => Divider(
            color: AppColors.primaryColor.withValues(alpha: 0.1),
          ),
          itemBuilder: (_, i) {
            final player = controller.nearbyPlayers[i];
            final isRequested = false;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                    child: (player['profilePic']?.isNotEmpty == true)
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: player['profilePic'],
                              fit: BoxFit.cover,
                              width: 44,
                              height: 44,
                              placeholder: (context, url) => Text(
                                '${player['name']?[0] ?? ''}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              errorWidget: (context, url, error) => Text(
                                '${player['name']?[0] ?? ''}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          )
                        : Text(
                            '${player['name']?[0] ?? ''}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player['name'] ?? '',
                          style: Get.textTheme.labelLarge,
                        ),
                        Text(
                          player['city'] ?? '',
                          style: Get.textTheme.bodySmall?.copyWith(
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: isRequested ? null : () {
                      // Handle send request
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isRequested
                            ? AppColors.greyColor.withOpacity(0.3)
                            : AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isRequested ? 'Requested' : 'Send Request',
                        style: Get.textTheme.labelSmall?.copyWith(
                          color: isRequested
                              ? AppColors.darkGrey
                              : AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget _actionButtons() {
    final style = Get.textTheme.labelLarge!.copyWith(color: Colors.white);
    return Column(
      children: [
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(40),
            side: const BorderSide(color: Colors.green),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Invite Player',
            style: Get.textTheme.labelLarge!.copyWith(color: AppColors.secondaryColor),
          ),
        ),
        const SizedBox(height: 4),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(40),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text('Invite Player through whatsapp', style: style),
        ),
        const SizedBox(height: 4),
        ElevatedButton(
          onPressed: () {
            Get.toNamed(
              RoutesName.addPlayer,
              arguments: {
                "team": teamName,
                "matchId": matchId,
                "needAsGuest": true,
                "scoreBoardId": matchId,
              },
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(40),
            backgroundColor: const Color(0xff2D3EBE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text('Add Guest  →', style: style),
        ),
      ],
    );
  }
}