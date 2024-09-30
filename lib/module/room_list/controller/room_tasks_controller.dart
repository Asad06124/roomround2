import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/employee/employee_model.dart';
import 'package:roomrounds/core/apis/models/room/room_model.dart';
import 'package:roomrounds/core/apis/models/room/room_task_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/constants/utilities.dart';
import 'package:roomrounds/utils/custome_dialogue.dart';

class RoomTasksController extends GetxController {
  // TaskListController({this.roomId});
  // int? roomId;
  // String? roomName;
  // String? templateName;
  Room? room;

  final TextEditingController _commentsController = TextEditingController();

  bool hasData = false;
  Rx<YesNo?> urgent = Rx<YesNo?>(null);
  Rx<Employee?> assignedTo = Rx<Employee?>(null);

  List<RoomTask> _tasks = [
    /*   RoomTask(
      roomId: 11,
      assignTemplateTaskId: 322,
      taskName: 'Tasks 322 true ',
      taskStatus: false,
      isCompleted: true,
    ),
    RoomTask(
      roomId: 11,
      assignTemplateTaskId: 321,
      taskName: 'Tasks 321 true ',
      taskStatus: false,
      isCompleted: true,
    ),
    RoomTask(
      roomId: 11,
      assignTemplateTaskId: 323,
      taskName: 'Tasks 323 false ',
      taskStatus: false,
      isCompleted: false,
    ), */
  ];

  List<RoomTask> get tasks => _tasks;

  // final List<YesNo> _tasks = [];
  // List<YesNo> get tasks => _tasks;
  // final List<String> _tasksTitle = [
  //   'Arrange audit findings?',
  //   'Manage audit findings?'
  // ];
  // List<String> get tasksTitle => _tasksTitle;

  @override
  void onInit() {
    super.onInit();
    _getRoomIdAndTasks();
  }

  void _getRoomIdAndTasks() async {
    try {
      // roomId = Get.arguments['roomId'] as int?;
      // roomName = Get.arguments['roomName'] as String?;
      // templateName = Get.arguments['templateName'] as String?;
      room = Get.arguments as Room?;

      if (room != null) {
        _fetchTasksList(room?.roomId);
      } else {
        // Stop Loader
        await Future.delayed(Duration(seconds: 1));
        _updateHasData(true);
      }
    } catch (e) {
      customLogger(
        e.toString(),
        type: LoggerType.error,
        error: '_getRoomIdAndTasks',
      );
    }
  }

  void _fetchTasksList(int? roomId) async {
    int? managerId = profileController.userId;

    _updateHasData(false);

    Map<String, dynamic> data = {
      "managerId": managerId,
      "roomId": roomId,
      // "roomId": 32, // Testing
      "pageNo": 1,
      "size": 20,
      "isPagination": false,
    };

    var resp = await APIFunction.call(
      APIMethods.post,
      Urls.getAllTasks,
      dataMap: data,
      fromJson: RoomTask.fromJson,
      showLoader: false,
      showErrorMessage: false,
    );

    if (resp != null && resp is List && resp.isNotEmpty) {
      _tasks = List.from(resp);
      // update();
    }

    _updateHasData(true);
  }

  void changeTaskStatus(int index, YesNo value) {
    if (index < _tasks.length) {
      _tasks[index].userSelection = value;
      update();

      RoomTask? task = _tasks[index];
      bool userSelection = value == YesNo.yes;

      _completeTask(index, userSelection, task);
    }
  }

  void _completeTask(int index, bool userSelection, RoomTask? task) {
    if (task != null) {
      bool? completeAt = task.isCompleted;
      // int? taskId = task.assignTemplateTaskId;
      // String? taskName = task.taskName;

      if (completeAt != null) {
        if (completeAt == userSelection) {
          // Update Task
          _updateTaskStatus(
            index,
            task,
            userSelection,
          );
        } else {
          // create ticket
          _showCreateTicketDialog(task);
        }
      }
    }
  }

  int? getRoomIdByTask(RoomTask? task) {
    int? roomId = task?.roomId ?? room?.roomId;
    return roomId;
  }

  Future<void> _updateTaskStatus(int index, RoomTask? task, bool value) async {
    int? taskId = task?.assignTemplateTaskId;
    int? roomId = getRoomIdByTask(task);

    Map<String, dynamic> data = {
      "assignTemplateTaskId": taskId,
      "roomId": roomId,
      "status": value,
    };
    // String? params = "?roomId=$roomId&taskId=$taskId&status=$value";

    var resp = await APIFunction.call(
      APIMethods.post,
      Urls.updateTaskStatus,
      dataMap: data,
      showLoader: true,
      showErrorMessage: true,
      showSuccessMessage: true,
    );

    if (resp != null && resp is bool) {
      if (resp && index < _tasks.length) {
        _tasks[index].taskStatus = resp;
        // update();
      }
    }

    _updateHasData(true);
  }

  void _showCreateTicketDialog(RoomTask? task) {
    bool _showMyTeamMembers = profileController.userType == UserType.manager;
    int? _departmentId;

    Get.dialog(
        Dialog(
          child: Obx(
            () => CreateTicketDialog(
              title: task?.taskName,
              selectedUrgent: urgent.value,
              textFieldController: _commentsController,
              onUrgentChanged: _onUrgentValueChanged,
              onSelectItem: (emp) => assignedTo.value = emp,
              onDoneTap: () => _createNewTicket(task),
            ),
          ),
        ),
        arguments: {
          "myTeam": _showMyTeamMembers,
          "departmentId": _departmentId,
        }
        // barrierDismissible: false,
        );
  }

  void _createNewTicket(RoomTask? task) async {
    // _updateHasData(false);

    String comments = _commentsController.text.trim();
    int? assignedToId = assignedTo.value?.userId;
    bool isUrgent = urgent.value == YesNo.yes;
    int? taskId = task?.assignTemplateTaskId;
    int? roomId = getRoomIdByTask(task);

    Map<String, dynamic> data = {
      // "assignDate": "2024-09-29T12:54:33.858Z",
      "comment": comments,
      "isUrgent": isUrgent,
      "assignTo": assignedToId,
      "roomId": roomId,
      "assignTemplateTaskId": taskId,
    };

    var resp = await APIFunction.call(
      APIMethods.post,
      Urls.saveTicket,
      dataMap: data,
      showLoader: true,
      showErrorMessage: true,
      showSuccessMessage: true,
    );

    if (resp != null && resp is bool) {
      if (resp == true) {
        // Close Dialog
        Get.back();
      }
      // update();
    }

    // _updateHasData(true);
  }

  void _onUrgentValueChanged(YesNo? value) {
    if (value != null) {
      urgent.value = value;
    }
  }

  void _updateHasData(bool value) {
    hasData = value;
    update();
  }
}
