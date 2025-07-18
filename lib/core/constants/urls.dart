class Urls {
  static const String domain = "https://apis.roomrounds.com";
  static const String apiBaseUrl = "$domain/api";

  // Authentication
  static const String _auth = "/auth";
  static const String login = "$_auth/login";
  static const String forget = "$_auth/forgetPassword?email=";
  static const String fcmToken = "$_auth/setFcmToken?fcmToken";

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
  static const String ticketStatus = "/lookup/getAll";
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
  static const String deleteAllNotifications = "$_notification/delete";
  static const String readAllNotifications = "$_notification/readAll";
  static const String deleteSingleNotification = "$_notification/delete";

  // Assistant Manager
  static const String _assistantManager = "/assistantManager";
  static const String removeDepartment = "$_assistantManager/removeDepartment";

  // Settings
  static const String _settings = "/settings";
  static const String updateUser = "$_settings/updateUser";
  static const String updatePassword = "$_settings/updatePassword";
  static const String getUserProfile = "$_settings/getUserProfile";
//Push Notification
// static const String setFcmToken = "$_auth/setFcmToken";
// auth/setFcmToken?fcmToken=
}
