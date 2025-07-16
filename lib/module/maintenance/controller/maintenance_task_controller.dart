import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roomrounds/core/constants/app_enum.dart';
import 'package:roomrounds/core/apis/models/employee/employee_model.dart';
import 'dart:io';
import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/constants/controllers.dart';
import 'package:roomrounds/core/constants/urls.dart';
import 'package:intl/intl.dart';
import 'package:roomrounds/utils/custom_overlays.dart';
import 'package:roomrounds/core/apis/models/maintenance_task_model.dart';
import 'package:roomrounds/module/room_list/controller/room_tasks_controller.dart';



class MaintenanceTaskController extends GetxController {
  // For Create Ticket
  final createTicketFormKey = GlobalKey<FormState>();
  final ticketDescriptionController = TextEditingController();
  var isUrgent = Rxn<YesNo>();
  var assignedTo = Rxn<Employee>();

  // For Complete Task
  final completeTaskFormKey = GlobalKey<FormState>();
  final commentsController = TextEditingController();

  // Media for ticket creation
  var selectedImages = <File>[].obs;
  var selectedAudio = <File>[].obs;
  File? selectedDocument;

  void addImage(File image) {
    if (selectedImages.length < 3) {
      selectedImages.add(image);
      update();
    } else {
      CustomOverlays.showToastMessage(
          message: 'Maximum 3 images allowed', isSuccess: false);
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      update();
    }
  }

  void addAudio(File audio) {
    if (selectedAudio.length < 3) {
      selectedAudio.add(audio);
      update();
    } else {
      CustomOverlays.showToastMessage(
          message: 'Maximum 3 audio files allowed', isSuccess: false);
    }
  }

  void removeAudio(int index) {
    if (index >= 0 && index < selectedAudio.length) {
      selectedAudio.removeAt(index);
      update();
    }
  }

  void setDocument(File doc) {
    selectedDocument = doc;
    update();
  }

  void removeDocument() {
    selectedDocument = null;
    update();
  }

  /// Import images and audios from RoomTasksController if available
  void importRoomTaskMedia() {
    if (Get.isRegistered<RoomTasksController>()) {
      final roomTasksController = Get.find<RoomTasksController>();
      selectedImages.assignAll(roomTasksController.selectedImages);
      selectedAudio.assignAll(roomTasksController.selectedAudio);
      update();
    }
  }

  @override
  void onClose() {
    ticketDescriptionController.dispose();
    commentsController.dispose();
    super.onClose();
  }

  void resetTicketFields() {
    ticketDescriptionController.clear();
    isUrgent.value = null;
    assignedTo.value = null;
    selectedImages.clear();
    selectedAudio.clear();
    selectedDocument = null;
  }

  void resetCompleteTaskFields() {
    commentsController.clear();
  }

  Future<void> createMaintenanceTicket(MaintenanceTask task) async {
    print('Creating ticket with task ID:  [38;5;2m${task.maintenanceTaskId} [0m');
    if (task.maintenanceTaskId == null) {
      CustomOverlays.showToastMessage(
          message: 'Invalid task ID', isSuccess: false);
      return;
    }
    if (assignedTo.value?.userId == null) {
      CustomOverlays.showToastMessage(
          message: 'Please assign an employee', isSuccess: false);
      return;
    }

    int? assignedToId = assignedTo.value?.userId;
    String description = ticketDescriptionController.text.trim();
    bool urgent = isUrgent.value == YesNo.yes;
    int? maintenanceTaskId = task.maintenanceTaskId;
    final String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    String occurrenceDate = task.occurrenceDate ?? formattedDate;

    Map<String, String> data = {
      "IsCompleted": 'false',
      "AssignTo": '${assignedToId ?? ''}',
      "IsUrgent": '$urgent',
      "MaintenanceOccurrenceDate": occurrenceDate,
      "MaintenanceTaskId": '$maintenanceTaskId',
      "Comment": description,
    };

    CustomOverlays.showLoader();
    try {
      var resp = await APIFunction.call(
        APIMethods.post,
        '/maintenanceTasks/maintenaceTaskCompleteOrCreateTicket',
        dataMap: data,
        showLoader: true, // Handled manually
        showErrorMessage: true, // Handled manually
        showSuccessMessage: true, // Handled manually
        imageKey: 'ImagesList',
        audioKey: 'AudiosList',
        isGoBack: true,
        imageListFile: selectedImages,
        audioListFile: selectedAudio,
        file: selectedDocument,
        fileKey: 'DocumentUpload',
      );
      print('API Response: $resp');
      if (resp != null && resp is bool && resp == true) {
        print('Ticket created successfully');
        CustomOverlays.showToastMessage(
            message: 'Ticket created successfully', isSuccess: true);
        selectedImages.clear();
        selectedAudio.clear();
        selectedDocument = null;
        update();
        Get.back(); // Navigate back after success
      } else {
        print('Ticket creation failed: $resp');
        CustomOverlays.showToastMessage(
            message: 'Failed to create ticket', isSuccess: false);
      }
    } catch (e) {
      print('Error creating ticket: $e');
      CustomOverlays.showToastMessage(
          message: 'Error: ${e.toString()}', isSuccess: false);
    } finally {
      CustomOverlays.dismissLoader();
    }
  }

  Future<void> submitTicketCreation(MaintenanceTask? task) async {
    print('Form validation: ${createTicketFormKey.currentState?.validate()}');
    print('Task: $task');
    if (createTicketFormKey.currentState?.validate() ?? false) {
      importRoomTaskMedia();
      if (task != null) {
        print('Submitting ticket for task: ${task.maintenanceTaskId}');
        await createMaintenanceTicket(task); // <-- await here
        resetTicketFields(); // <-- only reset after ticket creation
      } else {
        print('Task is null');
        CustomOverlays.showToastMessage(
            message: 'Task is null', isSuccess: false);
      }
    } else {
      print('Form validation failed');
    }
  }

  Future<void> completeMaintenanceTask(MaintenanceTask task) async {
    print('Completing task with ID:  [38;5;2m${task.maintenanceTaskId} [0m');
    if (task.maintenanceTaskId == null) {
      CustomOverlays.showToastMessage(
          message: 'Invalid task ID', isSuccess: false);
      return;
    }
    if (assignedTo.value?.userId == null) {
      CustomOverlays.showToastMessage(
          message: 'Please assign an employee', isSuccess: false);
      return;
    }

    int? assignedToId = assignedTo.value?.userId;
    String description = commentsController.text.trim();
    bool urgent = isUrgent.value == YesNo.yes;
    int? maintenanceTaskId = task.maintenanceTaskId;
    final String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    String occurrenceDate = task.occurrenceDate ?? formattedDate;

    Map<String, String> data = {
      "IsCompleted": 'true',
      "AssignTo": '${assignedToId ?? ''}',
      "IsUrgent": '$urgent',
      "MaintenanceOccurrenceDate": occurrenceDate,
      "MaintenanceTaskId": '$maintenanceTaskId',
      "Comment": description,
    };

    CustomOverlays.showLoader();
    try {
      var resp = await APIFunction.call(
        APIMethods.post,
        '/maintenanceTasks/maintenaceTaskCompleteOrCreateTicket',
        dataMap: data,
        showLoader: true, // Handled manually
        showErrorMessage: true, // Handled manually
        showSuccessMessage: true, // Handled manually
        imageKey: 'ImagesList',
        audioKey: 'AudiosList',
        isGoBack: true,
        imageListFile: selectedImages,
        audioListFile: selectedAudio,
        file: selectedDocument,
        fileKey: 'DocumentUpload',
      );
      print('API Response: $resp');
      if (resp != null && resp is bool && resp == true) {
        print('Task completed successfully');
        CustomOverlays.showToastMessage(
            message: 'Task completed successfully', isSuccess: true);
        selectedImages.clear();
        selectedAudio.clear();
        selectedDocument = null;
        update();
        Get.back(); // Navigate back after success
      } else {
        print('Task completion failed: $resp');
        CustomOverlays.showToastMessage(
            message: 'Failed to complete task', isSuccess: false);
      }
    } catch (e) {
      print('Error completing task: $e');
      CustomOverlays.showToastMessage(
          message: 'Error:  [31m${e.toString()} [0m', isSuccess: false);
    } finally {
      CustomOverlays.dismissLoader();
    }
  }

  Future<void> submitCompletion(MaintenanceTask? task) async {
    print('Form validation:  [36m${completeTaskFormKey.currentState?.validate()} [0m');
    print('Task: $task');
    if (completeTaskFormKey.currentState?.validate() ?? false) {
      if (task != null) {
        print('Submitting completion for task: ${task.maintenanceTaskId}');
        await completeMaintenanceTask(task);
        resetCompleteTaskFields();
      } else {
        print('Task is null');
        CustomOverlays.showToastMessage(
            message: 'Task is null', isSuccess: false);
      }
    } else {
      print('Form validation failed');
    }
  }
}