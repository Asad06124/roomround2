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

  final activeIcons = [
    Assets.icons.home.svg(
        colorFilter:
            const ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn)),
    Assets.icons.settings.svg(
        colorFilter:
            const ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn)),
    Assets.icons.personFill.svg(
        colorFilter:
            const ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn)),
  ];
  final inactiveIcons = [
    Assets.icons.home.svg(
        colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn)),
    Assets.icons.settings.svg(
        colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn)),
    Assets.icons.personFill.svg(
        colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn)),
  ];
  final labels = [AppStrings.home, AppStrings.settings, AppStrings.profile];

  Widget get curruntScreen => _screenList[_curruntIndex];

  buttumButtunClick(int indx) {
    _curruntIndex = indx;
    update();
  }
}
