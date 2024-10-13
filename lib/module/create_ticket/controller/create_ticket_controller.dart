import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/department/department_model.dart';
import 'package:roomrounds/core/apis/models/employee/employee_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/constants/utilities.dart';
import 'package:roomrounds/core/mixins/employee_mixin.dart';
import 'package:roomrounds/module/room_map/views/floor_plan_view.dart';
import 'dart:ui' as ui;

import 'package:roomrounds/utils/custom_overlays.dart';

class CreateTicketController extends GetxController with EmployeeMixin {
  YesNo? _urgent;
  YesNo? get isUrgent => _urgent;

  // Department? _selectedDepartment;
  // Department? get selectedDepartment => _selectedDepartment;

  List<Employee> _employeeList = [];
  List<Employee> get employeeList => _employeeList;
  Employee? _selectedEmployee;
  Employee? get selectedEmployee => _selectedEmployee;

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<String> get employeesNamesList => getEmployeesNamesList(_employeeList);

  Rxn<Offset> _markerPosition = Rxn<Offset>();
  GlobalKey _boundaryKey = GlobalKey();
  Uint8List? screenshotImageBytes; // Store the screenshot image in memory
  double _captureSize =
      200.0; // Size of the square to capture around the marker

  @override
  void onInit() {
    super.onInit();
    _resetSelectedDepartment();
    _fetchDepartments();
  }

  void _resetSelectedDepartment() {
    departmentsController.onDepartmentSelect(null);
  }

  void _fetchDepartments() async {
    bool isEmployee = profileController.isEmployee;
    bool isManager = profileController.isManager;

    int? departmentId = profileController.departmentId;
    // For Employee Get only My Department
    // For Manager Get All Departments
    List<Department> departments = await departmentsController.getDepartments(
      departmentId: isEmployee ? departmentId : null,
    );
    Department? myDepartment;
    if (departments.isNotEmpty) {
      myDepartment = departments
          .firstWhereOrNull((item) => item.departmentId == departmentId);
      departmentsController.onDepartmentSelect(myDepartment?.departmentName);
    }

    if (isEmployee) {
      // For Employee Select his manager from his department
      if (myDepartment != null && myDepartment.managerId != null) {
        _employeeList.add(Employee(
          userId: myDepartment.managerId,
          employeeId: myDepartment.managerId,
          employeeName: myDepartment.manager,
          departmentId: myDepartment.departmentId,
          departmentName: myDepartment.departmentName,
        ));
        _selectedEmployee = _employeeList.firstOrNull;
      }
    } else if (isManager) {
      // For Manager Fetch his employees from his department
      _fetchEmployeesFromDepartment();
    }

    update();
  }

  void _fetchEmployeesFromDepartment() async {
    int? departmentId = departmentsController.selectedDepartmentId;
    int? myDepartmentId = profileController.departmentId;
    bool isManager = profileController.isManager;
    int? managerId = profileController.userId;
    bool managersOnly = true;

    if (isManager && departmentId != null && myDepartmentId != null) {
      // if other department selected then Managers Only
      // if My Department matched then just my employee
      managersOnly = departmentId != myDepartmentId;
    }

    List<Employee> resp = await getEmployeeList(
      departmentId: departmentId,
      managersOnly: managersOnly,
      // managerId: isManager ? managerId : null,
    );

    if (resp.isNotEmpty) {
      _employeeList = List.from(resp);
      update();
    }
  }

  void onChangeDepartment(String? name) {
    if (name != null) {
      departmentsController.onDepartmentSelect(name);
      _fetchEmployeesFromDepartment();
    }
  }

  void onChangeEmployee(String? name) {
    if (name != null && name.trim().isNotEmpty) {
      if (_employeeList.isNotEmpty) {
        Employee? employee = _employeeList
            .firstWhereOrNull((emp) => emp.employeeName?.trim() == name);
        if (employee != null) {
          _selectedEmployee = employee;
        }
      }
    } else {
      _selectedEmployee = null;
    }
  }

  void goToMapView() {
    String? mapImage;

    String? map = profileController.user?.map;
    if (map != null && map.trim().isNotEmpty) {
      if (map.isURL) {
        mapImage = map;
      }
    }
    Get.to(() => Obx(() => FloorPlanView(
          image: mapImage,
          boundaryKey: _boundaryKey,
          markerPosition: _markerPosition.value,
          onMarkerChange: _onMarkerPositionChanged,
          onDoneTap: _captureScreenshot,
        )));
  }

  void _onMarkerPositionChanged(Offset? offset) {
    if (offset != null) {
      _markerPosition.value = offset;
    }
  }

  void _captureScreenshot() async {
    try {
      Get.back();
      Offset? markerPosition = _markerPosition.value;
      if (markerPosition == null) return;

      RenderRepaintBoundary boundary = _boundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      // Capture the full image from the boundary
      ui.Image fullImage = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData =
          await fullImage.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Calculate cropping area based on the marker position
      double captureLeft = (markerPosition.dx * 2) -
          _captureSize; // Multiplied by 2 due to pixelRatio
      double captureTop = (markerPosition.dy * 2) -
          _captureSize; // Multiplied by 2 due to pixelRatio
      captureLeft = captureLeft.clamp(
          0, fullImage.width - _captureSize * 2); // Ensure bounds
      captureTop = captureTop.clamp(
          0, fullImage.height - _captureSize * 2); // Ensure bounds

      // Crop the square area around the marker
      ui.PictureRecorder recorder = ui.PictureRecorder();
      Canvas canvas = Canvas(recorder);
      Rect srcRect = Rect.fromLTWH(captureLeft, captureTop, _captureSize * 2,
          _captureSize * 2); // Cropped area
      Rect dstRect = Rect.fromLTWH(
          0, 0, _captureSize * 2, _captureSize * 2); // Destination for drawing
      canvas.drawImageRect(fullImage, srcRect, dstRect, Paint());
      ui.Image croppedImage = await recorder
          .endRecording()
          .toImage(_captureSize.toInt() * 2, _captureSize.toInt() * 2);

      // Convert cropped image to bytes
      ByteData? croppedByteData =
          await croppedImage.toByteData(format: ui.ImageByteFormat.png);
      Uint8List croppedPngBytes = croppedByteData!.buffer.asUint8List();

      customLogger("Cropped image: ${croppedPngBytes.length}");

      if (croppedPngBytes.isNotEmpty) {
        screenshotImageBytes = croppedPngBytes;
        update();
      }

      /* // Save the cropped image to the device
      final directory = (await getApplicationDocumentsDirectory()).path;
      File imgFile = File('$directory/screenshot_cropped.png');
      await imgFile.writeAsBytes(croppedPngBytes);

      // Show a snackbar to notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Screenshot saved to $directory/screenshot_cropped.png')),
      ); */
    } catch (e) {
      customLogger(
        e.toString(),
        type: LoggerType.error,
        error: '_captureScreenshot',
      );
    }
  }

  void onSendTicketTap() async {
    if (formKey.validateFields) {
      if (_selectedEmployee != null) {
        if (screenshotImageBytes != null &&
            screenshotImageBytes?.isNotEmpty == true) {
          String? base64String = base64.encode(screenshotImageBytes!);
          Map<String, dynamic> data = {
            "roomName": roomController.text.trim(),
            "floorName": floorController.text.trim(),
            "assignTo": _selectedEmployee?.userId,
            "description": descriptionController.text.trim(),
            "imageKey": base64String,
            "isUrgent": _urgent == YesNo.yes,
          };

          var resp = await APIFunction.call(
            APIMethods.post,
            Urls.saveTicketByEmployee,
            dataMap: data,
            showLoader: true,
            showErrorMessage: true,
            showSuccessMessage: true,
          );

          if (resp != null && resp is bool && resp == true) {
            Get.back();
          }
        } else {
          CustomOverlays.showToastMessage(
              message: AppStrings.pleaseSelectFromMap);
        }
      } else {
        CustomOverlays.showToastMessage(
            message: AppStrings.pleaseSelectEmployee);
      }
    }
  }

  void onUrgentChanged(YesNo value) {
    _urgent = value;
    update();
  }
}
