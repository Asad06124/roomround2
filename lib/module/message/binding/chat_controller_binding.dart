import 'package:get/get.dart';
import 'package:roomrounds/module/message/controller/chat_controller.dart';

class ChatControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ChatController>(ChatController(), permanent: true);
  }
}
