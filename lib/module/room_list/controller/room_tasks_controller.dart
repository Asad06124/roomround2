import 'dart:developer';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/employee/employee_model.dart';
import 'package:roomrounds/core/apis/models/room/room_model.dart';
import 'package:roomrounds/core/apis/models/room/room_task_model.dart';
import 'package:roomrounds/core/constants/imports.dart';

import '../../../utils/custom_overlays.dart';

class RoomTasksController extends GetxController {
  // TaskListController({this.roomId});
  // int? roomId;
  // String? roomName;
  // String? templateName;
  Room? room;

  final TextEditingController _commentsController = TextEditingController();
  var isRecording = false.obs;
  var selectedAudio = <File>[].obs;
  String? recordedFilePath;
  List<String> sortBy = [AppStrings.pendingFirst, AppStrings.completedFirst];
  final RecorderController recorderController = RecorderController();
  bool hasData = false;
  Rx<YesNo?> urgent = Rx<YesNo?>(null);
  Rx<Employee?> assignedTo = Rx<Employee?>(null);
  List<File> selectedImages = <File>[];
  int? _currentlyPlayingIndex;
  final ImagePicker _picker = ImagePicker();
  String _sortBy = "ASC";

  int? get currentlyPlayingIndex => _currentlyPlayingIndex;
  final PlayerController playerController = PlayerController();
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

  void changeSortBy(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (value == AppStrings.completedFirst) {
        _sortBy = 'DESC';
      } else {
        _sortBy = "ASC";
      }
      update();
      _getRoomIdAndTasks(_sortBy);
    }
  }

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
    _getRoomIdAndTasks(_sortBy);
    _currentlyPlayingIndex = null;
    recorderController.checkPermission();
    playerController.onCompletion.listen((_) {
      playerController.stopPlayer();
      _currentlyPlayingIndex = null;
      update();
    });

    playerController.setFinishMode(finishMode: FinishMode.stop);
    playerController.preparePlayer(path: recordedFilePath.toString());
  }

  Future<void> playAudio(File audioFile, int index) async {
    try {
      if (playerController.playerState.isPlaying) {
        await playerController.pausePlayer();
        _currentlyPlayingIndex = null;
      } else {
        await playerController.stopPlayer();
        await playerController.preparePlayer(path: audioFile.path);
        await playerController.startPlayer();
        _currentlyPlayingIndex = index;
      }
      update();
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  void deleteAudio(int index) {
    selectedAudio.removeAt(index);
    update();
  }

  void multiImagePic() async {
    final ImageSource? source = await _showImageSourceDialog();

    if (source == null) return;

    if (source == ImageSource.camera) {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image == null) return;

      if (selectedImages.length >= 3) {
        CustomOverlays.showToastMessage(
          message: 'You have already selected the maximum of 3 images.',
          isSuccess: true,
        );
        return;
      }

      selectedImages.add(File(image.path));
      update();
    } else if (source == ImageSource.gallery) {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 80,
        requestFullMetadata: false,
      );

      if (images.isEmpty) return;

      int remainingSpace = 3 - selectedImages.length;

      if (remainingSpace == 0) {
        CustomOverlays.showToastMessage(
            message: 'You have already selected the maximum of 3 images.');
        return;
      }

      final List<File> newImages =
          images.take(remainingSpace).map((image) => File(image.path)).toList();

      selectedImages.addAll(newImages);

      if (images.length > remainingSpace) {
        CustomOverlays.showToastMessage(
            message: 'Only $remainingSpace more image(s) can be selected.');
      }

      update();
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return await Get.dialog<ImageSource>(
      AlertDialog(
        backgroundColor: AppColors.white,
        title: Text('Choose Image Source'),
        content: Text(
            'Would you like to pick an image from the gallery or capture it using the camera?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: ImageSource.camera),
            child: Text(
              'Camera',
              style: TextStyle(
                color: AppColors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: ImageSource.gallery),
            child: Text(
              'Gallery',
              style: TextStyle(
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> startRecording() async {
    if (recorderController.hasPermission) {
      if (selectedAudio.length >= 3) {
        CustomOverlays.showToastMessage(
          message: 'You can only record up to 3 audios.',
          isSuccess: true,
        );
        return;
      }
      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
      try {
        log("Error starting recording: $path");
        await recorderController.record(path: path);
        recordedFilePath = path;

        // Set the recording state to true
        isRecording.value = true;

        update(); // Trigger UI update
      } catch (e) {
        debugPrint("Error starting recording: $e");
      }
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await recorderController.stop();
      if (path != null) {
        selectedAudio.add(File(path));
        isRecording.value = false; // Set the recording state to false
        update();
      }
    } catch (e) {
      debugPrint("Error stopping recording: $e");
    }
  }

  void _getRoomIdAndTasks(String sortBy) async {
    try {
      // roomId = Get.arguments['roomId'] as int?;
      // roomName = Get.arguments['roomName'] as String?;
      // templateName = Get.arguments['templateName'] as String?;
      room = Get.arguments as Room?;

      if (room != null) {
        _fetchTasksList(room?.roomId, sortBy);
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

  void _fetchTasksList(int? roomId, String sortBy) async {
    int? managerId = profileController.userId;

    _updateHasData(false);

    Map<String, dynamic> data = {
      "managerId": managerId,
      "roomId": roomId,
      "sortBy": "TaskStatus",
      "sortDirection": sortBy,
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

  void changeTaskStatus(int index, YesNo value, ) {
    if (index < _tasks.length) {
      _tasks[index].userSelection = value;
      _tasks[index].isNA = value == YesNo.na;
      update();

      RoomTask? task = _tasks[index];
      bool userSelection = value == YesNo.yes;

      _completeTask(
        index,
        userSelection,
        task,
      );
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

  void _completeTask(
    int index,
    bool userSelection,
    RoomTask? task,
  ) {
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

  Future<void> _updateTaskStatus(
    int index,
    RoomTask? task,
    bool value,
  ) async {
    int? taskId = task?.assignTemplateTaskId;
    int? roomId = getRoomIdByTask(task);

    // Map<String, dynamic> data = {
    //   "assignTemplateTaskId": taskId,
    //   "roomId": roomId,
    //   "status": value,
    // };
    String? params1 =
        "?roomId=$roomId&assignTemplateTaskId=$taskId&status=true";
    String? params2 =
        "?roomId=$roomId&assignTemplateTaskId=$taskId&status=true&isNA=true";
    String params = task?.userSelection == YesNo.na ? params2 : params1;
    log('updateTaskStatus params: ${Urls.updateTaskStatus + params}');
    var resp = await APIFunction.call(
      APIMethods.get,
      Urls.updateTaskStatus + params,
      // dataMap: data,
      showLoader: true,
      showErrorMessage: true,
      showSuccessMessage: true,
      isGoBack: false,
    );

    if (resp != null && resp is bool && resp == true) {
      _getRoomIdAndTasks(_sortBy);
      if (resp && index < _tasks.length) {
        _tasks[index].taskStatus = resp;

        update();
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
      isGoBack: false,
    );

    if (resp != null && resp is bool && resp == true) {
      if (resp && index < _tasks.length) {
        _fetchTasksList(roomId, _sortBy);
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
        child: StatefulBuilder(
          builder: (context, setState) {
            return Obx(() {
              return CreateTicketDialog(
                title: task?.taskName,
                selectedUrgent: urgent.value,
                textFieldController: _commentsController,
                onUrgentChanged: _onUrgentValueChanged,
                onSelectItem: _onAssignedToChange,
                onDoneTap: () {
                  _createNewTicket(task);
                  Navigator.of(context).pop();
                },
              );
            });
          },
        ),
      ),
      arguments: {
        "myManager": showMyManager,
        "myTeam": showMyTeamMembers,
        "departmentId": departmentId,
      },
    );
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    update();
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
