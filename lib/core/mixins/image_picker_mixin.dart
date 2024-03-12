// import 'dart:io';
 


// mixin ImagePickerMixin{
//    Future<File?> pickImage({required bool isCamera}) async {


//     // bool permissionAllowed = await PermissionHandler.permission(
//     //     permission: isCamera == true
//     //         ? Permission.camera
//     //         : Platform.isIOS
//     //             ? Permission.photos
//     //             : Permission.storage);
//     ImagePicker imagePicker = ImagePicker();
//     File? imageFile;
//     XFile? pickedFile;
//     //if (permissionAllowed == true) {
//     pickedFile = await imagePicker.pickImage(
//       source: isCamera ? ImageSource.camera : ImageSource.gallery,
//     );
//     // }
//     //else {}

//     if (pickedFile != null) {
//       imageFile = await _cropImage(pickedFile);
//     }
//     return imageFile;
//   }

//    Future<File?> _cropImage(XFile? pickedFile) async {
//     if (pickedFile == null) return null;

//     File? imageFile;

//     CroppedFile? croppedFile = await ImageCropper().cropImage(
//       sourcePath: pickedFile.path,
//       aspectRatioPresets: Platform.isAndroid
//           ? [
//         CropAspectRatioPreset.square,
//         CropAspectRatioPreset.ratio3x2,
//         CropAspectRatioPreset.original,
//         CropAspectRatioPreset.ratio4x3,
//         CropAspectRatioPreset.ratio16x9
//       ]
//           : [
//         CropAspectRatioPreset.original,
//         CropAspectRatioPreset.square,
//         CropAspectRatioPreset.ratio3x2,
//         CropAspectRatioPreset.ratio4x3,
//         CropAspectRatioPreset.ratio5x3,
//         CropAspectRatioPreset.ratio5x4,
//         CropAspectRatioPreset.ratio7x5,
//         CropAspectRatioPreset.ratio16x9
//       ],
//       uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: 'Cropper',
//           toolbarColor: AppColors.primary,
//           toolbarWidgetColor: AppColors.white,
//           activeControlsWidgetColor: AppColors.black,
//           initAspectRatio: CropAspectRatioPreset.original,
//           lockAspectRatio: false,
//         ),
//         IOSUiSettings(title: 'Cropper'),
//       ],
//     );

//     if (croppedFile != null) {
//       File? file = File(croppedFile.path);
//       imageFile = file;
//     }
//     return imageFile;
//   }
// }