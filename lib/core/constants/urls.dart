class Urls {
  static const String domain = "http://roomroundapis.rootpointers.net";
  static const String apiBaseUrl = "$domain/api";

  // Authentication
  static const String _auth = "/auth";
  static const String login = "$_auth/login";

  // Rooms
  // static const String _room = "/room";
  // static const String getAllRooms = "$_room/getAll";

  // Tasks
  static const String _ticket = "/ticket";
  static const String saveTicket = "$_ticket/save";
  static const String getAllTickets = "$_ticket/getAll";
  static const String getAllRooms = "$_ticket/getAllRooms";
  static const String getAllTasks = "$_ticket/getAllTasks";
  static const String updateTaskStatus = "$_ticket/updateTaskStatus";
  static const String saveTicketByEmployee = "$_ticket/saveByEmployee";
  static const String updateTicketStatus = "$_ticket/updateTicketStatus";
  static const String deleteTicket = "$_ticket/delete";
  static const String updateIsCompletedTickets =
      "$_ticket/updateIsCompletedTickets";

  // Departments
  static const String _departments = "/departments";
  static const String getAllDepartments = "$_departments/getAll";

  // Employee
  static const String _employee = "/employee";
  static const String getAllEmployee = "$_employee/getAll";

  // Notifications
  static const String _notification = "/notification";
  static const String getAllNotifications = "$_notification/getAll";
  static const String readAllNotifications = "$_notification/readAll";
  static const String readNotification = "$_notification/read";

  // Assistant Manager
  static const String _assistantManager = "/assistantManager";
  static const String removeDepartment = "$_assistantManager/removeDepartment";

  // Settings
  static const String _settings = "/settings";
  static const String updateUser = "$_settings/updateUser";
  static const String updatePassword = "$_settings/updatePassword";
}
