import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roomrounds/core/constants/app_enum.dart';
import 'package:roomrounds/core/apis/models/employee/employee_model.dart';

class MaintenanceTaskController extends GetxController {
  // For Create Ticket
  final createTicketFormKey = GlobalKey<FormState>();
  final ticketDescriptionController = TextEditingController();
  var isUrgent = Rxn<YesNo>();
  var assignedTo = Rxn<Employee>();

  // For Complete Task
  final completeTaskFormKey = GlobalKey<FormState>();
  final commentsController = TextEditingController();

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
  }

  void resetCompleteTaskFields() {
    commentsController.clear();
  }

  void submitTicketCreation() {
    if (createTicketFormKey.currentState?.validate() ?? false) {
      // Add your ticket creation logic here
      Get.back();
      resetTicketFields();
    }
  }

  void submitCompletion() {
    if (completeTaskFormKey.currentState?.validate() ?? false) {
      // Add your completion logic here
      Get.back();
      resetCompleteTaskFields();
    }
  }
} 