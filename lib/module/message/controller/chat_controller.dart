import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roomrounds/module/message/views/image_previewscreen.dart';

import '../../../core/apis/models/chat_model/chat_model.dart';
import '../../../core/apis/models/employee/employee_model.dart';
import '../../../core/services/get_server_key.dart';
import '../../push_notification/push_notification.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  OverlayPortalController overlayController = OverlayPortalController();
  final Map<String, String> _chatRoomIdCache = {};

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  TextEditingController messageController = TextEditingController();
  RxBool isLoading = false.obs;
  Rx<File?> selectedImageFile = Rx<File?>(null);
  static const String FONT_SIZE_KEY = 'chat_font_size';
  final storage = GetStorage();
  double chatFontSize = 14.0;

  @override
  void onInit() {
    super.onInit();
    loadFontSize();
  }

  void loadFontSize() {
    chatFontSize = storage.read(FONT_SIZE_KEY) ?? 16.0;
    update();
  }

  Future<void> updateFontSize(double newSize) async {
    chatFontSize = newSize;
    await storage.write(FONT_SIZE_KEY, newSize);
    update();
  }

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
      Get.to(
          ImagePreviewScreen(
            receiverId: receiverId,
            receiverImgUrl: receiverImgUrl,
            receiverDeviceToken: receiverDeviceToken,
            name: name,
          ),
          arguments: {
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
      Get.to(
          ImagePreviewScreen(
            receiverId: receiverId,
            receiverImgUrl: receiverImgUrl,
            receiverDeviceToken: receiverDeviceToken,
            name: name,
          ),
          arguments: {
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
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://roomroundapis.rootpointers.net/api/Chats/UploadImage'),
      );
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
      var response = await request.send();
      if (response.statusCode == 200) {
        final imagePath = await response.stream.bytesToString();
        final cleanPath = imagePath.replaceAll(RegExp(r'^/+'), '');
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

  Future<void> startNewChat(String otherUserId, String senderId) async {
    final chatRoomId = getChatRoomId(senderId, otherUserId);
    final chatDoc =
        await _firestore.collection('chatrooms').doc(chatRoomId).get();

    if (!chatDoc.exists) {
      await _firestore.collection('chatrooms').doc(chatRoomId).set({
        'participants': [senderId, otherUserId],
        'createdAt': Timestamp.now(),
        'lastMessage': null,
        'lastMessageTime': null,
      });
    }
  }

  Future<void> updateMessageStatus(
      String messageId, bool isDelivered, bool isSeen) async {
    try {
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
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return 'No messages yet';
      return snapshot.data()?['lastMessage'] ?? 'No messages yet';
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

  Stream<List<ChatMessage>> getMessages(String otherUserId, String senderId) {
    String chatRoomId = getChatRoomId(senderId, otherUserId);
    return _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            Map<String, dynamic> data = doc.data();
            return ChatMessage(
              id: doc.id,
              chatId: data['chatId'],
              senderId: data['senderId'],
              receiverId: data['receiverId'],
              type: data['type'],
              content: data['content'],
              imageUrl: data['imageUrl'],
              isDelivered: data['isDelivered'] ?? false,
              isSeen: data['isSeen'] ?? false,
              createdAt: DateTime.parse(data['createdAt']),
              updatedAt: DateTime.parse(data['updatedAt']),
            );
          })
          .toList()
          .reversed
          .toList();
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

    for (var doc in snapshot.docs) {
      doc.reference.update({'isSeen': true, 'isDelivered': true});
    }
  }

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
      messageController.clear();
      isLoading.value = true;
      await startNewChat(receiverId, senderId);
      String? url = selectedImageFile.value != null
          ? await uploadImage(selectedImageFile.value!)
          : "";

      isLoading.value = false;
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
      String serverKey = await GetServerKey().getServerKeyToken();
      selectedImageFile.value = null;
      await _firestore
          .collection('chatrooms')
          .doc(chatRoomId)
          .collection('messages')
          .doc(messageId)
          .set(message.toJson());
      await _firestore.collection('chatrooms').doc(chatRoomId).set({
        'participants': [senderId, receiverId],
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': content,
        'lastMessageTime': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      PushNotificationController.sendNotificationUsingApi(
        token: receiverDeviceToken,
        title: "New message from $senderName",
        body: content,
        data: {
          "Screen": "Chat",
          "senderId": senderId,
          "chatRoomId": chatRoomId,
          "senderName": senderName,
          "msgId": messageId,
          "receiverImgUrl": receiverImgUrl,
          "receiverDeviceToken": serverKey,
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
    final cacheKey = '${user1}_$user2';
    if (_chatRoomIdCache.containsKey(cacheKey)) {
      return _chatRoomIdCache[cacheKey]!;
    }

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
