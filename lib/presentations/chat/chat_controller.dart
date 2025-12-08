import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:padel_mobile/core/network/dio_client.dart';
import 'package:padel_mobile/handler/logger.dart';
import 'package:padel_mobile/core/endpoitns.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatController extends GetxController {
  static IO.Socket? _sharedSocket;
  IO.Socket get socket => _sharedSocket!;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxBool isConnected = false.obs;
  final RxBool showDateHeader = false.obs;
  final RxString currentScrollDate = ''.obs;
  final RxList<String> connectedPlayers = <String>[].obs;

  
  // Static cache to persist messages across controller recreations
  static final Map<String, List<Map<String, dynamic>>> _messageCache = {};
  
  /// Clear static message cache (used during logout)
  static void clearMessageCache() {
    _messageCache.clear();
  }
  
  /// Disconnect shared socket (used during logout)
  static void disconnectSharedSocket() {
    if (_sharedSocket != null) {
      _sharedSocket!.disconnect();
      _sharedSocket = null;
    }
  }

  /// Get unique player names from messages as fallback (excluding current user)
  List<String> get playersFromMessages {
    final uniquePlayers = <String>{};
    for (final message in messages) {
      final sender = message['sender']?.toString();
      final isCurrentUser = message['isMe'] == true;
      
      if (sender != null && sender.isNotEmpty && !isCurrentUser) {
        uniquePlayers.add(sender);
      }
    }
    
    return uniquePlayers.take(4).toList();
  }

  /// Get formatted player names with "You" at the front for display in title
  List<String> get formattedPlayersForTitle {
    final players = connectedPlayers.isNotEmpty 
        ? connectedPlayers 
        : playersFromMessages;
    
    final result = <String>['You'];
    result.addAll(players.take(3));
    return result;
  }
  // Always treat userId as String so comparison with senderId works reliably.
  // Use a getter so that after logout/login the latest value from storage is used.
  String get userId => storage.read("userId")?.toString() ?? '';
  String get userTeam {
    final team = storage.read("userTeam") ?? 
                 storage.read("team") ?? 
                 Get.arguments?['userTeam'] ?? 
                 Get.arguments?['team'] ?? 
                 '';
    CustomLogger.logMessage(msg: 'DEBUG: userTeam = $team',level: LogLevel.debug);
    return _normalizeTeam(team);
  }
  var matchId = ''.obs;
  var matchCreatedAt = DateTime.now().obs;
  // If your backend uses different keys, adjust the mapping in
  // `_handleMessages` and `_handleNewMessage` accordingly.

  /// Convert a full name into title case.
  /// e.g. "sanjay bhandari" / "SANJAY BHANDARI" -> "Sanjay Bhandari"
  String _toTitleCase(String? value) {
    if (value == null) return '';
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';

    final parts = trimmed.split(RegExp(r'\s+'));
    final capitalized = parts.map((word) {
      if (word.isEmpty) return '';
      if (word.length == 1) return word.toUpperCase();
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).where((w) => w.isNotEmpty).join(' ');

    return capitalized;
  }

  /// Normalize team code coming from backend (e.g. "teamA") into a
  /// user‑friendly label used by the UI (e.g. "Team A").
  String _normalizeTeam(dynamic rawTeam) {
    final value = rawTeam?.toString().trim();
    if (value == null || value.isEmpty) return '';

    final lower = value.toLowerCase();
    switch (lower) {
      case 'teama':
      case 'team a':
        return 'Team A';
      case 'teamb':
      case 'team b':
        return 'Team B';
      default:
        return value; // fallback to original
    }
  }

  /// Format any incoming timestamp to a time-only string like "2:00pm".
  /// - Accepts `DateTime`, ISO string, or raw string.
  /// - Falls back gracefully to the original value if parsing fails.
  String _formatTimestamp(dynamic raw) {
    try {
      DateTime? dt;

      if (raw is DateTime) {
        dt = raw;
      } else if (raw is String && raw.isNotEmpty) {
        // Try to parse ISO / standard datetime strings
        dt = DateTime.tryParse(raw);
      }

      if (dt == null) {
        // If we can't parse, just return the original string (or empty)
        return raw?.toString() ?? '';
      }

      // Convert to a 12-hour format like "2:05pm"
      final int hour = dt.hour;
      final int minute = dt.minute;
      final int hourOfPeriod =
          hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      final String minuteStr = minute.toString().padLeft(2, '0');
      final String period = hour >= 12 ? 'pm' : 'am';
      return '$hourOfPeriod:$minuteStr$period';
    } catch (_) {
      return raw?.toString() ?? '';
    }
  }

  /// Parse timestamp and return DateTime object for date grouping
  DateTime? _parseDateTime(dynamic raw) {
    try {
      if (raw is DateTime) {
        return raw;
      } else if (raw is String && raw.isNotEmpty) {
        return DateTime.tryParse(raw);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Format date for chat headers like WhatsApp (Today, Yesterday, or date)
  String formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year.toString().substring(2)}';
    }
  }

  /// Get messages grouped by date
  List<Map<String, dynamic>> get groupedMessages {
    final grouped = <Map<String, dynamic>>[];
    
    if (messages.isEmpty) {
      // Add group creation message when no messages exist
      final creationDate = matchCreatedAt.value;
      grouped.add({
        'isDateHeader': true,
        'dateText': formatDateHeader(creationDate),
        'dateTime': creationDate,
      });
      grouped.add({
        'isGroupCreated': true,
        'message': 'Group created',
        'timestamp': _formatTimestamp(creationDate),
        'dateTime': creationDate,
        'isDateHeader': false,
      });
      return grouped;
    }
    
    String? lastDateStr;
    
    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];
      final messageDate = message['dateTime'] as DateTime? ?? DateTime.now();
      final dateStr = formatDateHeader(messageDate);
      
      // Add date header if this is a new date
      if (lastDateStr != dateStr) {
        grouped.add({
          'isDateHeader': true,
          'dateText': dateStr,
          'dateTime': messageDate,
        });
        lastDateStr = dateStr;
      }
      
      // Add the actual message
      grouped.add({...message, 'isDateHeader': false});
    }
    
    return grouped;
  }

  /// Get current date header for scroll display
  String get currentDateHeader {
    return currentScrollDate.value.isNotEmpty 
        ? currentScrollDate.value 
        : formatDateHeader(DateTime.now());
  }

  @override
  void onInit() {
    super.onInit();
    final matchID = Get.arguments['matchID'];
    matchId.value = matchID;
    
    // Set match creation date from arguments or use current time
    final createdAt = Get.arguments['createdAt'];
    if (createdAt != null) {
      matchCreatedAt.value = _parseDateTime(createdAt) ?? DateTime.now();
    }
    
    // Load cached messages if available
    if (_messageCache.containsKey(matchID)) {
      messages.assignAll(_messageCache[matchID]!);
      // Auto-scroll to bottom after loading cached messages
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBottom();
      });
    }
    
    CustomLogger.logMessage(msg: "matchID-> ${matchId.value}",level: LogLevel.debug);
    CustomLogger.logMessage(msg: "UserID-> ${storage.read("userId")}",level: LogLevel.debug);
    CustomLogger.logMessage(msg: "UserTeam-> $userTeam",level: LogLevel.debug);
    CustomLogger.logMessage(msg: "Arguments-> ${Get.arguments}",level: LogLevel.debug);
    _setupScrollListener();
    connectSocket();
  }

  @override
  void onReady() {
    super.onReady();
    // Mark messages as read when the chat screen is fully loaded and visible
    Future.delayed(const Duration(milliseconds: 1500), () {
      markAllMessagesAsRead();
    });
  }

  /// Mark all messages as read for this match
  void markAllMessagesAsRead() {
    if (socket.connected && matchId.value.isNotEmpty) {
      socket.emit('markMessageRead', {'matchId': matchId.value});
      CustomLogger.logMessage(
        msg: '📖 Marked all messages as read for match: ${matchId.value}',
        level: LogLevel.info,
      );
    } else {
      CustomLogger.logMessage(
        msg: '⚠️ Cannot mark messages as read - socket not connected or matchId empty',
        level: LogLevel.warning,
      );
      // Retry after a short delay if socket not connected yet
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (socket.connected && matchId.value.isNotEmpty) {
          socket.emit('markMessageRead', {'matchId': matchId.value});
          CustomLogger.logMessage(
            msg: '📖 Marked all messages as read for match: ${matchId.value} (retry)',
            level: LogLevel.info,
          );
        }
      });
    }
  }

  void _setupScrollListener() {
    // This will be handled by NotificationListener in the UI
  }

  void onScrollStart() {
    showDateHeader.value = true;
    updateCurrentScrollDate();
    // Mark messages as read when user scrolls (indicating they're viewing)
    markAllMessagesAsRead();
  }

  void onScrollEnd() {
    Future.delayed(const Duration(seconds: 2), () {
      showDateHeader.value = false;
    });
  }

  void updateCurrentScrollDate() {
    if (!scrollController.hasClients || messages.isEmpty) return;
    
    // Find the message at current scroll position
    final scrollOffset = scrollController.offset;
    final itemHeight = 80.0; // Approximate message height
    final visibleIndex = (scrollOffset / itemHeight).floor();
    
    if (visibleIndex >= 0 && visibleIndex < messages.length) {
      final message = messages[visibleIndex];
      final messageDate = message['dateTime'] as DateTime? ?? DateTime.now();
      currentScrollDate.value = formatDateHeader(messageDate);
    }
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (scrollController.hasClients && scrollController.position.maxScrollExtent > 0) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent + 100,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  // /// Mark individual message as read
  // void markMessageAsRead(String messageId) {
  //   if (socket.connected && messageId.isNotEmpty) {
  //     socket.emit('markMessageRead', {'messageId': messageId});
  //   }
  // }

  void onTextFieldFocus() {
    if (scrollController.hasClients && scrollController.position.maxScrollExtent > 0) {
      final isAtBottom = scrollController.position.pixels >= 
          scrollController.position.maxScrollExtent - 50;
      if (isAtBottom) {
        Future.delayed(const Duration(milliseconds: 300), () {
          scrollToBottom();
        });
      }
    }
  }

  void connectSocket() {
    // Reuse existing socket if connected
    if (_sharedSocket != null && _sharedSocket!.connected) {
      CustomLogger.logMessage(msg: "♻️ Reusing existing socket connection", level: LogLevel.info);
      isConnected.value = true;
      // Join the match and get messages
      _sharedSocket!.emit('joinMatch', matchId.value);
      _sharedSocket!.emit('getConnectedPlayers', {'matchId': matchId.value});
      if (messages.isEmpty) {
        getMessages();
      }
      return;
    }
    
    _sharedSocket = IO.io(
      AppEndpoints.SOCKET_URL,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'userId': userId})
          .build(),
    );
    CustomLogger.logMessage(msg: "USER ID_ CONNECT_> $userId",level: LogLevel.debug);
    _sharedSocket!.connect();

    // Log all incoming events to understand what the backend is sending
    _sharedSocket!.onAny((event, data) {
      CustomLogger.logMessage(
        msg: '🔔 Socket event: $event -> $data',
        level: LogLevel.info,
      );
    });

    _sharedSocket!.on('connect', (_) {
      CustomLogger.logMessage(
          msg: '✅ Socket connected successfully', level: LogLevel.info);
      isConnected.value = true;
      // Join the match once connected
      _sharedSocket!.emit('joinMatch', matchId.value);
      // Request connected players
      _sharedSocket!.emit('getConnectedPlayers', {'matchId': matchId.value});
      // Fetch existing messages only if not already loaded
      if (messages.isEmpty) {
        getMessages();
      }
    });

    // Handle initial list of messages for this match
    // Your backend emits `messagesReceived`, not `messages`
    _sharedSocket!.on('messagesReceived', _handleMessages);

    // Handle new incoming single message (when someone sends a message)
    _sharedSocket!.on('newMessage', _handleNewMessage);

    // Handle connected players updates
    _sharedSocket!.on('playersUpdate', _handlePlayersUpdate);

    _sharedSocket!.on('disconnect', (reason) {
      CustomLogger.logMessage(
          msg: '❌ Socket disconnected: $reason', level: LogLevel.error);
      isConnected.value = false;
    });

    _sharedSocket!.on('connect_error', (error) {
      CustomLogger.logMessage(msg: '🔥 Connection error: $error',level: LogLevel.debug);
      isConnected.value = false;
    });

    _sharedSocket!.on('error', (error) {
      CustomLogger.logMessage(msg: '🔥 Socket error: $error',level: LogLevel.debug);
    });

  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;
    
    // Mark all messages as read when user sends a message
    markAllMessagesAsRead();
    
    socket.emit('sendMessage', {
      'matchId': matchId.value,
      'message': messageController.text.trim()
    });

    // Optionally append the message locally so it shows immediately.
    // You can remove this if your backend echoes the message back via `newMessage`.
    final now = DateTime.now();
    final newMessage = {
      'isMe': true,
      'message': messageController.text.trim(),
      'team': userTeam,
      'sender': 'You',
      'timestamp': _formatTimestamp(now),
      'dateTime': now,
    };
    
    messages.add(newMessage);
    // Update cache
    _messageCache[matchId.value] = List.from(messages);

    messageController.clear();
    
    // Only scroll if content exceeds screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });
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

        final rawSenderName = map['senderName'] ??
            senderNameFromObject ??
            map['playerName'] ??
            'Player';

        final rawTimestamp = map['createdAt'] ?? map['time'] ?? '';
        final dateTime = _parseDateTime(rawTimestamp) ?? DateTime.now();
        
        final messageId = map['_id'] ?? map['id'];
        
        return {
          'isMe': senderId == userId,
          // Backend example uses `message` for text
          'message': map['message'] ?? map['text'] ?? '',
          // Normalize backend team code into UI label (e.g. "teamA" -> "Team A")
          'team': _normalizeTeam(map['senderTeam'] ?? map['team'] ?? ''),
          // Prefer explicit senderName, then build from senderId object, then fallback
          'sender': _toTitleCase(rawSenderName),
          // Backend example uses `createdAt` – format to time-only
          'timestamp': _formatTimestamp(rawTimestamp),
          'dateTime': dateTime,
          'messageId': messageId,
        };
      }).toList();

      // Load messages and update cache
      messages.assignAll(mapped);
      _messageCache[matchId.value] = List.from(mapped);

      
      // Update connected players from messages if backend doesn't provide them
      if (connectedPlayers.isEmpty) {
        connectedPlayers.assignAll(playersFromMessages);
      }
      
      // Auto-scroll to bottom after loading messages
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBottom();
        // Mark all loaded messages as read since user opened chat
        Future.delayed(const Duration(milliseconds: 1000), () {
          markAllMessagesAsRead();
        });
      });

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

      final rawSenderName = map['senderName'] ??
          senderNameFromObject ??
          map['playerName'] ??
          'Player';

      final senderName = _toTitleCase(rawSenderName);

      final rawTimestamp = map['createdAt'] ?? map['time'] ?? '';
      final dateTime = _parseDateTime(rawTimestamp) ?? DateTime.now();
      final messageId = map['_id'] ?? map['id'];

      final newMessage = {
        'isMe': senderId == userId,
        'message': map['message'] ?? map['text'] ?? '',
        'team': _normalizeTeam(map['senderTeam'] ?? map['team'] ?? ''),
        'sender': senderName,
        'timestamp': _formatTimestamp(rawTimestamp),
        'dateTime': dateTime,
        'messageId': messageId,
      };
      
      messages.add(newMessage);
      messages.refresh();
      // Update cache
      _messageCache[matchId.value] = List.from(messages);
      
      // Add new player to title if not already present
      if (senderName.isNotEmpty && !connectedPlayers.contains(senderName)) {
        connectedPlayers.add(senderName);
      }
      
      // Only scroll to bottom if user is already near bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          final isNearBottom = scrollController.position.pixels >= 
              scrollController.position.maxScrollExtent - 100;
          if (isNearBottom) {
            scrollToBottom();
          }
        }
      });
    } catch (e) {
      CustomLogger.logMessage(
        msg: '❌ Error parsing newMessage: $e',
        level: LogLevel.error,
      );
    }
  }

  /// Handle players update from backend
  void _handlePlayersUpdate(dynamic data) {
    try {
      CustomLogger.logMessage(
        msg: '📥 Received playersUpdate: $data',
        level: LogLevel.info,
      );
      
      if (data is Map && data['players'] is List) {
        final players = (data['players'] as List)
            .map((p) => _toTitleCase(p['name']?.toString() ?? 'Player'))
            .toList();
        connectedPlayers.assignAll(players);
      } else if (data is List) {
        final players = data
            .map((p) => _toTitleCase(p['name']?.toString() ?? 'Player'))
            .toList();
        connectedPlayers.assignAll(players);
      }
    } catch (e) {
      CustomLogger.logMessage(
        msg: '❌ Error parsing players update: $e',
        level: LogLevel.error,
      );
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}