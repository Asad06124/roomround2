import 'dart:io';

import 'package:intl/intl.dart';
import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/employee/employee_model.dart';
import 'package:roomrounds/core/apis/models/room/room_model.dart';
import 'package:roomrounds/core/apis/models/room/room_task_model.dart';
import 'package:roomrounds/core/constants/imports.dart';

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
  List<File> selectedImages = <File>[];
  List<File> selectedAudio = <File>[];
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

  void updateTaskStatus(int index, YesNo value) {
    if (index < _tasks.length) {
      _tasks[index].userSelection = value;
      update();

      RoomTask? task = _tasks[index];
      bool userSelection = value == YesNo.yes;

      _updateTask(index, userSelection, task);
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

  void _updateTask(int index, bool userSelection, RoomTask? task) {
    if (task != null) {
      bool? completeAt = task.isCompleted;
      // int? taskId = task.assignTemplateTaskId;
      // String? taskName = task.taskName;

      if (completeAt != null) {
        if (completeAt == userSelection) {
          // Update Task
          _updateStatusAfterComplete(
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

    // Map<String, dynamic> data = {
    //   "assignTemplateTaskId": taskId,
    //   "roomId": roomId,
    //   "status": value,
    // };
    String? params = "?roomId=$roomId&assignTemplateTaskId=$taskId&status=true";

    var resp = await APIFunction.call(
      APIMethods.get,
      Urls.updateTaskStatus + params,
      // dataMap: data,
      showLoader: true,
      showErrorMessage: true,
      showSuccessMessage: true,
    );

    if (resp != null && resp is bool && resp == true) {
      if (resp && index < _tasks.length) {
        _tasks[index].taskStatus = resp;
        // update();
      }
    }

    _updateHasData(true);
  }

  Future<void> _updateStatusAfterComplete(
      int index, RoomTask? task, bool value) async {
    int? taskId = task?.assignTemplateTaskId;
    int? roomId = getRoomIdByTask(task);

    // Map<String, dynamic> data = {
    //   "assignTemplateTaskId": taskId,
    //   "roomId": roomId,
    //   "status": value,
    // };
    String? params =
        "?roomId=$roomId&assignTemplateTaskId=$taskId&status=false";

    var resp = await APIFunction.call(
      APIMethods.get,
      Urls.updateTaskStatus + params,
      // dataMap: data,
      showLoader: true,
      showErrorMessage: true,
      showSuccessMessage: true,
    );

    if (resp != null && resp is bool && resp == true) {
      if (resp && index < _tasks.length) {
        _tasks[index].taskStatus = resp;
        // update();
      }
    }

    _updateHasData(true);
  }

  void _showCreateTicketDialog(RoomTask? task) {
    bool showMyTeamMembers = profileController.isManager;
    bool showMyManager = profileController.isEmployee;
    int? departmentId = profileController.user?.departmentId;

    _onAssignedToChange(null);

    Get.dialog(
      Dialog(
        child: Obx(
          () => CreateTicketDialog(
            title: task?.taskName,
            selectedUrgent: urgent.value,
            textFieldController: _commentsController,
            onUrgentChanged: _onUrgentValueChanged,
            onSelectItem: _onAssignedToChange,
            onDoneTap: () => _createNewTicket(task),
          ),
        ),
      ),
      arguments: {
        "myManager": showMyManager,
        "myTeam": showMyTeamMembers,
        "departmentId": departmentId,
      },
      // barrierDismissible: false,
    );
  }

  void _createNewTicket(RoomTask? task) async {
    // _updateHasData(false);
    int? assignedToId = assignedTo.value?.userId;
    String comments = _commentsController.text.trim();
    bool isUrgent = urgent.value == YesNo.yes;
    int? taskId = task?.assignTemplateTaskId;
    int? roomId = getRoomIdByTask(task);
    final String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    Map<String, String> data = {
      "RoomId": '$roomId',
      "AssignTemplateTaskId": '$taskId',
      "AssignDate": formattedDate,
      "Comment": comments,
      "IsUrgent": '$isUrgent',
      "AssignTo": '$assignedToId',
    };

    var resp = await APIFunction.call(
      APIMethods.post,
      Urls.saveTicket,
      dataMap: data,
      showLoader: true,
      showErrorMessage: true,
      showSuccessMessage: true,
      audioKey: 'AudiosList',
      imageKey: 'ImagesList',
      imageListFile: selectedImages,
      audioListFile: selectedAudio,
    );

    if (resp != null && resp is bool) {
      if (resp == true) {
        // Close Dialog
        // Get.back();
      }
      // update();
    }

    // _updateHasData(true);
  }

  void _onAssignedToChange(Employee? employee) {
    assignedTo.value = employee;
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
