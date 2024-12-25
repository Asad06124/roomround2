import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/utils/custom_overlays.dart';

class MessageController extends GetxController with WidgetsBindingObserver {
  bool _isKeyBoardOpen = false;
  bool get isKeyBoardOpen => _isKeyBoardOpen;
  RxBool isSendingMessage = false.obs;
  OverlayPortalController overlayController = OverlayPortalController();
  final CollectionReference messageCollectionRef =
      FirebaseFirestore.instance.collection('roomround-chat');
  TextEditingController messageController = TextEditingController();
  RxList<MessagesModel> messages = <MessagesModel>[].obs;

  @override
  void onReady() {
    super.onReady();
    startListningKeyBoard();
    listenToMessagesInRealtime(24, 24);
  }

  startListningKeyBoard() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeMetrics() {
    final double bottomInset = MediaQuery.of(Get.context!).viewInsets.bottom;
    _isKeyBoardOpen = bottomInset > 0;
    update();
  }

  Future createMessage(MessagesModel message) async {
    try {
      await messageCollectionRef.doc().set(message.toJson());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  Future sendMessages(String senderId, String receiverId, String messageBody,
      String type) async {
    bool isConnected = await Utilities.hasConnection();

    if (!isConnected) {
      CustomOverlays.showToastMessage(message: AppStrings.noInternetConnection);
      return;
    }
    if (messageBody.isEmpty) {
      CustomOverlays.showToastMessage(message: "Message cannot be empty");
      return;
    }

    final MessagesModel message = MessagesModel(
      senderId: senderId,
      receiverId: receiverId,
      message: messageBody,
      createdAt: DateTime.now(),
      type: type,
    );
    messageController.clear();
    await createMessage(message);
  }

  final StreamController<List<MessagesModel>> _chatController =
      StreamController<List<MessagesModel>>.broadcast();

  Stream listenToMessagesInRealtime(int senderId, int receiverId) {
    _requestMessage(senderId, receiverId);
    return _chatController.stream;
  }

  void _requestMessage(int senderId, int receiverId) {
    var messageQuerySnapshot =
        messageCollectionRef.orderBy('createdAt', descending: false);

    messageQuerySnapshot.snapshots().listen((messageEvent) {
      if (messageEvent.docs.isNotEmpty) {
        messages.value = messageEvent.docs
            .map((item) =>
                MessagesModel.fromJson(item.data() as Map<String, dynamic>))
            .toList();
      }
    });
  }
}

class MessagesModel {
  final String senderId;
  final String receiverId;
  final String message;
  final String type;
  final dynamic createdAt;

  MessagesModel(
      {required this.senderId,
      required this.receiverId,
      required this.message,
      required this.createdAt,
      required this.type});

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'recieverId': receiverId,
      'message': message,
      'createdAt': createdAt,
      'type': type,
    };
  }

  static MessagesModel fromJson(Map<String, dynamic> json) {
    return MessagesModel(
      senderId: json['senderId'] ?? 0,
      receiverId: json['recieverId'] ?? 0,
      message: json['message'] ?? '',
      createdAt: json['createdAt'],
      type: json['type'] ?? '',
    );
  }

  static MessagesModel fromMap(Map<String, dynamic> map) {
    return MessagesModel(
      senderId: map['senderId'] ?? 0,
      receiverId: map['recieverId'] ?? 0,
      message: map['message'] ?? '',
      createdAt: map['createdAt'],
      type: map['type'] ?? '',
    );
  }
}
