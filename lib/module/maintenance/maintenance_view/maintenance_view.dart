import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/maintenance/maintenance_controller/maintenance_controller.dart';

class MaintenanceView extends StatefulWidget {
  const MaintenanceView({super.key});

  @override
  State<MaintenanceView> createState() => _MaintenanceViewState();
}

class _MaintenanceViewState extends State<MaintenanceView> {
  final MaintenanceController maintenanceController =
      Get.put(MaintenanceController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        maintenanceController.loadMoreMaintenanceTasks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Tasks'),
      ),
      body: RefreshIndicator(
        onRefresh: maintenanceController.refreshMaintenanceTasks,
        child: Obx(() {
          if (maintenanceController.isLoading.value &&
              maintenanceController.maintenanceTasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (maintenanceController.maintenanceTasks.isEmpty) {
            return const Center(
              child: Text('No maintenance tasks found.'),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: maintenanceController.maintenanceTasks.length + 1,
            itemBuilder: (context, index) {
              if (index == maintenanceController.maintenanceTasks.length) {
                return Obx(() => maintenanceController.isLoadingMore.value
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink());
              }

              final task = maintenanceController.maintenanceTasks[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(task.ticketName ?? 'No Title'),
                  subtitle: Text(
                      '${task.roomName ?? 'N/A'} - ${task.status ?? 'No Status'}'),
                  trailing: Icon(
                    task.isCompleted == true
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color:
                        task.isCompleted == true ? Colors.green : Colors.grey,
                  ),
                  onTap: () {
                    // TODO: Navigate to task details/completion screen
                    Get.toNamed('/task-details', arguments: task);
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
