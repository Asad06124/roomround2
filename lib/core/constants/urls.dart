class Urls {
  static const String baseUrl = "http://roomroundapis.rootpointers.net/api";

  // Authentication
  static const String _auth = "/auth";
  static const String login = "$_auth/login";

  // Rooms
  static const String _room = "/room";
  static const String getAllRooms = "$_room/getAll";
}
