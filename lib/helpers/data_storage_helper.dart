import 'dart:convert';

import 'package:get_storage/get_storage.dart';

class DataStorageHelper {
  static final box = GetStorage();

  static Future<bool> init() async {
    return GetStorage.init();
  }

  static Future<void> save(String? key, var value) async {
    if (key != null && key.isNotEmpty && value != null) {
      return box.write(key, value);
    }
  }

  static Future<dynamic> get(String? key) async {
    if (key != null && key.isNotEmpty) {
      return box.read(key);
    }
  }

  static Future<void> saveModel(String? key, var value) async {
    if (key != null && key.isNotEmpty && value != null) {
      String json = jsonEncode(value);
      return save(key, json);
    }
  }

  static Future<dynamic> getModel(String? key) async {
    if (key != null && key.isNotEmpty) {
      var data = box.read(key);
      if (data != null) {
        return jsonDecode(data);
      }
    }
  }

  static Future<void> remove(String? key) async {
    if (key != null && key.isNotEmpty) {
      return box.remove(key);
    }
  }

  static Future<void> removeAll() async {
    return box.erase();
  }
}
