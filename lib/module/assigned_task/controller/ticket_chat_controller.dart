import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../message/controller/chat_controller.dart';
import '../views/ticket_chat_image_preview.dart';

class TicketChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  OverlayPortalController overlayController = OverlayPortalController();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  TextEditingController messageController = TextEditingController();
  RxBool isLoading = false.obs;
  Rx<File?> selectedImageFile = Rx<File?>(null);
  static const String FONT_SIZE_KEY = 'chat_font_size';
  final storage = GetStorage();
  double chatFontSize = 14.0;

  // Initialize ticket chat
  Future<void> initializeTicketChat({
    required String ticketId,
    required String senderId,
    required String receiverId,
  }) async {
    final ticketChatDoc =
        await _firestore.collection('ticketChats').doc(ticketId).get();

    if (!ticketChatDoc.exists) {
      // Create new ticket chat if it doesn't exist
      await _firestore.collection('ticketChats').doc(ticketId).set({
        'ticketId': ticketId,
        'participants': [senderId, receiverId],
        'createdAt': Timestamp.now(),
        'lastMessage': null,
        'lastMessageTime': null,
        'status': 'active',
      });
    }
  }

  Future<void> pickImageFromGallery({
    required final String ticketId,
    required final String receiverId,
    required final String senderId,
  }) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImageFile.value = File(image.path);
      update();
      Get.to(
          TicketChatImagePreviewScreen(
            ticketId: ticketId,
            receiverId: receiverId,
            senderId: senderId,
          ),
          arguments: {
            ticketId: ticketId,
            receiverId: receiverId,
            senderId: senderId,
          });
    } else {
      print("No image selected.");
    }
  }

  Future<void> pickImageFromCamera({
    required final String ticketId,
    required final String receiverId,
    required final String senderId,
  }) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      selectedImageFile.value = File(image.path);

      update();
      Get.to(
          TicketChatImagePreviewScreen(
            ticketId: ticketId,
            receiverId: receiverId,
            senderId: senderId,
          ),
          arguments: {
            ticketId: ticketId,
            receiverId: receiverId,
            senderId: senderId,
          });
    } else {
      print("No image captured.");
    }
  }

  // Get messages stream for a specific ticket
  Stream<List<ChatMessage>> getMessages(String ticketId) {
    return _firestore
        .collection('ticketChats')
        .doc(ticketId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromJson(doc.data()))
          .toList()
          .reversed
          .toList();
    });
  }

  // Get last message stream for ticket preview
  Stream<String> getLastMessageStream(String ticketId) {
    return _firestore
        .collection('ticketChats')
        .doc(ticketId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return 'No messages yet';
      return snapshot.docs.first['content'] ?? '';
    });
  }

  // Get unread count stream
  Stream<int> getUnreadMessageCountStream(
      String ticketId, String currentUserId) {
    return _firestore
        .collection('ticketChats')
        .doc(ticketId)
        .collection('messages')
        .where('receiverId', isEqualTo: currentUserId)
        .where('isSeen', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> sendMessage({
    required String ticketId,
    required String receiverId,
    required String senderId,
    required String content,
    required String type,
  }) async {
    if (content.trim().isEmpty && selectedImageFile.value == null) return;

    try {
      messageController.clear();
      isLoading.value = true;

      await initializeTicketChat(
        ticketId: ticketId,
        senderId: senderId,
        receiverId: receiverId,
      );

      String? url;
      if (selectedImageFile.value != null) {
        url = await uploadImage(selectedImageFile.value!);
      }

      final String messageId = DateTime.now().millisecondsSinceEpoch.toString();

      ChatMessage message = ChatMessage(
        id: messageId,
        chatId: ticketId,
        senderId: senderId,
        receiverId: receiverId,
        type: type,
        content: content,
        imageUrl: url ?? '',
        isDelivered: false,
        isSeen: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      selectedImageFile.value = null;
      isLoading.value = false;

      // Save message
      await _firestore
          .collection('ticketChats')
          .doc(ticketId)
          .collection('messages')
          .doc(messageId)
          .set(message.toJson());

      // Update ticket chat's last message
      await _firestore.collection('ticketChats').doc(ticketId).update({
        'lastMessage': content,
        'lastMessageTime': Timestamp.now(),
      });
    } catch (e) {
      isLoading.value = false;
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

  // Mark messages as seen
  Future<void> markMessagesAsSeen(String ticketId, String receiverId) async {
    final messagesRef = _firestore
        .collection('ticketChats')
        .doc(ticketId)
        .collection('messages')
        .where('senderId', isEqualTo: receiverId)
        .where('isSeen', isEqualTo: false);

    final snapshot = await messagesRef.get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({
        'isSeen': true,
        'isDelivered': true,
        'updatedAt': DateTime.now().toIso8601String(),
      });
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

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
