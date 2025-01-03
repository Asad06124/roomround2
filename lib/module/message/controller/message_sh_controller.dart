import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:roomrounds/core/constants/imports.dart';

class MessagesController extends GetxController {
  int id = 0;
  int groupId = 0;
  List<dynamic> reciedddverId = [];
  TextEditingController messageController = TextEditingController();
  RxList<MessagesModel> messages = <MessagesModel>[].obs;
  final CollectionReference messageCollectionRef =
      FirebaseFirestore.instance.collection('broker-chat');

  String displayImage = '';
  String downloadUrl = '';
  RxBool isUploading = false.obs;

// get messages

  // void listenToMessages(int receiverId) {
  //   listenToMessagesInRealtime(userData.user.id, receiverId)
  //       .listen((messagesData) {
  //     List<MessagesModel> updatedMessages = messagesData;
  //     if (updatedMessages != null && updatedMessages.length > 0) {
  //       messages.value = updatedMessages;
  //       setStatusTrue(
  //           AppGlobals.userId = id, AppGlobals.checkStatusForChat = true);
  //       update();
  //     }
  //   });
  //   update();
  // }

  String formatCreatedAt(Timestamp createdAt) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(createdAt.seconds * 1000);
    String formattedDate = DateFormat('MM-dd-yyyy hh:mm a').format(dateTime);

    return formattedDate;
  }
}

class MessagesModel {
  final int senderId;
  final int receiverId;
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
