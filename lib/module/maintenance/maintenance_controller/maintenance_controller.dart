import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/tickets/ticket_model.dart';
import 'package:roomrounds/core/apis/models/tickets/tickets_list_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:intl/intl.dart';

class MaintenanceController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  var maintenanceTasks = <Ticket>[].obs;
  var currentPage = 1.obs;
  var hasMorePages = true.obs;
  final int pageSize = 10;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();

  // For Task Details
  var selectedTask = Rx<Ticket?>(null);
  // 0 for Complete Task, 1 for Create Ticket
  var selectedOption = 0.obs;

  // For Complete Task
  final completeTaskFormKey = GlobalKey<FormState>();
  final commentsController = TextEditingController();
  var imageFile = Rx<File?>(null);
  var audioFile = Rx<File?>(null);
  var documentFile = Rx<File?>(null);

  // For Create Ticket
  final createTicketFormKey = GlobalKey<FormState>();
  final ticketDescriptionController = TextEditingController();
  var isUrgent = false.obs;
  // This would be populated from your employee list
  var assignedTo = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    endDate.value = DateTime.now();
    startDate.value = endDate.value!.subtract(const Duration(days: 30));
    getMaintenanceTasks();
  }

  void resetPagination() {
    currentPage.value = 1;
    hasMorePages.value = true;
  }

  void updateDateFilters({required DateTime start, required DateTime end}) {
    startDate.value = start;
    endDate.value = end;
    getMaintenanceTasks(refresh: true);
  }

  Future<void> getMaintenanceTasks({bool refresh = false}) async {
    if (refresh) {
      resetPagination();
    }

    if (isLoading.value || isLoadingMore.value) return;
    if (!hasMorePages.value && !refresh) return;

    if (currentPage.value == 1) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    final data = {
      "pageNo": currentPage.value,
      "size": pageSize,
      "isPagination": true,
      "startDate": startDate.value?.toIso8601String(),
      "endDate": endDate.value?.toIso8601String(),
    };

    try {
      final resp = await APIFunction.call(
        APIMethods.post,
        Urls.getAllTickets,
        dataMap: data,
        fromJson: TicketsListModel.fromJson,
        showLoader: false,
      );

      if (resp != null && resp is TicketsListModel) {
        final newTasks = resp.tickets ?? [];

        if (newTasks.isEmpty) {
          hasMorePages.value = false;
        } else {
          if (refresh || currentPage.value == 1) {
            maintenanceTasks.assignAll(newTasks);
          } else {
            maintenanceTasks.addAll(newTasks);
          }

          if (newTasks.length < pageSize) {
            hasMorePages.value = false;
          } else {
            currentPage.value++;
          }
        }
        maintenanceTasks.refresh();
      } else {
        if (currentPage.value == 1) {
          maintenanceTasks.clear();
        }
        Get.snackbar('Error', 'Failed to load maintenance tasks');
      }
    } catch (e) {
      log('Error in getMaintenanceTasks: $e');
      if (currentPage.value == 1) {
        Get.snackbar('Error', 'Failed to load maintenance tasks');
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreMaintenanceTasks() async {
    if (hasMorePages.value && !isLoading.value && !isLoadingMore.value) {
      await getMaintenanceTasks();
    }
  }

  Future<void> refreshMaintenanceTasks() async {
    await getMaintenanceTasks(refresh: true);
  }

  Map<String, List<Ticket>> getGroupedMaintenanceTasks() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final grouped = <String, List<Ticket>>{};

    for (final task in maintenanceTasks) {
      if (task.assignDate == null) continue;

      try {
        final createdAt = DateTime.parse(task.assignDate!);
        String dateKey;

        if (createdAt.year == now.year &&
            createdAt.month == now.month &&
            createdAt.day == now.day) {
          dateKey = 'Today';
        } else if (createdAt.year == yesterday.year &&
            createdAt.month == yesterday.month &&
            createdAt.day == yesterday.day) {
          dateKey = 'Yesterday';
        } else {
          dateKey = DateFormat('MMMM d, yyyy').format(createdAt);
        }

        if (!grouped.containsKey(dateKey)) {
          grouped[dateKey] = [];
        }
        grouped[dateKey]!.add(task);
      } catch (e) {
        log('Error parsing date for task: $e');
      }
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        if (a == 'Today') return -1;
        if (b == 'Today') return 1;
        if (a == 'Yesterday') return -1;
        if (b == 'Yesterday') return 1;
        try {
          final dateA = DateFormat('MMMM d, yyyy').parse(a);
          final dateB = DateFormat('MMMM d, yyyy').parse(b);
          return dateB.compareTo(dateA);
        } catch (e) {
          return 0;
        }
      });

    final sortedGrouped = <String, List<Ticket>>{};
    for (final key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }

    return sortedGrouped;
  }

  void selectTask(Ticket task) {
    selectedTask.value = task;
    commentsController.text = task.comment ?? '';
    // Reset fields when a new task is selected
    imageFile.value = null;
    audioFile.value = null;
    documentFile.value = null;
    ticketDescriptionController.clear();
    isUrgent.value = false;
    assignedTo.value = null;
    selectedOption.value = 0;
  }

  void clearSelectedTask() {
    selectedTask.value = null;
    commentsController.clear();
    imageFile.value = null;
    audioFile.value = null;
    documentFile.value = null;
    ticketDescriptionController.clear();
  }

  // Methods from MaintenanceTaskDetailController

  void selectOption(int index) {
    selectedOption.value = index;
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
      }
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  Future<void> pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      if (result != null) {
        documentFile.value = File(result.files.single.path!);
      }
    } catch (e) {
      log('Error picking document: $e');
    }
  }

  // Placeholder for audio recording logic
  void recordAudio() {
    // Implement audio recording logic here
    log('Audio recording started...');
  }

  void submitCompletion() {
    if (completeTaskFormKey.currentState!.validate()) {
      // Handle submission logic for completing the task
      log('Submitting completion...');
      // Example API call
      /*
      APIFunction.call(
        APIMethods.post,
        'your_completion_endpoint',
        dataMap: {
          'taskId': selectedTask.value?.ticketId,
          'comments': commentsController.text,
        },
        imageFile: imageFile.value,
        audioFile: audioFile.value,
        otherFile: documentFile.value,
      );
      */
      Get.back(); // Go back to the maintenance list
    }
  }

  void submitTicketCreation() {
    if (createTicketFormKey.currentState!.validate()) {
      // Handle submission logic for creating a ticket
      log('Submitting ticket creation...');
      /*
      APIFunction.call(
        APIMethods.post,
        'your_ticket_creation_endpoint',
        dataMap: {
          'taskId': selectedTask.value?.ticketId,
          'description': ticketDescriptionController.text,
          'isUrgent': isUrgent.value,
          'assignedTo': assignedTo.value,
        },
      );
      */
      Get.back(); // Go back to the maintenance list
    }
  }

  @override
  void onClose() {
    commentsController.dispose();
    ticketDescriptionController.dispose();
    super.onClose();
  }
}
