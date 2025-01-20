// import 'dart:async';
// import 'package:image_picker/image_picker.dart';
// import '../../../core/constants/imports.dart';
// import '../components/chat_widget.dart';
// import '../controller/message_controller.dart';

// class MessagesScreen extends StatefulWidget {
//   MessagesScreen(
//       {super.key,
//       required this.name,
//       required this.img,
//       required this.id,
//       required this.isGroup});
//   String name = '';
//   String img = '';
//   int id = 0;
//   bool isGroup = false;
//   @override
//   State<MessagesScreen> createState() => _MessagesScreenState();
// }

// class _MessagesScreenState extends State<MessagesScreen> with ImagePickerMixin {
//   MessagesController msgController = Get.put(MessagesController());

//   @override
//   void initState() {
//     super.initState();
//     msgController.id = widget.id;
//     msgController.listenToMessages(widget.id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return Scaffold(
//         body: SafeArea(
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 height: 90,
//                 alignment: Alignment.center,
//                 color: AppColors.primary.withOpacity(0.3),
//                 child: Row(
//                   children: [
//                     InkWell(
//                       borderRadius: BorderRadius.circular(10),
//                       onTap: () {
//                         Get.back();
//                       },
//                       child: const Center(
//                         child: Icon(
//                           Icons.arrow_back_rounded,
//                           color: AppColors.black,
//                         ),
//                       ),
//                     ),
//                     SB.w(10),
//                     Row(
//                       children: [
//                         Container(
//                           height: 50,
//                           width: 50,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: AppColors.primary),
//                             shape: BoxShape.circle,
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(50),
//                             child: GenericCachedNetworkImage(
//                               height: 90,
//                               width: 90,
//                               imagePath: "${Urls.imageUrl}${widget.img ?? ""}",
//                               placeholder: "assets/images/casheImage.png",
//                             ),
//                           ),
//                         ),
//                         SB.w(10),
//                         Text(
//                           widget.name ?? "",
//                           style: const TextStyle(
//                             fontSize: 17,
//                             color: AppColors.black,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Spacer(),
//                     Image.asset(
//                       "assets/images/editChat.png",
//                       height: 20,
//                       width: 20,
//                     )
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   reverse: true,
//                   itemCount: msgController.messages.length,
//                   itemBuilder: (context, index) {
//                     final message = msgController.messages[index];
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Align(
//                         alignment: message.senderId == userData.user.id
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: message.type == 'text'
//                             ? TextMessageWidget(
//                                 message: message.message,
//                                 time: msgController
//                                     .formatCreatedAt(message.createdAt),
//                                 isSent: message.senderId == userData.user.id,
//                                 name: "",
//                               )
//                             : message.type == 'image'
//                                 ? ImageMessageWidget(
//                                     imagePath: message.message,
//                                     time: msgController
//                                         .formatCreatedAt(message.createdAt),
//                                     isSent:
//                                         message.senderId == userData.user.id,
//                                     isUploading:
//                                         msgController.isUploading.value,
//                                     name: '',
//                                   )
//                                 : FileMessageWidget(
//                                     onTap: () {},
//                                     document: message.message,
//                                     time: msgController
//                                         .formatCreatedAt(message.createdAt),
//                                     isSent:
//                                         message.senderId == userData.user.id,
//                                   ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 alignment: Alignment.bottomCenter,
//                 height: 65,
//                 color: Colors.white,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Container(
//                         margin: const EdgeInsets.only(top: 04, bottom: 0),
//                         child: CustomTextField3(
//                           borderRadius: 10,
//                           controller: msgController.messageController,
//                           contentPadding: const EdgeInsets.all(10),
//                           hintText: AppStrings.enterHere,
//                           hintTextColor: Colors.black,
//                           suffixIcon: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               (widget.isGroup == true)
//                                   ? const SizedBox()
//                                   : GestureDetector(
//                                       onTap: () async {
//                                         await _pickImage(msgController);
//                                       },
//                                       child: Image.asset(
//                                           "assets/images/vector.png",
//                                           height: 18,
//                                           width: 18)),
//                               SB.w(15),
//                               GestureDetector(
//                                 onTap: () {
//                                   if (msgController
//                                       .messageController.text.isEmpty) {
//                                     return;
//                                   }
//                                   msgController.sendMessages(
//                                       widget.id,
//                                       msgController.messageController.text,
//                                       "text");
//                                   msgController.messageController.clear();
//                                 },
//                                 child: Container(
//                                   alignment: Alignment.center,
//                                   height: 28,
//                                   width: 37,
//                                   decoration: BoxDecoration(
//                                     color: AppColors.primary,
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   child: Image.asset(
//                                     "assets/images/send.png",
//                                     scale: 5,
//                                   ),
//                                 ),
//                               ),
//                               SB.w(08),
//                             ],
//                           ),
//                           validator: null,
//                           onChange: (value) {},
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SB.h(03),
//             ],
//           ),
//         ),
//       );
//     });
//   }

//   Future<void> _pickImage(MessagesController controller) async {
//     await showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           height: 110,
//           decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(15), topLeft: Radius.circular(15))),
//           width: Get.width,
//           alignment: Alignment.center,
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               GestureDetector(
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await controller.getImageOfUser(ImageSource.camera);
//                 },
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: 50,
//                       width: 50,
//                       decoration: BoxDecoration(
//                         color: AppColors.primary,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Image.asset("assets/images/camera.png",
//                           height: 16, width: 16),
//                     ),
//                     const Text(
//                       "Camera",
//                       style: TextStyle(color: Colors.black, fontSize: 13),
//                     )
//                   ],
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await controller.getImageOfUser(ImageSource.gallery);
//                 },
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: 50,
//                       width: 50,
//                       decoration: BoxDecoration(
//                         color: AppColors.primary,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Image.asset(
//                         "assets/images/photo.png",
//                         scale: 6,
//                       ),
//                     ),
//                     const Text(
//                       "Photos",
//                       style: TextStyle(color: Colors.black, fontSize: 13),
//                     )
//                   ],
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await controller.pickAndUploadFile();
//                 },
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: 50,
//                       width: 50,
//                       decoration: BoxDecoration(
//                         color: AppColors.primary,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Image.asset(
//                         "assets/images/ducument.png",
//                         scale: 6,
//                       ),
//                     ),
//                     const Text(
//                       "Documents",
//                       style: TextStyle(color: Colors.black, fontSize: 13),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
