// import 'package:roomrounds/core/apis/api_function.dart';
// import 'package:roomrounds/core/apis/models/department/department_model.dart';
// import 'package:roomrounds/core/constants/app_enum.dart';
// import 'package:roomrounds/core/constants/urls.dart';

// mixin DepartmentMixin {
//   Future<List<Department>> getDepartments({int? departmentId}) async {
//     List<Department> departments = [];

//     Map<String, dynamic> data = {
//       // "managerId": managerId,
//       // "managerId": 3, // Testing
//       "departmentId": departmentId,
//       "pageNo": 1,
//       "size": 20,
//       "isPagination": false,
//     };

//     var resp = await APIFunction.call(
//       APIMethods.post,
//       Urls.getAllDepartments,
//       dataMap: data,
//       fromJson: Department.fromJson,
//       showLoader: false,
//       showErrorMessage: false,
//     );

//     if (resp != null && resp is List && resp.isNotEmpty) {
//       departments = List.from(resp);
//     }

//     return departments;
//   }

//   List<String> getDepartmentsNames(List<Department> departments) {
//     List<String> names = [];

//     if (departments.isNotEmpty) {
//       for (var dep in departments) {
//         String? name = dep.departmentName?.trim();
//         if (name != null && name.isNotEmpty) {
//           names.add(name);
//         }
//       }
//     }

//     return names;
//   }
// }
