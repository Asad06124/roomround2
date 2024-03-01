import 'package:roomrounds/core/constants/imports.dart';

class MessageController extends GetxController with WidgetsBindingObserver {
  bool _isKeyBoardOpen = false;
  bool get isKeyBoardOpen => _isKeyBoardOpen;

  @override
  void onReady() {
    super.onReady();
    startListningKeyBoard();
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
}
