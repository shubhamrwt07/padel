import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'chat_controller.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());
    
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: _buildAppBar(controller),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final message = controller.messages[index];
                return message['isMe']
                    ? _buildSentMessage(
                        message['message'],
                        message['team'],
                        message['timestamp'],
                      )
                    : _buildReceivedMessage(
                        message['message'],
                        message['sender'],
                        message['team'],
                        message['timestamp'],
                        'https://randomuser.me/api/portraits/men/32.jpg',
                      );
              },
            )),
          ),
          _buildMessageInput(controller),
        ],
      ),
    );
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
                'Padel Squad',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Obx(() => Text(
                controller.isConnected.value ? '4 players online' : 'Connecting...',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(ChatController controller) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
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
            ).paddingOnly(bottom: 10),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: controller.sendMessage,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFF4DA6FF),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ).paddingOnly(bottom: 10),
          ),
        ],
      ),
    );
  }


  Widget _buildSentMessage(String message, String team, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: team == "Team A" ? Colors.red.shade100 : Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                team,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: team == "Team A" ? Colors.red.shade700 : Colors.blue.shade700,
                ),
              ),
            ),
            const SizedBox(width: 8),
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, right: 4),
          child: Text(
            time,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildReceivedMessage(String message, String playerName, String team, String time, String avatarUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(avatarUrl),
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: team == "Team A" ? Colors.red.shade100 : Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          team,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: team == "Team A" ? Colors.red.shade700 : Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 40),
          child: Text(
            time,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}