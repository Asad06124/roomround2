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
  Room? room;
  List<int> removedMediaIds = [];

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
  List<RoomTask> _tasks = [];

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

  @override
  void onInit() {
    super.onInit();
    _getRoomIdAndTasks(_sortBy);
    _currentlyPlayingIndex = null;
    recorderController.checkPermission();
    playerController.onCompletion.listen(
      (_) {
        playerController.stopPlayer();
        _currentlyPlayingIndex = null;
        update();
      },
    );

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

  void multiImagePic(int? existingImages) async {
    final ImageSource? source = await _showImageSourceDialog();

    if (selectedImages.length + (existingImages ?? 0) >= 3) {
      CustomOverlays.showToastMessage(
        message: 'You have already selected the maximum of 3 images.',
        isSuccess: true,
      );
      return;
    }

    if (source == null) return;

    if (source == ImageSource.camera) {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image == null) return;

      selectedImages.add(File(image.path));
      update();
    } else if (source == ImageSource.gallery) {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 80,
        requestFullMetadata: false,
      );
      if (images.isEmpty) return;

      // Calculate remaining image slots considering existing images.
      int remainingSpace = 3 - (selectedImages.length + (existingImages ?? 0));

      if (remainingSpace <= 0) {
        CustomOverlays.showToastMessage(
            message: 'You have already selected the maximum of 3 images.');
        return;
      }

      // Only take images up to the remaining available slots.
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

  Future<void> startRecording(int? existingAudios) async {
    if (recorderController.hasPermission) {
      if (selectedAudio.length + (existingAudios ?? 0) >= 3) {
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

  _fetchTasksList(int? roomId, String sortBy) async {
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

  void changeTaskStatus(
    int index,
    YesNo value,
  ) {
    if (index < _tasks.length) {
      _tasks[index].userSelection = value;
      _tasks[index].isNA = value == YesNo.na;
      update();

      RoomTask? task = _tasks[index];
      bool userSelection = value == YesNo.yes;

      _completeTask(index, userSelection, task, value);
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
      int index, bool userSelection, RoomTask? task, YesNo value) {
    if (task != null) {
      bool? completeAt = task.taskCompletion;
      // int? taskId = task.assignTemplateTaskId;
      // String? taskName = task.taskName;

      if (completeAt != null) {
        if (completeAt == userSelection || value == YesNo.na) {
          // Update Task
          if (task.ticketData != null) {
            Get.defaultDialog(
              backgroundColor: AppColors.white,
              title: 'Warning!',
              titleStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    color: Colors.orange,
                    size: 50,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'This task has a ticket associated with it. If you proceed, this ticket will be deleted, and this action cannot be undone.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              radius: 10,
              confirmTextColor: AppColors.white,
              cancelTextColor: AppColors.primary,
              buttonColor: AppColors.primary,
              confirm: ElevatedButton(
                onPressed: () {
                  _updateTaskStatus(index, task, userSelection);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: Text(
                  'Proceed',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
              cancel: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            );
          } else {
            _updateTaskStatus(
              index,
              task,
              userSelection,
            );
          }
        } else {
          // create ticket
          _showCreateTicketDialog(task);
        }
      }
    }
  }

  void _updateTask(int index, bool userSelection, RoomTask? task) {
    if (task != null) {
      bool? completeAt = task.taskStatus;
      // int? taskId = task.assignTemplateTaskId;
      // String? taskName = task.taskName;

      if (completeAt != null) {
        if (completeAt == !userSelection) {
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
      bool allDone = tasks.every((task) =>
          task.isNA == true ||
          task.taskStatus == true ||
          task.ticketData != null);
      if (allDone) {
        Get.back(closeOverlays: true);
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

  void _clearTicketDialogData() {
    _commentsController.clear();
    urgent.value = null;
    assignedTo.value = null;
    selectedAudio.clear();
    removedMediaIds.clear();
    selectedImages.clear();
  }

  void removeTicketMedia(RoomTask? task, int? ticketMediaId,
      {bool isAudio = false}) {
    if (ticketMediaId != null) {
      removedMediaIds.add(ticketMediaId);
      update();
    }
  }

  void _showCreateTicketDialog(RoomTask? task) {
    bool showMyTeamMembers = profileController.isManager;
    bool showMyManager = profileController.isEmployee;
    int? departmentId = profileController.user?.departmentId;

    Employee? preSelectedEmployee;

    if (task?.ticketData != null) {
      preSelectedEmployee = Employee(
        userId: task!.ticketData!.assignTo,
        employeeName: task.ticketData!.assignToName,
        imageKey: task.ticketData!.assignToImageKey,
      );

      _onUrgentValueChanged(
        task.ticketData!.isUrgent == true ? YesNo.yes : YesNo.no,
      );
      _commentsController.text = task.ticketData!.comment ?? '';
    } else {
      _onAssignedToChange(null);
    }

    Get.dialog(
      Dialog(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Obx(
              () {
                return CreateTicketDialog(
                  title: task?.taskName,
                  preSelectedEmployee: preSelectedEmployee,
                  selectedUrgent: urgent.value,
                  task: task,
                  textFieldController: _commentsController,
                  onUrgentChanged: _onUrgentValueChanged,
                  onSelectItem: _onAssignedToChange,
                  onDoneTap: () async {
                    await _createNewTicket(task);
                    await _fetchTasksList(task?.roomId, _sortBy);
                    bool allDone = _tasks.every((_task) =>
                        _task.isNA == true ||
                        _task.taskStatus == true ||
                        _task.ticketData != null);
                    if (allDone) {
                      Get.back(closeOverlays: true);
                    }
                  },
                );
              },
            );
          },
        ),
      ),
      arguments: {
        "myManager": showMyManager,
        "myTeam": showMyTeamMembers,
        "departmentId": departmentId,
      },
    ).then(
      (_) {
        _clearTicketDialogData();
        update();
        task.reactive;
      },
    );
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    update();
  }

  Future<void> _createNewTicket(RoomTask? task) async {
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
      if (task?.ticketData != null)
        'TicketId': task!.ticketData!.ticketId.toString(),
      if (removedMediaIds.isNotEmpty)
        'RemoveTicketMediaIds': removedMediaIds.join(','),
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
      if (resp == true) {}
    }
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
