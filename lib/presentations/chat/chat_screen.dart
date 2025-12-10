import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';

import 'chat_controller.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController(), permanent: true);
    
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        resizeToAvoidBottomInset: true,
        appBar: _buildAppBar(controller),
        body: Column(
          children: [
            Expanded(
              child: Obx(() => Stack(
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollStartNotification) {
                        controller.onScrollStart();
                      } else if (notification is ScrollEndNotification) {
                        controller.onScrollEnd();
                      } else if (notification is ScrollUpdateNotification) {
                        controller.updateCurrentScrollDate();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.only(left: 16,right: 16),
                      itemCount: controller.groupedMessages.length,
                      itemBuilder: (context, index) {
                        final item = controller.groupedMessages[index];
                        
                        if (item['isDateHeader'] == true) {
                          return _buildDateHeader(item['dateText']);
                        }
                         
                        if (item['isGroupCreated'] == true) {
                          return _buildGroupCreatedMessage(
                            item['message'],
                            item['timestamp'],
                          );
                        }
                        
                        return item['isMe']
                            ? _buildSentMessage(
                                item['message'],
                                item['team'],
                                item['timestamp'],
                                item['readBy'],
                              )
                            : _buildReceivedMessage(
                                item['message'],
                                item['sender'],
                                item['team'],
                                item['timestamp'],
                                item['readBy'],
                              );
                      },
                    ),
                  ),
                  if (controller.showDateHeader.value)
                    Positioned(
                      top: 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            controller.currentDateHeader,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
                  child: _buildMessageInput(controller,context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Return initials from a full name.
  /// e.g. "Sanjay Bhandari" -> "SB", "Sanjay" -> "S"
  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    final first = parts.first.substring(0, 1).toUpperCase();
    final last = parts.last.substring(0, 1).toUpperCase();
    return '$first$last';
  }



  PreferredSizeWidget _buildAppBar(ChatController controller) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue,
                child: Icon(Icons.group, color: Colors.white),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Obx(() => Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: controller.isConnected.value ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                )),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Padel Squad - Open Match',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Obx(() {
                if (!controller.isConnected.value) {
                  return const Text(
                    'Connecting...',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  );
                }

                final players = controller.formattedPlayersForTitle;

                if (players.length == 1) {
                  return const Text(
                    'You',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  );
                }

                final playerNames = players.join(', ');
                return Container(
                  color: Colors.transparent,
                  width: Get.width*0.65,
                  child: Text(
                    playerNames,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(ChatController controller,BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 5,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 5 : 10,
      ),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              onTap: controller.onTextFieldFocus,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                fillColor: const Color(0xFFF1F1F1),
                filled: true,
              ),
              onSubmitted: (_) => controller.sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: controller.sendMessage,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.secondaryColor,
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSentMessage(String message, String team, String time, [List<String>? readBy]) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (team.isNotEmpty) ...[
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                //   decoration: BoxDecoration(
                //     color: team == "Team A" ? Colors.red.shade100 : Colors.blue.shade100,
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Text(
                //     team,
                //     style: TextStyle(
                //       fontSize: 10,
                //       fontWeight: FontWeight.w600,
                //       color: team == "Team A" ? Colors.red.shade700 : Colors.blue.shade700,
                //     ),
                //   ),
                // ),
                const SizedBox(width: 8),
              ],
              Text(
                "You",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            margin: const EdgeInsets.only(left: 50),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(14).copyWith(
                topRight: const Radius.circular(0),  // bubble tail
              ),),
            child: IntrinsicWidth(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  SizedBox(width: 6,),
                  Transform.translate(
                    offset: Offset(0, 4),
                    child: Text(
                      time,
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (readBy != null && readBy.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 14),
              child: Text(
                'Seen by: ${readBy.join(', ')}',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(String dateText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            dateText,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupCreatedMessage(String message, String timestamp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.yellow.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.group_add, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                '$message • $timestamp',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceivedMessage(
      String message, String playerName, String team, String time, [List<String>? readBy]) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blueGrey.shade100,
                child: Text(
                  _getInitials(playerName),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          playerName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        //   decoration: BoxDecoration(
                        //     color: team == "Team A" ? Colors.red.shade100 : Colors.blue.shade100,
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   child: Text(
                        //     team,
                        //     style: TextStyle(
                        //       fontSize: 10,
                        //       fontWeight: FontWeight.w600,
                        //       color: team == "Team A" ? Colors.red.shade700 : Colors.blue.shade700,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(14).copyWith(
                          topLeft: const Radius.circular(0),  // bubble tail
                        ),),
                      child: IntrinsicWidth(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                message,
                                style: const TextStyle(color: Colors.black87, fontSize: 14),
                              ),
                            ),
                            SizedBox(width: 6,),
                            Transform.translate(
                              offset: Offset(0, 4),
                              child: Text(
                                time,
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (readBy != null && readBy.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 14),
                        child: Text(
                          'Seen by: ${readBy.join(', ')}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}