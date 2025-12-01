import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:padel_mobile/core/network/dio_client.dart';
import 'package:padel_mobile/handler/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatController extends GetxController {
  late IO.Socket socket;
  final TextEditingController messageController = TextEditingController();
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxBool isConnected = false.obs;
  // Always treat userId as String so comparison with senderId works reliably
  final String userId = storage.read("userId").toString();
  final String roomId = 'padel_room_1';
   var matchId = ''.obs;
   // If your backend uses different keys, adjust the mapping in
   // `_handleMessages` and `_handleNewMessage` accordingly.

  @override
  void onInit() {
    super.onInit();
    final matchID = Get.arguments['matchID'];
    matchId.value = matchID;
    print("matchID-> ${matchId.value}");
    connectSocket();
  }

  void connectSocket() {
    socket = IO.io(
      'http://192.168.0.129:5070',
      IO.OptionBuilder()
          // Start with default transports like the JS client; add websocket-only later if needed
           .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'userId': userId})
          .build(),
    );

    socket.connect();

    // Log all incoming events to understand what the backend is sending
    socket.onAny((event, data) {
      CustomLogger.logMessage(
        msg: '🔔 Socket event: $event -> $data',
        level: LogLevel.info,
      );
    });

    socket.on('connect', (_) {
      CustomLogger.logMessage(
          msg: '✅ Socket connected successfully', level: LogLevel.info);
      isConnected.value = true;
      // Join the match once connected
      socket.emit('joinMatch', matchId.value);
      // Fetch existing messages for this match
      getMessages();
      print(getMessages());
    });

    // Handle initial list of messages for this match
    // Your backend emits `messagesReceived`, not `messages`
    socket.on('messagesReceived', _handleMessages);

    // Handle new incoming single message (when someone sends a message)
    socket.on('newMessage', _handleNewMessage);

    socket.on('disconnect', (reason) {
      CustomLogger.logMessage(
          msg: '❌ Socket disconnected: $reason', level: LogLevel.error);
      isConnected.value = false;
    });

    socket.on('connect_error', (error) {
      print('🔥 Connection error: $error');
      isConnected.value = false;
    });

    socket.on('error', (error) {
      print('🔥 Socket error: $error');
    });

  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;
    socket.emit('sendMessage', {
      'matchId': matchId.value,
      'message': messageController.text.trim()
    });

    // Optionally append the message locally so it shows immediately.
    // You can remove this if your backend echoes the message back via `newMessage`.
    messages.add({
      'isMe': true,
      'message': messageController.text.trim(),
      'team': '', // fill if you have team info locally
      'sender': 'You',
      'timestamp': TimeOfDay.now().format(Get.context!),
    });

    messageController.clear();
  }
  Future<void> getMessages() async {

    socket.emit('getMessages', {

      'matchId': matchId.value,
    });

    // Just to confirm the request was fired
    CustomLogger.logMessage(
      msg: '📤 getMessages emitted for matchId=${matchId.value}',
      level: LogLevel.info,
    );

  }

  /// Map the list of messages received from the backend into the UI model.
  /// Adjust the keys below (`text`, `team`, `senderName`, `createdAt`, `userId`)
  /// to match your actual API / socket payload.
  void _handleMessages(dynamic data) {
    try {
      CustomLogger.logMessage(
        msg: '📨 _handleMessages raw payload (${data.runtimeType}): $data',
        level: LogLevel.info,
      );

      // Support multiple possible payload shapes:
      // 1) data is already a List
      // 2) { "messages": [...] }
      // 3) { "data": [...] }
      // 4) anything else -> just log and return
      List<dynamic> rawList;
      if (data is List) {
        rawList = data;
      } else if (data is Map && data['messages'] is List) {
        rawList = data['messages'] as List;
      } else if (data is Map && data['data'] is List) {
        rawList = data['data'] as List;
      } else {
        CustomLogger.logMessage(
          msg: '⚠️ _handleMessages received unsupported format: $data',
          level: LogLevel.error,
        );
        return;
      }

      final mapped = rawList.map<Map<String, dynamic>>((m) {
        final map = Map<String, dynamic>.from(m as Map);

        // Sender can be:
        // - a plain id:  senderId: "abc"
        // - an object:   senderId: { _id: "...", name: "...", lastName: "..." }
        final dynamic senderField =
            map['senderId'] ?? map['userId'] ?? map['senderid'];
        String senderId;
        if (senderField is Map && senderField['_id'] != null) {
          senderId = senderField['_id'].toString();
        } else {
          senderId = (senderField ?? '').toString();
        }

        final String senderNameFromObject = senderField is Map
            ? [
                senderField['name']?.toString() ?? '',
                senderField['lastName']?.toString() ?? ''
              ].where((e) => e.isNotEmpty).join(' ')
            : '';

        return {
          'isMe': senderId == userId,
          // Backend example uses `message` for text
          'message': map['message'] ?? map['text'] ?? '',
          // Backend example uses `senderTeam`
          'team': map['senderTeam'] ?? map['team'] ?? '',
          // Prefer explicit senderName, then build from senderId object, then fallback
          'sender': map['senderName'] ??
              senderNameFromObject ??
              map['playerName'] ??
              'Player',
          // Backend example uses `createdAt`
          'timestamp': map['createdAt'] ?? map['time'] ?? '',
        };
      }).toList();

      messages.assignAll(mapped);

      // PRINT / LOG ALL MESSAGES AFTER MAPPING
      CustomLogger.logMessage(
        msg: '✅ Mapped messages (${messages.length}): $messages',
        level: LogLevel.info,
      );
    } catch (e) {
      CustomLogger.logMessage(
        msg: '❌ Error parsing messages: $e',
        level: LogLevel.error,
      );
    }
  }

  /// Handle a single new message pushed from the backend.
  void _handleNewMessage(dynamic data) {
    try {
      final map = Map<String, dynamic>.from(
          data is Map ? data : (data['message'] as Map));
      // Handle both flat and nested senderId (same as in _handleMessages)
      final dynamic senderField =
          map['senderId'] ?? map['userId'] ?? map['senderid'] ?? map['fromUserId'];
      String senderId;
      if (senderField is Map && senderField['_id'] != null) {
        senderId = senderField['_id'].toString();
      } else {
        senderId = (senderField ?? '').toString();
      }

      final String senderNameFromObject = senderField is Map
          ? [
              senderField['name']?.toString() ?? '',
              senderField['lastName']?.toString() ?? ''
            ].where((e) => e.isNotEmpty).join(' ')
          : '';

      // If this is **our** own message coming back from the server,
      // we already added it optimistically in `sendMessage()`.
      // Skip adding again to avoid showing the same text on both sides.
      if (senderId == userId) {
        return;
      }

      messages.add({
        'isMe': senderId == userId,
        'message': map['message'] ?? map['text'] ?? '',
        'team': map['senderTeam'] ?? map['team'] ?? '',
        'sender': map['senderName'] ??
            senderNameFromObject ??
            map['playerName'] ??
            'Player',
        'timestamp': map['createdAt'] ?? map['time'] ?? '',
      });
    } catch (e) {
      CustomLogger.logMessage(
        msg: '❌ Error parsing newMessage: $e',
        level: LogLevel.error,
      );
    }
  }

  @override
  void onClose() {
    socket.disconnect();
    messageController.dispose();
    super.onClose();
  }
}