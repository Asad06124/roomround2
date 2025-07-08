import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roomrounds/core/constants/controllers.dart';

import '../../../core/apis/models/chat_model/chat_model.dart';
import '../../../core/apis/models/tickets/ticket_model.dart';
import '../../push_notification/push_notification.dart';
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
    required final Ticket ticket,
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
            ticket: ticket,
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
    required final Ticket ticket,
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
            ticket: ticket,
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

  Stream<List<ChatMessage>> getMessages(String ticketId) {
    return _firestore
        .collection('ticketChats')
        .doc(ticketId)
        .collection('messages')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatMessage.fromJson(doc.data()))
              .toList()
              .reversed
              .toList(),
        );
  }

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
    required Ticket ticket,
    required String type,
  }) async {
    if (content.trim().isEmpty && selectedImageFile.value == null) return;

    final String tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final File? imageFile = selectedImageFile.value;
    final tempMessage = ChatMessage(
      id: tempId,
      chatId: ticketId,
      senderId: senderId,
      receiverId: receiverId,
      type: type,
      content: content,
      imageUrl: imageFile != null ? 'uploading' : '',
      isDelivered: false,
      isSeen: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    try {
      String? url;
      if (imageFile != null) {
        isLoading.value = true;
        url = await uploadImage(imageFile);
      }
      messages.insert(0, tempMessage);
      messageController.clear();
      isLoading.value = false;

      final updatedMessage = tempMessage.copyWith(
        imageUrl: url ?? '',
        isDelivered: true,
      );

      // Update local message
      final index = messages.indexWhere((m) => m.id == tempId);
      if (index != -1) messages[index] = updatedMessage;

      _firestore
          .collection('ticketChats')
          .doc(ticketId)
          .collection('messages')
          .doc(tempId)
          .set(updatedMessage.toJson());

      _firestore.collection('ticketChats').doc(ticketId).update({
        'lastMessage': content.isNotEmpty ? content : 'Image',
        'lastMessageTime': FieldValue.serverTimestamp(),
      });

      PushNotificationController.sendNotificationUsingApi(
        token: ticket.assignBy.toString() == senderId
            ? ticket.assignToFCMToken
            : ticket.assignByFCMToken,
        title: "New message from ${profileController.user?.username ?? ''}",
        body: content,
        data: {
          "Screen": "ticketChat",
          "senderId": receiverId,
          "receiverId": senderId,
          "ticketTitle": ticket.ticketName,
          "chatRoomId": ticketId,
          "ticket": jsonEncode(ticket.toJson()),
          "isAssignedToMe": (ticket.assignTo.toString() !=
                  profileController.userId.toString())
              .toString(),
          "senderName": profileController.user?.username ?? '',
          "msgId": tempId,
          "receiverImgUrl": '',
          "receiverDeviceToken": ticket.assignBy.toString() != senderId
              ? ticket.assignToFCMToken
              : ticket.assignByFCMToken,
        }, userId: receiverId,
      ).catchError((e) {
        print('Error sending notification: $e');
      });
    } catch (e) {
      final index = messages.indexWhere((m) => m.id == tempId);
      if (index != -1) {
        messages[index] = tempMessage.copyWith(
          content: 'Failed to send',
          type: 'error',
        );
      }
      print('Error: $e');
    } finally {
      selectedImageFile.value = null;
      isLoading.value = false;
    }
  }

  Future<void> markMessagesAsSeen(String ticketId, String receiverId) async {
    final batch = _firestore.batch();
    final querySnapshot = await _firestore
        .collection('ticketChats')
        .doc(ticketId)
        .collection('messages')
        .where('senderId', isEqualTo: receiverId)
        .where('isSeen', isEqualTo: false)
        .get();

    for (var doc in querySnapshot.docs) {
      batch.update(doc.reference, {
        'isSeen': true,
        'isDelivered': true,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    }

    await batch.commit();
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://roomroundapis.rootpointers.net/api/Chats/UploadImage'),
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
        final imageUrl = 'https://roomroundapis.rootpointers.net/$cleanPath';
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
