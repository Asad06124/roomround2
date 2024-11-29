import 'package:get/get.dart';
import 'package:roomrounds/module/emloyee_directory/controller/departments_controller.dart';
import 'package:roomrounds/module/notificatin/controller/notification_controller.dart';
import 'package:roomrounds/module/profile/controller/profile_controller.dart';

ProfileController profileController = Get.find<ProfileController>();
DepartmentsController departmentsController = Get.find<DepartmentsController>();
NotificationController notificationsController =
    Get.find<NotificationController>();

// ProfileController get profileController {
//   bool isRegistered = Get.isRegistered<ProfileController>();

//   if (isRegistered) {
//     return Get.find<ProfileController>();
//   } else {
//     return Get.put(ProfileController());
//   }
// }

// DepartmentsController get departmentsController {
//   bool isRegistered = Get.isRegistered<DepartmentsController>();

//   if (isRegistered) {
//     return Get.find<DepartmentsController>();
//   } else {
//     return Get.put(DepartmentsController());
//   }
// }
