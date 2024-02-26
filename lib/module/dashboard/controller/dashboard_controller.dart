import 'package:roomrounds/core/constants/imports.dart';

class DashBoardController extends GetxController {
  int _curruntIndex = 0;
  int get curruntIndex => _curruntIndex;
  final List<Widget> _screenList = [
    const MainFeaturesView(),
    SettingsView(),
    const Text("Profile")
  ];

  Widget get curruntScreen => _screenList[_curruntIndex];

  buttumButtunClick(int indx) {
    _curruntIndex = indx;
    update();
  }
}
