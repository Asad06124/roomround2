// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';

// class MessagesController extends GetxController {
//   int id = 0;
//   int groupId = 0;
//   List<dynamic> reciedddverId = [];
//   TextEditingController messageController = TextEditingController();
//   RxList<MessagesModel> messages = <MessagesModel>[].obs;
//   RxList<GroupMessagesModel> messagesGroup = <GroupMessagesModel>[].obs;
//   final CollectionReference messageCollectionRef =
//       FirebaseFirestore.instance.collection('broker-chat');
//   final CollectionReference messageCollectionRefGroups =
//       FirebaseFirestore.instance.collection('groups');

//   String displayImage = '';
//   String downloadUrl = '';
//   RxBool isUploading = false.obs;

//   Future<void> getImageOfUser(ImageSource source) async {
//     try {
//       final pickedFile = await ImagePicker().pickImage(source: source);
//       if (pickedFile != null) {
//         isUploading.value = true; // Start the upload progress indicator
//         String displayImage;

//         if (source == ImageSource.camera) {
//           CroppedFile? croppedFile = await ImageCropper().cropImage(
//             sourcePath: pickedFile.path,
//             // ... cropping options
//           );

//           displayImage = croppedFile?.path ?? pickedFile.path;
//         } else {
//           displayImage = pickedFile.path;
//         }

//         await uploadImageToFirebaseStorage(displayImage);
//         await sendMessages(id, downloadUrl, "image");
//         isUploading.value = false; // Stop the upload progress indicator
//         update();
//       }
//     } catch (error) {
//       isUploading.value = false; // Stop the upload progress on error
//       log('Error picking or cropping image: $error');
//     }
//   }

//   Future<String> uploadImageToFirebaseStorage(String imagePath) async {
//     File file = File(imagePath);
//     String fileName = file.uri.pathSegments.last;
//     FirebaseStorage storage = FirebaseStorage.instance;
//     Reference ref = storage.ref().child('chat-images/$fileName');

//     try {
//       isUploading.value = true; // Start showing progress
//       TaskSnapshot uploadTask = await ref.putFile(file);
//       downloadUrl = await uploadTask.ref.getDownloadURL();
//       isUploading.value = false; // Upload complete, stop progress indicator
//       return downloadUrl;
//     } catch (e) {
//       isUploading.value = false; // Handle upload failure
//       throw Exception('Error uploading image: $e');
//     }
//   }

//   Future createMessage(MessagesModel message) async {
//     try {
//       await messageCollectionRef.doc().set(message.toJson());
//     } catch (e) {
//       if (e is PlatformException) {
//         return e.message;
//       }
//       return e.toString();
//     }
//   }

//   Future sendMessages(int receiverId, String messageBody, String type) async {
//     final MessagesModel message = MessagesModel(
//       senderId: userData.user.id,
//       receiverId: receiverId,
//       message: messageBody,
//       createdAt: DateTime.now(),
//       type: type,
//     );
//     await createMessage(message);
//   }

//   Future<void> deleteChatBetweenUsers(int userId1, int userId2) async {
//     try {
//       // Query 1: Messages where userId1 is sender and userId2 is receiver
//       final querySnapshot1 = await messageCollectionRef
//           .where('senderId', isEqualTo: userId1)
//           .where('recieverId', isEqualTo: userId2)
//           .get();

//       print(
//           "Messages where $userId1 sent to $userId2: ${querySnapshot1.docs.length}");

//       // Query 2: Messages where userId2 is sender and userId1 is receiver
//       final querySnapshot2 = await messageCollectionRef
//           .where('senderId', isEqualTo: userId2)
//           .where('recieverId', isEqualTo: userId1)
//           .get();

//       print(
//           "Messages where $userId2 sent to $userId1: ${querySnapshot2.docs.length}");

//       // If no documents are found in both queries, log and exit
//       if (querySnapshot1.docs.isEmpty && querySnapshot2.docs.isEmpty) {
//         print(
//             'No messages found between users $userId1 and $userId2 to delete.');
//         return;
//       }

//       // Batch delete for both queries
//       final batch = FirebaseFirestore.instance.batch();
//       for (var doc in querySnapshot1.docs) {
//         batch.delete(doc.reference);
//       }
//       for (var doc in querySnapshot2.docs) {
//         batch.delete(doc.reference);
//       }
//       update();

//       // Commit batch deletion
//       await batch.commit();
//       print('Successfully deleted chat between users $userId1 and $userId2.');
//     } catch (error) {
//       print('Error deleting chat between users $userId1 and $userId2: $error');
//     }
//   }

// // get messages
//   final StreamController<List<MessagesModel>> _chatController =
//       StreamController<List<MessagesModel>>.broadcast();

//   Stream listenToMessagesInRealtime(int senderId, int receiverId) {
//     _requestMessage(senderId, receiverId);
//     return _chatController.stream;
//   }

//   void _requestMessage(int senderId, int receiverId) {
//     var messsageQuerySnapshot =
//         messageCollectionRef.orderBy('createdAt', descending: true);
//     messsageQuerySnapshot.snapshots().listen((messageEvent) {
//       if (messageEvent.docs.isNotEmpty) {
//         var messages = messageEvent.docs
//             .map((item) =>
//                 MessagesModel.fromMap(item.data() as Map<String, dynamic>))
//             .where((element) =>
//                 (element.receiverId == receiverId &&
//                     element.senderId == senderId) ||
//                 (element.receiverId == senderId &&
//                     element.senderId == receiverId))
//             .toList();
//         _chatController.add(messages);
//       }
//       update();
//     });
//     update();
//   }

//   void listenToMessages(int receiverId) {
//     listenToMessagesInRealtime(userData.user.id, receiverId)
//         .listen((messagesData) {
//       List<MessagesModel> updatedMessages = messagesData;
//       if (updatedMessages != null && updatedMessages.length > 0) {
//         messages.value = updatedMessages;
//         setStatusTrue(
//             AppGlobals.userId = id, AppGlobals.checkStatusForChat = true);
//         update();
//       }
//     });
//     update();
//   }

//   String formatCreatedAt(Timestamp createdAt) {
//     DateTime dateTime =
//         DateTime.fromMillisecondsSinceEpoch(createdAt.seconds * 1000);
//     String formattedDate = DateFormat('MM-dd-yyyy hh:mm a').format(dateTime);

//     return formattedDate;
//   }

//   // for pdf file

//   RxBool isUploadingFile = false.obs;

//   Future<void> pickAndUploadFile() async {
//     try {
//       // Pick a file
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: [
//           'pdf',
//           'doc',
//           'docx',
//           'txt'
//         ], // Specify allowed file types
//       );

//       if (result != null && result.files.single.path != null) {
//         isUploadingFile.value = true; // Show progress indicator
//         String filePath = result.files.single.path!;
//         await uploadFileToFirebaseStorage(
//             filePath); // Upload the file to Firebase
//         await sendMessages(
//             id, downloadUrl, "document"); // Send the file URL as a message
//         isUploadingFile.value = false; // Hide progress indicator
//         update();
//       }
//     } catch (error) {
//       isUploadingFile.value = false;
//       log('Error picking or uploading file: $error');
//     }
//   }

//   Future<String> uploadFileToFirebaseStorage(String filePath) async {
//     File file = File(filePath);
//     String fileName = file.uri.pathSegments.last;
//     FirebaseStorage storage = FirebaseStorage.instance;
//     Reference ref = storage.ref().child('chat-files/$fileName');

//     try {
//       isUploadingFile.value = true; // Start showing progress
//       TaskSnapshot uploadTask = await ref.putFile(file);
//       downloadUrl =
//           await uploadTask.ref.getDownloadURL(); // Get the download URL
//       isUploadingFile.value = false; // Upload complete, stop progress indicator
//       return downloadUrl;
//     } catch (e) {
//       isUploadingFile.value = false; // Handle upload failure
//       throw Exception('Error uploading file: $e');
//     }
//   }

//   setStatusTrue(int? id, bool status) async {
//     final res = await apiCall(
//       POST,
//       Urls.deleteChat,
//       showSuccessMessage: false,
//       showErrorMessage: false,
//       showLoader: false,
//       {},
//     );
//     if (res != null) {
//       update();
//     }
//   }

//   // group chat
//   Future createGroupMessage(GroupMessagesModel message) async {
//     try {
//       await messageCollectionRefGroups.doc().set(message.toJson());
//     } catch (e) {
//       if (e is PlatformException) {
//         return e.message;
//       }
//       return e.toString();
//     }
//   }

//   Future sendGroupMessages(List<dynamic> receiverId, String messageBody,
//       String type, int groupId) async {
//     final GroupMessagesModel messageGroup = GroupMessagesModel(
//       senderId: userData.user.id,
//       receiverId: receiverId,
//       name: AppGlobals.userName ?? '',
//       message: messageBody,
//       createdAt: DateTime.now(),
//       type: type,
//       groupId: groupId,
//     );
//     await createGroupMessage(messageGroup);
//   }

//   // final ChatService chatService = ChatService();
//   // void listenToMessagesGroup(int groupId) {
//   //   chatService._requestMessageGroup(groupId);
//   //   // chatService._requestMessageForGroupBetweenUsers(groupId, senderId, receiverIds);
//   //   chatService.groupMessagesStream.listen((newMessages) {
//   //     messagesGroup.value = newMessages;
//   //   });
//   // }

//   final StreamController<List<GroupMessagesModel>> _chatControllerGroup =
//       StreamController<List<GroupMessagesModel>>.broadcast();

//   Stream listenToMessagesInRealtimeGroup(int groupId) {
//     _requestMessageGroup(groupId);
//     return _chatControllerGroup.stream;
//   }

//   void _requestMessageGroup(int groupId) {
// // Query messages by groupId and listen to real-time updates
//     var messageQuerySnapshot = messageCollectionRefGroups
//         .where('groupId', isEqualTo: groupId)
//         .orderBy('createdAt', descending: true);

//     messageQuerySnapshot.snapshots().listen((messageEvent) {
//       if (messageEvent.docs.isNotEmpty) {
//         // Map Firestore documents to a list of MessagesModel
//         var messagess = messageEvent.docs
//             .map((item) =>
//                 GroupMessagesModel.fromMap(item.data() as Map<String, dynamic>))
//             .toList();

//         // Add messages to the stream
//         _chatControllerGroup.add(messagess);
//       }
//       update();
//     });
//     update();
//   }

//   void listenToMessagesGroup(int groupId) {
//     // Listen to the messages for the specified groupId
//     listenToMessagesInRealtimeGroup(groupId).listen((messagesData) {
//       List<GroupMessagesModel> updatedMessages = messagesData;
//       if (updatedMessages != null && updatedMessages.length > 0) {
//         // Update the messages and set chat status
//         messagesGroup.value = updatedMessages;
//         // setStatusTrue(AppGlobals.userId, AppGlobals.checkStatusForChat = true);
//         update();
//       }
//     });
//   }

//   // delete
//   Future<void> deleteGroupChatMessages(int groupId) async {
//     try {
//       // Reference to the messages collection
//       var messageCollectionRef =
//           FirebaseFirestore.instance.collection('groups');

//       // Query messages with the specific groupId
//       var querySnapshot =
//           await messageCollectionRef.where('groupId', isEqualTo: groupId).get();
//       log("Found=========================================== ${querySnapshot.docs.length} messages for groupId $groupId.");

//       if (querySnapshot.docs.isNotEmpty) {
//         // Initialize Firestore batch
//         WriteBatch batch = FirebaseFirestore.instance.batch();

//         // Add delete operations to the batch
//         for (var doc in querySnapshot.docs) {
//           batch.delete(doc.reference);
//         }

//         // Commit the batch
//         await batch.commit();
//         print("All chat messages for groupId $groupId have been deleted.");
//       } else {
//         print("No chat messages found for groupId $groupId.");
//       }
//     } catch (e) {
//       print("Error deleting group chat messages: $e");
//     }
//   }

//   //image
//   Future<void> getImageOfGroup(ImageSource source) async {
//     try {
//       final pickedFile = await ImagePicker().pickImage(source: source);
//       if (pickedFile != null) {
//         isUploading.value = true; // Start the upload progress indicator
//         String displayImage;

//         if (source == ImageSource.camera) {
//           CroppedFile? croppedFile = await ImageCropper().cropImage(
//             sourcePath: pickedFile.path,
//             // ... cropping options
//           );

//           displayImage = croppedFile?.path ?? pickedFile.path;
//         } else {
//           displayImage = pickedFile.path;
//         }

//         await uploadImageToFirebaseStorage(displayImage);
//         sendGroupMessages(reciedddverId, downloadUrl, 'image', groupId);
//         // await sendMessages(id, downloadUrl, "image");
//         isUploading.value = false; // Stop the upload progress indicator
//         update();
//       }
//     } catch (error) {
//       isUploading.value = false; // Stop the upload progress on error
//       log('Error picking or cropping image: $error');
//     }
//   }

//   //pdf
//   Future<void> pickAndUploadFileGroup() async {
//     try {
//       // Pick a file
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: [
//           'pdf',
//           'doc',
//           'docx',
//           'txt'
//         ], // Specify allowed file types
//       );

//       if (result != null && result.files.single.path != null) {
//         isUploadingFile.value = true; // Show progress indicator
//         String filePath = result.files.single.path!;
//         await uploadFileToFirebaseStorage(
//             filePath); // Upload the file to Firebase
//         // await sendMessages(id, downloadUrl, "document");
//         sendGroupMessages(reciedddverId, downloadUrl, 'document', groupId);

//         // Send the file URL as a message
//         isUploadingFile.value = false; // Hide progress indicator
//         update();
//       }
//     } catch (error) {
//       isUploadingFile.value = false;
//       log('Error picking or uploading file: $error');
//     }
//   }
// }

// class ChatService {
//   final CollectionReference messageCollectionRefGroups =
//       FirebaseFirestore.instance.collection('groups');
//   final StreamController<List<GroupMessagesModel>> _chatControllerGroup =
//       StreamController<List<GroupMessagesModel>>.broadcast();
//   Stream<List<GroupMessagesModel>> get groupMessagesStream =>
//       _chatControllerGroup.stream;

//   // void _requestMessageGroup(int senderId, List<dynamic> receiverIds) {
//   //   var messageQuery = messageCollectionRefGroups.orderBy(
//   //     'createdAt',
//   //     descending: true,
//   //   );
//   //
//   //   messageQuery.snapshots().listen((snapshot) {
//   //     if (snapshot.docs.isNotEmpty) {
//   //       var messages = snapshot.docs.map((doc) {
//   //         final data = doc.data() as Map<String, dynamic>;
//   //         return GroupMessagesModel.fromMap(data);
//   //       }).where((message) {
//   //         final condition = (message.senderId == senderId &&
//   //             message.receiverId.any((id) => receiverIds.contains(id))) ||
//   //             (receiverIds.contains(message.senderId) &&
//   //                 message.receiverId.contains(senderId));
//   //         return condition;
//   //       }).toList();
//   //       _chatControllerGroup.add(messages);
//   //     } else {
//   //       _chatControllerGroup.add([]);
//   //     }
//   //   }, onError: (error) {
//   //     _chatControllerGroup.add([]);
//   //   });
//   // }

//   // void _requestMessageGroup(int groupId, int senderId) {
//   //
//   //
//   //
//   //
//   //
//   //   var messageQuery = messageCollectionRefGroups
//   //       .where('groupId', isEqualTo: groupId)
//   //       .where('senderId', isEqualTo: senderId)
//   //       .orderBy('createdAt', descending: true);
//   //
//   //   messageQuery.snapshots().listen((snapshot) {
//   //     if (snapshot.docs.isNotEmpty) {
//   //       var messages = snapshot.docs.map((doc) {
//   //         final data = doc.data() as Map<String, dynamic>;
//   //         return GroupMessagesModel.fromMap(data);
//   //       }).toList();
//   //       _chatControllerGroup.add(messages);
//   //     } else {
//   //       _chatControllerGroup.add([]);
//   //     }
//   //   }, onError: (error) {
//   //     _chatControllerGroup.add([]);
//   //   });
//   // }

//   void _requestMessageGroup(int groupId) {
//     var messageQuery = messageCollectionRefGroups
//         .where('groupId', isEqualTo: groupId)
//         .orderBy('createdAt', descending: true);

//     messageQuery.snapshots().listen((snapshot) {
//       if (snapshot.docs.isNotEmpty) {
//         var messages = snapshot.docs.map((doc) {
//           final data = doc.data() as Map<String, dynamic>;
//           return GroupMessagesModel.fromMap(data);
//         }).toList();
//         _chatControllerGroup.add(messages);
//       } else {
//         _chatControllerGroup.add([]);
//       }
//     }, onError: (error) {
//       _chatControllerGroup.add([]);
//     });
//   }

// //
// //
// // void _requestMessageForGroupBetweenUsers(int groupId, int senderId, List<dynamic> receiverIds) {
// //   // Query Firestore for messages in the specified group and order by creation time
// //   var messageQuery = messageCollectionRefGroups
// //       .where('groupId', isEqualTo: groupId) // Filter by groupId
// //       .orderBy('createdAt', descending: true);
// //
// //   messageQuery.snapshots().listen((snapshot) {
// //     log("Raw snapshot data: ${snapshot.docs.map((e) => e.data()).toList()}");
// //
// //     if (snapshot.docs.isNotEmpty) {
// //       var messages = snapshot.docs.map((doc) {
// //         final data = doc.data() as Map<String, dynamic>;
// //         log("Message data before filtering: $data");
// //         return GroupMessagesModel.fromMap(data);
// //       }).where((message) {
// //         // Filter by sender and receiver for the group
// //         final condition = (message.groupId == groupId) &&
// //             (message.senderId == senderId &&
// //                             message.receiverId.any((id) => receiverIds.contains(id))) ||
// //                             (receiverIds.contains(message.senderId) &&
// //                                 message.receiverId.contains(senderId));
// //
// //             // ((message.senderId == senderId && message.receiverId.contains(receiverId)) || // Sender to Receiver
// //             //     (message.senderId == receiverId && message.receiverId.contains(senderId))); // Receiver to Sender
// //
// //         log("Message ${message.message} passes condition: $condition");
// //         return condition;
// //       }).toList();
// //
// //       // Add the filtered messages to the stream
// //       _chatControllerGroup.add(messages);
// //       log("Filtered messages: $messages");
// //     } else {
// //       _chatControllerGroup.add([]);
// //       log("No messages found.");
// //     }
// //   }, onError: (error) {
// //     log("Error while fetching messages: $error");
// //     _chatControllerGroup.add([]);
// //   });
// // }
// }

// class GroupMessagesModel {
//   final int senderId;
//   final int groupId;
//   final List<dynamic> receiverId;
//   final String message;
//   final String name;
//   final String type;
//   final dynamic createdAt;

//   GroupMessagesModel(
//       {required this.senderId,
//       required this.receiverId,
//       required this.message,
//       required this.createdAt,
//       required this.type,
//       required this.groupId,
//       required this.name});

//   Map<String, dynamic> toJson() {
//     return {
//       'senderId': senderId,
//       'groupId': groupId,
//       'name': name,
//       'recieverId': receiverId,
//       'message': message,
//       'createdAt': createdAt,
//       'type': type,
//     };
//   }

//   static GroupMessagesModel fromJson(Map<String, dynamic> json) {
//     return GroupMessagesModel(
//       senderId: json['senderId'] ?? 0,
//       groupId: json['groupId'] ?? 0,
//       receiverId: json['recieverId'] ?? [],
//       message: json['message'] ?? '',
//       name: json['name'] ?? '',
//       createdAt: json['createdAt'],
//       type: json['type'] ?? '',
//     );
//   }

//   static GroupMessagesModel fromMap(Map<String, dynamic> map) {
//     return GroupMessagesModel(
//       senderId: map['senderId'] ?? 0,
//       groupId: map['groupId'] ?? 0,
//       receiverId: map['recieverId'] ?? [],
//       message: map['message'] ?? '',
//       name: map['name'] ?? '',
//       createdAt: map['createdAt'],
//       type: map['type'] ?? '',
//     );
//   }
// }

// class MessagesModel {
//   final int senderId;
//   final int receiverId;
//   final String message;
//   final String type;
//   final dynamic createdAt;

//   MessagesModel(
//       {required this.senderId,
//       required this.receiverId,
//       required this.message,
//       required this.createdAt,
//       required this.type});

//   Map<String, dynamic> toJson() {
//     return {
//       'senderId': senderId,
//       'recieverId': receiverId,
//       'message': message,
//       'createdAt': createdAt,
//       'type': type,
//     };
//   }

//   static MessagesModel fromJson(Map<String, dynamic> json) {
//     return MessagesModel(
//       senderId: json['senderId'] ?? 0,
//       receiverId: json['recieverId'] ?? 0,
//       message: json['message'] ?? '',
//       createdAt: json['createdAt'],
//       type: json['type'] ?? '',
//     );
//   }

//   static MessagesModel fromMap(Map<String, dynamic> map) {
//     return MessagesModel(
//       senderId: map['senderId'] ?? 0,
//       receiverId: map['recieverId'] ?? 0,
//       message: map['message'] ?? '',
//       createdAt: map['createdAt'],
//       type: map['type'] ?? '',
//     );
//   }
// }
