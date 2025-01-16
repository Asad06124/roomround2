// import 'dart:io';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
// import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roomrounds/module/message/views/image_previewscreen.dart';

// import 'dart:io';

import '../../../core/apis/models/employee/employee_model.dart';
import '../../push_notification/push_notification.dart';

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
  // Core message fields
  final String id; // Unique message ID (Firestore Doc ID or UUID)
  final String
      chatId; // ID of the conversation (unique for sender and receiver)
  final String senderId; // Sender's user ID
  final String receiverId; // Receiver's user ID
  final String type; // Message type: 'text' or 'image'
  final String content; // Message text or URL for the image
  final String? imageUrl; // Optional field for the image URL if type is 'image'

  // Message status
  final bool isDelivered; // True if the message was delivered to the receiver
  final bool isSeen; // True if the message was seen by the receiver

  // Timestamps
  final DateTime createdAt; // Message creation timestamp
  final DateTime updatedAt; // Timestamp for status updates

  // Constructor
  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.content,
    this.imageUrl, // Optional image URL
    this.isDelivered = false,
    this.isSeen = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to JSON (for Firestore or API usage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'type': type,
      'content': content,
      'imageUrl': imageUrl, // Include image URL in the JSON if it exists
      'isDelivered': isDelivered,
      'isSeen': isSeen,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create an instance from JSON
  static ChatMessage fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      type: json['type'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      // If imageUrl exists, it will be parsed
      isDelivered: json['isDelivered'] ?? false,
      isSeen: json['isSeen'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  OverlayPortalController overlayController = OverlayPortalController();
  final Map<String, String> _chatRoomIdCache = {};

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  TextEditingController messageController = TextEditingController();
  RxBool isLoading = false.obs;
  Rx<File?> selectedImageFile =
      Rx<File?>(null); // RxFile that holds a nullable File

  // Function to pick an image from the gallery
  Future<void> pickImageFromGallery(
      {required receiverId,
      required receiverImgUrl,
      required receiverDeviceToken,
      required name}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImageFile.value = File(image.path);
      update();
      Get.to(ImagePreviewScreen( receiverId: receiverId,
        receiverImgUrl: receiverImgUrl,
        receiverDeviceToken: receiverDeviceToken,
        name: name,), arguments: {
        receiverId: receiverId,
        receiverImgUrl: receiverImgUrl,
        receiverDeviceToken: receiverDeviceToken,
        name: name,
      });
    } else {
      print("No image selected.");
    }
  }

  Future<void> pickImageFromCamera(
      {required receiverId,
      required receiverImgUrl,
      required receiverDeviceToken,
      required name}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      selectedImageFile.value = File(image.path);

      update();
      Get.to(ImagePreviewScreen( receiverId: receiverId,
        receiverImgUrl: receiverImgUrl,
        receiverDeviceToken: receiverDeviceToken,
        name: name,), arguments: {
        receiverId: receiverId,
        receiverImgUrl: receiverImgUrl,
        receiverDeviceToken: receiverDeviceToken,
        name: name,
      });
    } else {
      print("No image captured.");
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}.jpg';

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://roomroundapis.rootpointers.net/api/Chats/UploadImage'),
      );

      // Add file to request
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      var multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: fileName,
        contentType: MediaType('image', 'jpeg'),
      );

      request.files.add(multipartFile);

      // Send request
      var response = await request.send();

      if (response.statusCode == 200) {
        // Parse response - the API returns just the image path
        final imagePath = await response.stream.bytesToString();

        // Remove any leading slash if present
        final cleanPath = imagePath.replaceAll(RegExp(r'^/+'), '');

        // Construct full image URL
        final imageUrl = 'http://roomroundapis.rootpointers.net/$cleanPath';
        return imageUrl;
      } else {
        final errorResponse = await response.stream.bytesToString();
        print(
            'Upload failed with status ${response.statusCode}: $errorResponse');
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Function to start a new chat
  Future<void> startNewChat(String otherUserId, String senderId) async {
    final chatRoomId = getChatRoomId(senderId, otherUserId);

    // Check if chat already exists
    final chatDoc =
        await _firestore.collection('chatrooms').doc(chatRoomId).get();

    if (!chatDoc.exists) {
      // Create new chat room
      await _firestore.collection('chatrooms').doc(chatRoomId).set({
        'participants': [senderId, otherUserId],
        'createdAt': Timestamp.now(),
        'lastMessage': null,
        'lastMessageTime': null,
      });
    }
  }

  // Function to update message status (delivered or seen)
  Future<void> updateMessageStatus(
      String messageId, bool isDelivered, bool isSeen) async {
    try {
      // Update message status in Firestore
      await _firestore.collection('chatrooms').doc(messageId).update({
        'isDelivered': isDelivered,
        'isSeen': isSeen,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      print("Error updating message status: $e");
    }
  }

  Stream<String> getLastMessageStream(String chatRoomId) {
    return _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return 'No messages yet';
      return snapshot.docs.first['content'] ?? '';
    });
  }

  Stream<int> getUnreadMessageCountStream(
      String chatRoomId, String currentUserId) {
    return _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('receiverId', isEqualTo: currentUserId)
        .where('isSeen', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<List<EmployeeWithLiveChat>> setupLiveChats(
      List<Employee> usersList, String currentUserId) async {
    List<EmployeeWithLiveChat> usersWithLiveChats = [];

    for (Employee employee in usersList) {
      String chatRoomId =
          getChatRoomId(currentUserId, employee.userId.toString());

      // Check if chat exists
      final chatDoc =
          await _firestore.collection('chatrooms').doc(chatRoomId).get();

      if (chatDoc.exists) {
        usersWithLiveChats.add(
          EmployeeWithLiveChat(
            employee: employee,
            lastMessageStream: getLastMessageStream(chatRoomId),
            unreadCountStream:
                getUnreadMessageCountStream(chatRoomId, currentUserId),
          ),
        );
      }
    }

    return usersWithLiveChats;
  }

  // Get all messages in the chat room
  Stream<List<ChatMessage>> getMessages(String otherUserId, String senderId) {
    String chatRoomId = getChatRoomId(senderId, otherUserId);

    return _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('createdAt', descending: false) // Fetch in ascending order
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            Map<String, dynamic> data = doc.data();
            return ChatMessage(
              id: doc.id,
              // Firestore document ID
              chatId: data['chatId'],
              senderId: data['senderId'],
              receiverId: data['receiverId'],
              type: data['type'],
              content: data['content'],
              imageUrl: data['imageUrl'],
              isDelivered: data['isDelivered'] ?? false,
              // Default to false if not set
              isSeen: data['isSeen'] ?? false,
              // Default to false if not set
              createdAt: DateTime.parse(data['createdAt']),
              updatedAt: DateTime.parse(data['updatedAt']),
            );
          })
          .toList()
          .reversed // Reverse the list before returning it
          .toList(); // Convert the reversed iterable back to a list
    });
  }

  Future<void> markMessagesAsSeen(String chatRoomId, String receiverId) async {
    final messagesRef = _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('senderId', isEqualTo: receiverId)
        .where('isSeen', isEqualTo: false);

    final snapshot = await messagesRef.get();

    // Using forEach without awaiting the updates
    for (var doc in snapshot.docs) {
      doc.reference.update({'isSeen': true, 'isDelivered': true});
    }
  }

  // Send a new message
  Future<void> sendMessage({
    required String receiverId,
    required String senderId,
    required String content,
    required String type,
    required String senderName,
    required String receiverDeviceToken,
    required String receiverImgUrl,
  }) async {
    if (content.trim().isEmpty && selectedImageFile.value == null) return;

    final String chatRoomId = getChatRoomId(senderId, receiverId);
    final String messageId = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      // update();
      isLoading.value = true;
      await startNewChat(receiverId, senderId);
      String? url = selectedImageFile.value != null
          ? await uploadImage(selectedImageFile.value!)
          : "";
      isLoading.value = false;
      // update();
      ChatMessage message = ChatMessage(
        id: messageId,
        chatId: chatRoomId,
        senderId: senderId,
        receiverId: receiverId,
        type: type,
        content: content,
        isDelivered: false,
        isSeen: false,
        imageUrl: url ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      messageController.clear();
      selectedImageFile.value = null;
      // Send the message to Firestore (No batch)
      await _firestore
          .collection('chatrooms')
          .doc(chatRoomId)
          .collection('messages')
          .doc(messageId)
          .set(message.toJson());

      // Update the chat room last message
      await _firestore.collection('chatrooms').doc(chatRoomId).update({
        'lastMessage': content,
        'lastMessageTime': Timestamp.now(),
      });

      // Send the notification in the background
      PushNotificationController.sendNotificationUsingApi(
        token: receiverDeviceToken,
        title: "New message from $senderName",
        body: content,
        data: {
          "Screen": "Chat", // Changed to match the case structure
          "senderId": senderId,
          "chatRoomId": chatRoomId,
          "senderName": senderName,
          "msgId": messageId,
          "receiverImgUrl": receiverImgUrl, // Add these fields
          "receiverDeviceToken": receiverDeviceToken,
        },
      ).catchError((e) {
        print('Error sending notification: $e');
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to send message. Please check your connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      print('Error sending message: $e');
    }
  }

  String getChatRoomId(String user1, String user2) {
    // Check cache first
    final cacheKey = '${user1}_$user2';
    if (_chatRoomIdCache.containsKey(cacheKey)) {
      return _chatRoomIdCache[cacheKey]!;
    }

    // Calculate and cache the result
    final chatRoomId = user1.hashCode <= user2.hashCode
        ? '${user1}_$user2'
        : '${user2}_$user1';
    _chatRoomIdCache[cacheKey] = chatRoomId;
    return chatRoomId;
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
