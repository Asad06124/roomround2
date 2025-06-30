import 'dart:developer';

import 'package:get/get.dart';
import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/tickets/ticket_model.dart';
import 'package:roomrounds/core/apis/models/tickets/tickets_list_model.dart';
import 'package:roomrounds/core/constants/imports.dart';

class MaintenanceController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  var maintenanceTasks = <Ticket>[].obs;
  var currentPage = 1.obs;
  var hasMorePages = true.obs;
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    getMaintenanceTasks();
  }

  void resetPagination() {
    currentPage.value = 1;
    hasMorePages.value = true;
    maintenanceTasks.clear();
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
}
