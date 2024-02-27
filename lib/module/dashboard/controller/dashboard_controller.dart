import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/profile/views/profile_view.dart';

class DashBoardController extends GetxController {
  int _curruntIndex = 0;
  int get curruntIndex => _curruntIndex;
  final List<Widget> _screenList = [
    const MainFeaturesView(),
    const SettingsView(),
    const ProfileView()
  ];

  Widget get curruntScreen => _screenList[_curruntIndex];

  buttumButtunClick(int indx) {
    _curruntIndex = indx;
    update();
  }
}
