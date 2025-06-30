import 'package:flutter/cupertino.dart';
import 'package:roomrounds/core/apis/models/tickets/ticket_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/maintenance/maintenance_controller/maintenance_controller.dart';

class MaintenanceTaskDetailView extends StatefulWidget {
  final Ticket task;

  const MaintenanceTaskDetailView({super.key, required this.task});

  @override
  State<MaintenanceTaskDetailView> createState() =>
      _MaintenanceTaskDetailViewState();
}

class _MaintenanceTaskDetailViewState extends State<MaintenanceTaskDetailView> {
  final MaintenanceController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.initTaskDetails(widget.task);
  }

  @override
  void dispose() {
    controller.clearTaskDetails();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 100,
        isBackButtun: true,
        title: widget.task.ticketName ?? 'Task Details',
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CreateTicketDialog(
          title: widget.task.ticketName,
          task: null,
          preSelectedEmployee: null,
          selectedUrgent: controller.isUrgent.value,
          textFieldController: controller.commentsController,
          onUrgentChanged: (val) {
            controller.isUrgent.value = val;
          },
          onSelectItem: (val) {
            controller.assignedTo.value = val;
          },
          onDoneTap: () {
            controller.submitCompletion();
          },
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
          title: widget.task.ticketName,
          task: null,
          preSelectedEmployee: null,
          selectedUrgent: controller.isUrgent.value,
          textFieldController: controller.ticketDescriptionController,
          onUrgentChanged: (val) {
            controller.isUrgent.value = val;
          },
          onSelectItem: (val) {
            controller.assignedTo.value = val;
          },
          onDoneTap: () {
            controller.submitTicketCreation();
          },
        ),
      ),
    );
  }
}
