import 'package:roomrounds/core/apis/models/feature/main_feature.dart';
import 'package:roomrounds/core/constants/imports.dart';

class MainFeatureController extends GetxController {
  // UserType _userType = UserType.employee;

  bool _isGridView = true;
  bool get isGridView => _isGridView;

  List<MainFeature> _features = [];
  List<MainFeature> get features => _features;

  @override
  void onInit() {
    super.onInit();
    _createMainFeatures();
  }

  changeLayout(bool val) {
    _isGridView = val;
    update();
  }

  void _createMainFeatures() {
    bool isManager = profileController.isManager;
    bool isEmployee = profileController.isEmployee;

    MainFeature roomRoundFeature = MainFeature(
      title: AppConstants.appName,
      image: Assets.icons.assignedTasks,
      page: AppRoutes.ROOMS_LIST,
    );
    MainFeature facilitiesViewFeature = MainFeature(
      title: isManager ? AppStrings.facilitiesView : AppStrings.roommapView,
      image: Assets.icons.roomMapView,
      // page: AppRoutes.ROOM_MAP,
      page: AppRoutes.CREATE_TICKET,
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

    if (isManager) {
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
    // update();

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
