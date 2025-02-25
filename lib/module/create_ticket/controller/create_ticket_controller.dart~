// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:roomrounds/core/apis/api_function.dart';
import 'package:roomrounds/core/apis/models/department/department_model.dart';
import 'package:roomrounds/core/apis/models/employee/employee_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/extensions/string_extension.dart';
import 'package:roomrounds/core/mixins/employee_mixin.dart';
import 'package:roomrounds/module/room_map/views/floor_plan_view.dart';
import 'package:roomrounds/utils/custom_overlays.dart';

class CreateTicketController extends GetxController with EmployeeMixin {
  YesNo? _urgent;

  YesNo? get isUrgent => _urgent;
  List<Employee> _employeeList = [];
  Employee? _selectedEmployee;

  Employee? get selectedEmployee => _selectedEmployee;
  Employee? _initialEmployee;
  int? _initialDepartmentId;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final employeeSelectController = SingleSelectController<String>(null);

  List<String> get employeesNamesList => getEmployeesNamesList(_employeeList);
  final Rxn<Offset> _markerPosition = Rxn<Offset>();
  final GlobalKey _boundaryKey = GlobalKey();
  Uint8List? screenshotImageBytes;
  final double _captureSize = 200.0;
  final ImagePicker _picker = ImagePicker();
  List<File> selectedImages = <File>[];
  List<File> selectedAudio = <File>[];
  String? recordedFilePath;
  int? _currentlyPlayingIndex;

  int? get currentlyPlayingIndex => _currentlyPlayingIndex;
  final RecorderController recorderController = RecorderController();
  final PlayerController playerController = PlayerController();

  @override
  void onInit() {
    super.onInit();
    _initialEmployeeDepartment();
    _resetSelectedDepartment();
    _fetchDepartments();
    recorderController.checkPermission();
    playerController.onCompletion.listen((_) {
      playerController.stopPlayer();
      _currentlyPlayingIndex = null;
      update();
    });

    playerController.setFinishMode(finishMode: FinishMode.stop);
    playerController.preparePlayer(path: recordedFilePath.toString());
  }

  @override
  void dispose() {
    recorderController.dispose();
    playerController.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    if (recorderController.hasPermission) {
      if (selectedAudio.length >= 3) {
        CustomOverlays.showToastMessage(
          message: 'You can only record up to 3 audios.',
          isSuccess: true,
        );
        return;
      }
      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
      try {
        await recorderController.record(path: path);
        recordedFilePath = path;
        update();
      } catch (e) {
        debugPrint("Error starting recording: $e");
      }
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await recorderController.stop();
      if (path != null) {
        selectedAudio.add(File(path));
      }
      update();
    } catch (e) {
      debugPrint("Error stopping recording: $e");
    }
  }

  Future<void> playAudio(File audioFile, int index) async {
    try {
      if (playerController.playerState.isPlaying) {
        await playerController.pausePlayer();
        _currentlyPlayingIndex = null;
      } else {
        await playerController.stopPlayer();
        await playerController.preparePlayer(path: audioFile.path);
        await playerController.startPlayer();
        _currentlyPlayingIndex = index;
      }
      update();
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  // Future<void> playAudio(File audioFile, int index) async {
  //   try {
  //     if (playerController.playerState.isPlaying) {
  //       await playerController.pausePlayer();
  //       _currentlyPlayingIndex = null;
  //     } else {
  //       await playerController.stopPlayer();
  //       await playerController.preparePlayer(path: audioFile.path);
  //       await playerController.startPlayer();
  //       _currentlyPlayingIndex = index;
  //     }
  //     update();
  //   } catch (e) {
  //     debugPrint("Error playing audio: $e");
  //   }
  // }

  void deleteAudio(int index) {
    selectedAudio.removeAt(index);
    update();
  }

  void multiImagePic() async {
    final ImageSource? source = await _showImageSourceDialog();

    if (source == null) return;

    if (source == ImageSource.camera) {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image == null) return;

      if (selectedImages.length >= 3) {
        CustomOverlays.showToastMessage(
          message: 'You have already selected the maximum of 3 images.',
          isSuccess: true,
        );
        return;
      }

      selectedImages.add(File(image.path));
      update();
    } else if (source == ImageSource.gallery) {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 80,
        requestFullMetadata: false,
      );

      if (images.isEmpty) return;

      int remainingSpace = 3 - selectedImages.length;

      if (remainingSpace == 0) {
        CustomOverlays.showToastMessage(
            message: 'You have already selected the maximum of 3 images.');
        return;
      }

      final List<File> newImages =
          images.take(remainingSpace).map((image) => File(image.path)).toList();

      selectedImages.addAll(newImages);

      if (images.length > remainingSpace) {
        CustomOverlays.showToastMessage(
            message: 'Only $remainingSpace more image(s) can be selected.');
      }

      update();
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return await Get.dialog<ImageSource>(
      AlertDialog(
        backgroundColor: AppColors.white,
        title: Text('Choose Image Source'),
        content: Text(
            'Would you like to pick an image from the gallery or capture it using the camera?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: ImageSource.camera),
            child: Text(
              'Camera',
              style: TextStyle(
                color: AppColors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: ImageSource.gallery),
            child: Text(
              'Gallery',
              style: TextStyle(
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    update();
  }

  void _initialEmployeeDepartment() {
    try {
      if (Get.arguments != null) {
        _initialEmployee = Get.arguments?["initialEmployee"] as Employee?;
        _initialDepartmentId = Get.arguments?["initialDepartmentId"] as int?;
      }
    } catch (e) {
      customLogger(
        "$e",
        error: '_initialEmployeeDepartment',
        type: LoggerType.error,
      );
    }
  }

  void _resetSelectedDepartment() {
    departmentsController.onDepartmentSelect(null);
  }

  void _fetchDepartments() async {
    bool isEmployee = profileController.isEmployee;
    bool isManager = profileController.isManager;

    int? departmentId = profileController.departmentId;

    await departmentsController.getDepartments(
      departmentId: isEmployee ? departmentId : _initialDepartmentId,
    );
    Department? myDepartment = departmentsController.selectMyDepartment();

    if (isEmployee) {
      if (myDepartment != null && myDepartment.managerId != null) {
        _employeeList.add(Employee(
          userId: myDepartment.managerId,
          employeeId: myDepartment.managerId,
          employeeName: myDepartment.manager,
          departmentId: myDepartment.departmentId,
          departmentName: myDepartment.departmentName,
        ));

        Future.delayed(Duration(seconds: 1), () {
          _selectedEmployee = _employeeList.firstOrNull;
          employeeSelectController.value =
              _selectedEmployee?.employeeName?.trim();
          update();
        });
      }
    } else if (isManager) {}

    update();
  }

  void _fetchEmployeesFromDepartment() async {
    int? departmentId = departmentsController.selectedDepartmentId;
    // int? myDepartmentId = profileController.departmentId;
    // bool isManager = profileController.isManager;
    // int? managerId = profileController.userId;
    // bool managersOnly = true;
    //
    // if (departmentId != null && myDepartmentId != null) {
    // managersOnly = departmentId != myDepartmentId;
    // }

    List<Employee> resp = await getEmployeeList(
      departmentId: departmentId,
      // managersOnly: managersOnly,
    );

    if (resp.isNotEmpty) {
      _employeeList = List.from(resp);
      if (_initialEmployee != null && _initialEmployee?.userId != null) {
        int empIndex = _employeeList
            .indexWhere((e) => e.userId == _initialEmployee?.userId);
        if (empIndex != -1) {
          _selectedEmployee = _initialEmployee;
          employeeSelectController.value =
              _selectedEmployee?.employeeName?.trim();
        }
      }
      update();
    }
  }

  void onChangeDepartment(String? name) {
    if (name != null) {
      departmentsController.onDepartmentSelect(name);
      _clearEmployees();
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

  void _clearEmployees() {
    employeeSelectController.clear();
    _selectedEmployee = null;
    _employeeList.clear();
    update();
  }

  void goToMapView() {
    String? mapImage;

    String? map = profileController.user?.map;
    if (map != null && map.trim().isNotEmpty) {
      mapImage = map.completeUrl;
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
    } catch (e) {
      customLogger(
        e.toString(),
        type: LoggerType.error,
        error: '_captureScreenshot',
      );
    }
  }

  void onSendTicketTap() async {
    try {
      // Ensure required data is not null
      if (roomController.text.trim().isEmpty) {
        return CustomOverlays.showToastMessage(
          message: 'Please Write Room Name',
        );
      }
      if (_selectedEmployee?.userId == null) {
        return CustomOverlays.showToastMessage(
          message: 'Please Select Employee',
        );
      }
      if (descriptionController.text.trim().isEmpty) {
        return CustomOverlays.showToastMessage(
          message: 'Please Write Description',
        );
      }
      if (_urgent?.index == null) {
        return CustomOverlays.showToastMessage(
          message: 'Please Select Urgent Option',
        );
      }

      // Encode the image
      String base64String = base64.encode(
        screenshotImageBytes ?? [],
      );

      // Prepare the ticket data
      Map<String, String> ticketData = {
        "roomName": roomController.text.trim(),
        "floorName": floorController.text.trim(),
        "assignTo": '${_selectedEmployee?.userId}',
        "description": descriptionController.text.trim(),
        "imageKey": base64String,
        "isUrgent": '${_urgent == YesNo.yes}',
      };

      // API call
      var resp = await APIFunction.call(
        APIMethods.post,
        Urls.saveTicketByEmployee,
        dataMap: ticketData,
        showLoader: true,
        showErrorMessage: true,
        showSuccessMessage: true,
        audioKey: 'AudiosList',
        imageKey: 'ImagesList',
        imageListFile: selectedImages,
        audioListFile: selectedAudio,
      );

      if (resp != null && resp is bool && resp == true) {
        debugPrint("Ticket sent successfully!");
      } else {
        throw Exception('Failed to send the ticket. Please try again.');
      }
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    } finally {
      Get.back(closeOverlays: true);
    }
  }

  void onUrgentChanged(YesNo value) {
    _urgent = value;
    update();
  }
}
