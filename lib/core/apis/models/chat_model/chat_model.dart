import '../employee/employee_model.dart';

class ChatViewModel {
  final String lastMessage;
  final int unreadCount;

  ChatViewModel({
    required this.lastMessage,
    required this.unreadCount,
  });

  // Add copyWith method
  ChatViewModel copyWith({
    String? lastMessage,
    int? unreadCount,
  }) {
    return ChatViewModel(
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
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

  EmployeeWithLiveChat copyWith({
    Employee? employee,
    Stream<String>? lastMessageStream,
    Stream<int>? unreadCountStream,
  }) {
    return EmployeeWithLiveChat(
      employee: employee ?? this.employee,
      lastMessageStream: lastMessageStream ?? this.lastMessageStream,
      unreadCountStream: unreadCountStream ?? this.unreadCountStream,
    );
  }
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

  // Add copyWith method
  ChatMessage copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? receiverId,
    String? type,
    String? content,
    String? imageUrl, // Nullable, so no need for special handling
    bool? isDelivered,
    bool? isSeen,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      type: type ?? this.type,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      isDelivered: isDelivered ?? this.isDelivered,
      isSeen: isSeen ?? this.isSeen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
