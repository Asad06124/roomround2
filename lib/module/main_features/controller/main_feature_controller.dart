import 'package:roomrounds/core/constants/imports.dart';

class MainFeatureController extends GetxController {
  bool _isGridView = true;
  bool get isGridView => _isGridView;
  UserType _userType = UserType.employee;
  MainFeatureController(UserType userType) {
    _userType = userType;
    _creatingMainFeature();
  }

  List<String> _titles = [];
  List<SvgGenImage> _images = [];

  List<String> _pages = [];

  List<String> get titles => _titles;
  List<SvgGenImage> get images => _images;
  List<String> get pages => _pages;

  chnageLayout(bool val) {
    _isGridView = val;
    update();
  }

  _creatingMainFeature() {
    if (_userType == UserType.employee) {
      _titles = [
        AppStrings.employeeDirectory,
        AppStrings.assignedTasks,
        AppStrings.roommapView
      ];
      _images = [
        Assets.icons.emplyeeDirectory,
        Assets.icons.assignedTasks,
        Assets.icons.roomMapView,
      ];
      _pages = [
        AppRoutes.EMPLOYEEDIRECTORy,
        AppRoutes.ASSIGNEDTASKS,
        AppRoutes.ROOMMAP
      ];
    } else if (_userType == UserType.manager) {
      _titles = [
        AppStrings.appName,
        AppStrings.facilitiesView,
        AppStrings.myTicket,
        AppStrings.employeeDirectory,
      ];
      _images = [
        Assets.icons.assignedTasks,
        Assets.icons.roomMapView,
        Assets.icons.tickets,
        Assets.icons.emplyeeDirectory,
      ];
      _pages = [
        AppRoutes.ROOMLIST,
        AppRoutes.ROOMMAP,
        AppRoutes.EMPLOYEEDIRECTORy,
        AppRoutes.ASSIGNEDTASKS,
      ];
    }
  }
}
