import 'package:roomrounds/module/maintenance/controller/maintenance_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:roomrounds/core/apis/models/maintenance_task_model.dart';
import 'package:roomrounds/core/constants/imports.dart';

class MaintenanceTaskDetailView extends StatelessWidget {
  final MaintenanceTask task;

  const MaintenanceTaskDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MaintenanceController());

    return CustomContainer(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 100,
        isBackButtun: true,
        title: task.maintenanceTaskName ?? 'Task Details',
      ),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(
              () => CupertinoSlidingSegmentedControl<int>(
                backgroundColor: AppColors.lightWhite,
                thumbColor: AppColors.primary,
                groupValue: controller.selectedOption.value,
                onValueChanged: (int? value) {
                  if (value != null) {
                    controller.selectOption(value);
                  }
                },
                children: {
                  0: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      'Complete Task',
                      style: context.bodyMedium?.copyWith(
                          color: controller.selectedOption.value == 0
                              ? AppColors.white
                              : AppColors.primary),
                    ),
                  ),
                  1: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      'Create Ticket',
                      style: context.bodyMedium?.copyWith(
                          color: controller.selectedOption.value == 1
                              ? AppColors.white
                              : AppColors.primary),
                    ),
                  ),
                },
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.selectedOption.value == 0) {
                return _buildCompleteTaskForm(context, controller);
              } else {
                return _buildCreateTicketForm(context, controller);
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleteTaskForm(
      BuildContext context, MaintenanceController controller) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CreateTicketDialog(
            title: task.maintenanceTaskName,
            task:
                null, // You may need to adapt this if your dialog expects a RoomTask
            preSelectedEmployee: null,
            selectedUrgent: null,
            textFieldController: TextEditingController(),
            onUrgentChanged: (_) {},
            onSelectItem: (_) {},
            onDoneTap: () {
              Get.back();
            },
            showCompleteOnly: true,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateTicketForm(
      BuildContext context, MaintenanceController controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CreateTicketDialog(
          title: task.maintenanceTaskName,
          task:
              null, // You may need to adapt this if your dialog expects a RoomTask
          preSelectedEmployee: null,
          selectedUrgent: null,
          textFieldController: TextEditingController(),
          onUrgentChanged: (_) {},
          onSelectItem: (_) {},
          onDoneTap: () {
            Get.back();
          },
        ),
      ),
    );
  }
}
