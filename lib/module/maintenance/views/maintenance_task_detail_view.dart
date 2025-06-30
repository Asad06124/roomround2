import 'package:flutter/material.dart';
import 'package:roomrounds/core/components/sb.dart';
import 'package:roomrounds/module/maintenance/controller/maintenance_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:roomrounds/core/apis/models/tickets/ticket_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/utils/custom_container.dart';

class MaintenanceTaskDetailView extends StatelessWidget {
  final Ticket task;

  const MaintenanceTaskDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(MaintenanceController());

    return CustomContainer(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 100,
        isBackButtun: true,
        title: task.ticketName ?? 'Task Details',
      ),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(
              () => CupertinoSlidingSegmentedControl<int>(
                groupValue: controller.selectedOption.value,
                onValueChanged: (int? value) {
                  if (value != null) {
                    controller.selectOption(value);
                  }
                },
                children: const {
                  0: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text('Complete Task'),
                  ),
                  1: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text('Create Ticket'),
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
                title: task.ticketName,
                task: null, // You may need to adapt this if your dialog expects a RoomTask
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
              title: task.ticketName,
              task: null, // You may need to adapt this if your dialog expects a RoomTask
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
