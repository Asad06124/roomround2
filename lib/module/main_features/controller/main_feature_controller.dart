import 'package:roomrounds/core/apis/models/feature/main_feature.dart';
import 'package:roomrounds/core/constants/imports.dart';

class MainFeatureController extends GetxController {
  MainFeatureController({UserType? userType}) {
    if (userType != null) {
      _userType = userType;
    }
    _creatingMainFeatures();
  }
  UserType _userType = UserType.employee;

  bool _isGridView = true;
  bool get isGridView => _isGridView;

  // List<String> _titles = [];
  // List<SvgGenImage> _images = [];

  // List<String> _pages = [];

  // List<String> get titles => _titles;
  // List<SvgGenImage> get images => _images;
  // List<String> get pages => _pages;

  List<MainFeature> _features = [];
  List<MainFeature> get features => _features;

  changeLayout(bool val) {
    _isGridView = val;
    update();
  }

  _creatingMainFeatures() {
    bool isManager = _userType == UserType.manager;
    bool isEmployee = _userType == UserType.employee;
    bool isOrgAdmin = _userType == UserType.organizationAdmin;

    MainFeature roomRoundFeature = MainFeature(
      title: AppConstants.appName,
      image: Assets.icons.assignedTasks,
      page: AppRoutes.ROOMS_LIST,
    );
    MainFeature facilitiesViewFeature = MainFeature(
      title: isManager ? AppStrings.facilitiesView : AppStrings.roommapView,
      image: Assets.icons.roomMapView,
      page: AppRoutes.ROOM_MAP,
    );
    MainFeature assignedTaskFeature = MainFeature(
      title: isManager ? AppStrings.myTicket : AppStrings.assignedTasks,
      image: isManager ? Assets.icons.tickets : Assets.icons.assignedTasks,
      page: AppRoutes.ASSIGNED_TASKS,
    );
    MainFeature employeeDirectoryFeature = MainFeature(
      title: AppStrings.employeeDirectory,
      image: Assets.icons.emplyeeDirectory,
      page: AppRoutes.EMPLOYEE_DIRECTORy,
    );

    if (isManager || isOrgAdmin) {
      _features = [
        roomRoundFeature,
        facilitiesViewFeature,
        assignedTaskFeature,
        employeeDirectoryFeature,
      ];
    } else if (isEmployee) {
      _features = [
        employeeDirectoryFeature,
        assignedTaskFeature,
        facilitiesViewFeature,
      ];
    }

    /* if (_userType == UserType.employee) {
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
        AppConstants.appName,
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
    } */
  }
}
