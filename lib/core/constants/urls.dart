class Urls {
  static const String baseUrl = "http://roomroundapis.rootpointers.net/api";

  // Authentication
  static const String _auth = "/auth";
  static const String login = "$_auth/login";

  // Rooms
  static const String _room = "/room";
  // static const String getAllRooms = "$_room/getAll";

  // Tasks
  static const String _ticket = "/ticket";
  static const String saveTicket = "$_ticket/save";
  static const String getAllRooms = "$_ticket/getAllRooms";
  static const String getAllTasks = "$_ticket/getAllTasks";
  static const String updateTaskStatus = "$_ticket/updateTaskStatus";

  // Departments
  static const String _departments = "/departments";
  static const String getAllDepartments = "$_departments/getAll";

  // Employee
  static const String _employee = "/employee";
  static const String getAllEmployee = "$_employee/getAll";

  // Assistant Manager
  static const String _assistantManager = "/assistantManager";
  static const String removeDepartment = "$_assistantManager/removeDepartment";

  // Settings
  static const String _settings = "/settings";
  static const String updateUser = "$_settings/updateUser";
  static const String updatePassword = "$_settings/updatePassword";
}
