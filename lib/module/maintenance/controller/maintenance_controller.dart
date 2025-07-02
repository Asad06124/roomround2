import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/maintenance_task_model.dart';
import 'package:roomrounds/core/constants/imports.dart';

class MaintenanceController extends GetxController {
  // For Maintenance Task List
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  var maintenanceTasks = <MaintenanceTask>[].obs;
  var currentPage = 1.obs;
  var hasMorePages = true.obs;
  final int pageSize = 10;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();

  // For Maintenance Task Details
  var selectedTask = Rx<MaintenanceTask?>(null);
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
  var assignedTo = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    startDate.value = DateTime.now();
    endDate.value = startDate.value!.add(const Duration(days: 30));

    getMaintenanceTasks();
  }

  @override
  void onClose() {
    commentsController.dispose();
    ticketDescriptionController.dispose();
    super.onClose();
  }

  void selectTask(MaintenanceTask task) {
    selectedTask.value = task;
    commentsController.text = task.maintenanceTaskCompletes?.comment ?? '';
    // Reset other fields when a new task is selected
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
        '/maintenanceTasks/getMaintenanceActive',
        dataMap: data,
        fromJson: MaintenanceTask.fromJson,
        showLoader: false,
      );

      log('resp type: ${resp.runtimeType}');
      if (resp != null) {
        List<MaintenanceTask> newTasks;
        if (resp is List<MaintenanceTask>) {
          newTasks = resp;
        } else if (resp is List) {
          try {
            newTasks = resp.map((e) => e as MaintenanceTask).toList();
          } catch (e) {
            log('Error casting resp to List<MaintenanceTask>: $e');
            newTasks = [];
          }
        } else {
          newTasks = [];
        }

        // Log task order
        log('newTasks order: ${newTasks.map((t) => "${t.maintenanceTaskName} - ${t.occurrenceDate}").toList()}');

        if (newTasks.isEmpty) {
          hasMorePages.value = false;
        } else {
          log('newTasks: ${newTasks.length}');
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

  void recordAudio() {
    log('Audio recording started...');
  }

  void submitCompletion() {
    if (completeTaskFormKey.currentState!.validate()) {
      log('Submitting completion...');
      Get.back(); // Go back to the maintenance list
    }
  }

  void submitTicketCreation() {
    if (createTicketFormKey.currentState!.validate()) {
      log('Submitting ticket creation...');
      Get.back(); // Go back to the maintenance list
    }
  }

  Map<String, List<MaintenanceTask>> getGroupedMaintenanceTasks() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final tomorrow = now.add(const Duration(days: 1));
    final grouped = <String, List<MaintenanceTask>>{};

    // Group tasks by date
    for (final task in maintenanceTasks) {
      if (task.occurrenceDate == null) continue;

      try {
        final createdAt = DateTime.parse(task.occurrenceDate!);
        String dateKey;

        if (createdAt.year == now.year &&
            createdAt.month == now.month &&
            createdAt.day == now.day) {
          dateKey = 'Today';
        } else if (createdAt.year == yesterday.year &&
            createdAt.month == yesterday.month &&
            createdAt.day == yesterday.day) {
          dateKey = 'Yesterday';
        } else if (createdAt.year == tomorrow.year &&
            createdAt.month == tomorrow.month &&
            createdAt.day == tomorrow.day) {
          dateKey = 'Tomorrow';
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

    // Sort tasks within each group by occurrenceDate (ascending)
    grouped.forEach((key, tasks) {
      tasks.sort((a, b) {
        final dateA = DateTime.parse(a.occurrenceDate!);
        final dateB = DateTime.parse(b.occurrenceDate!);
        return dateA.compareTo(dateB); // Ascending order within group
      });
    });

    // Define the order of keys: Today, Yesterday, Tomorrow, then other dates
    final sortedKeys = <String>[];
    if (grouped.containsKey('Today')) sortedKeys.add('Today');
    if (grouped.containsKey('Yesterday')) sortedKeys.add('Yesterday');
    if (grouped.containsKey('Tomorrow')) sortedKeys.add('Tomorrow');

    // Add other dates in ascending order
    final otherKeys = grouped.keys
        .where((key) => !['Today', 'Yesterday', 'Tomorrow'].contains(key))
        .toList()
      ..sort((a, b) {
        try {
          final dateA = DateFormat('MMMM d, yyyy').parse(a);
          final dateB = DateFormat('MMMM d, yyyy').parse(b);
          return dateA.compareTo(dateB); // Ascending order
        } catch (e) {
          return 0;
        }
      });

    sortedKeys.addAll(otherKeys);

    // Create sorted grouped map
    final sortedGrouped = <String, List<MaintenanceTask>>{};
    for (final key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }

    return sortedGrouped;
  }
}
