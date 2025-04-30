import 'package:roomrounds/core/apis/models/feature/main_feature.dart';
import 'package:roomrounds/core/constants/imports.dart';

import '../../room_list/controller/room_list_controller.dart';

class MainFeatureController extends GetxController {
  // UserType _userType = UserType.employee;

  bool _isGridView = true;
  RoomListController roomListController = Get.put(RoomListController());
  bool get isGridView => _isGridView;

  List<MainFeature> _features = [];

  List<MainFeature> get features => _features;
  bool hasRoom = false;
  @override
  void onInit() {
    super.onInit();
    roomListController.fetchRoomsList().then((result) {
      hasRoom = roomListController.roomsList.isNotEmpty &&
          roomListController.roomsList.any((room) => room.roomStatus != true);
      update();
    });
    _createMainFeatures();
  }
  
void refreshRoomStatus() async {
  await roomListController.fetchRoomsList();
  hasRoom = roomListController.roomsList.isNotEmpty &&
      roomListController.roomsList.any((room) => room.roomStatus != true);
  update();
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
      title: AppStrings.facilitiesView,
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
        facilitiesViewFeature,
        assignedTaskFeature,
        employeeDirectoryFeature,
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
