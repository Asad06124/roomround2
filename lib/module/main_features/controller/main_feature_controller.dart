import 'package:roomrounds/core/constants/imports.dart';

class MainFeatureController extends GetxController {
  bool _isGridView = true;
  bool get isGridView => _isGridView;

  chnageLayout(bool val) {
    _isGridView = val;
    update();
  }
}
