// import '../constants/imports.dart';

// mixin LocalStorageMixin {
//   void storeDataLocally(key, data) {
//     storageBox.write(key, data);
//   }

//   dynamic getLocalData(key) async {
//     final data = await storageBox.read(key);
//     debugPrint("$key: $data");
//     return data;
//   }

//   void initializeGlobalVariables(UserData data) {
//     // authToken = data.accessToken ?? "";
//     // isFacility = data.facility?.roleType == 1;
//     // loginData = data;
//   }

//   void removeLocalData() {
//     storageBox.erase();
//     userData = UserData();
//   }
// }
