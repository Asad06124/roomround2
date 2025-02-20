import '../employee/employee_model.dart';

class ChatViewModel {
  final String lastMessage;
  final int unreadCount;

  ChatViewModel({
    required this.lastMessage,
    required this.unreadCount,
  });
}

class EmployeeWithLiveChat {
  final Employee employee;
  final Stream<String> lastMessageStream;
  final Stream<int> unreadCountStream;

  EmployeeWithLiveChat({
    required this.employee,
    required this.lastMessageStream,
    required this.unreadCountStream,
  });
}

class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String type;
  final String content;
  final String? imageUrl;
  final bool isDelivered;
  final bool isSeen;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.content,
    this.imageUrl,
    this.isDelivered = false,
    this.isSeen = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'type': type,
      'content': content,
      'imageUrl': imageUrl,
      'isDelivered': isDelivered,
      'isSeen': isSeen,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static ChatMessage fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      type: json['type'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      isDelivered: json['isDelivered'] ?? false,
      isSeen: json['isSeen'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
