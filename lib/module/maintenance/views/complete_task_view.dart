import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roomrounds/core/apis/models/maintenance_task_model.dart';
import 'package:roomrounds/module/maintenance/controller/maintenance_task_controller.dart';
import 'package:roomrounds/core/constants/app_colors.dart';
import 'package:roomrounds/utils/custom_container.dart';
import 'package:roomrounds/utils/custom_appbar.dart';
import 'package:roomrounds/utils/custome_dialogue.dart';

class CompleteTaskView extends StatelessWidget {
  final MaintenanceTask task;
  const CompleteTaskView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MaintenanceTaskController());
    return CustomContainer(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 100,
        isBackButtun: true,
        title: task.maintenanceTaskName ?? 'Complete Task',
      ),
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.completeTaskFormKey,
            child: CreateTicketDialog(
              title: task.maintenanceTaskName,
              task: null,
              preSelectedEmployee: controller.assignedTo.value,
              selectedUrgent: controller.isUrgent.value,
              textFieldController: controller.commentsController,
              onUrgentChanged: (val) => controller.isUrgent.value = val,
              onSelectItem: (emp) => controller.assignedTo.value = emp,
              onDoneTap: controller.submitCompletion,
              showCompleteOnly: true,
            ),
          ),
        ),
      ),
    );
  }
}
