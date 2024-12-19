// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/create_ticket/components/create_ticket_components.dart';
import 'package:roomrounds/module/create_ticket/controller/create_ticket_controller.dart';
import 'package:full_screen_image/full_screen_image.dart';

class CreateTicketView extends StatelessWidget with Validators {
  const CreateTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle headingTextStyle =
        context.titleSmall!.copyWith(color: AppColors.black);
    TextStyle bodyTextStyle = context.bodyLarge!.copyWith(color: AppColors.gry);
    bool isManager = profileController.isManager;

    return GetBuilder<CreateTicketController>(
      init: CreateTicketController(),
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppbar.simpleAppBar(
            context,
            height: 70,
            title: AppStrings.createTicket,
            titleStyle: context.titleLarge!.copyWith(color: AppColors.primary),
            backButtunColor: AppColors.primary,
            iconsClor: AppColors.primary,
            isHome: false,
            isBackButtun: true,
            showMailIcon: true,
            notificationActive: true,
            showNotificationIcon: true,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SB.w(context.width),
                        SB.h(10),
                        CustomTextField(
                          validator: validateName,
                          borderColor: AppColors.gry,
                          hintText: AppStrings.enterRoomLocation,
                          controller: controller.roomController,
                        ),
                        SB.h(15),
                        CustomTextField(
                          validator: (v) => null,
                          borderColor: AppColors.gry,
                          hintText: AppStrings.enterFloor,
                          controller: controller.floorController,
                        ),
                        SB.h(15),
                        CreateTicketComponents.customDropdown(
                          context,
                          title: AppStrings.department,
                          hintText: AppStrings.selectDepartment,
                          selectedItem: departmentsController
                              .selectedDepartment?.departmentName
                              ?.trim(),
                          list: departmentsController.getDepartmentsNames(),
                          onSelect: controller.onChangeDepartment,
                        ),
                        CreateTicketComponents.customDropdown(
                          context,
                          title: isManager
                              ? AppStrings.managerOrEmployee
                              : AppStrings.manager,
                          list: controller.employeesNamesList,
                          hintText: AppStrings.selectAssignee,
                          controller: controller.employeeSelectController,
                          // selectedItem:
                          //     controller.selectedEmployee?.employeeName?.trim(),
                          onSelect: controller.onChangeEmployee,
                        ),
                      ],
                    ),
                  ),
                  SB.h(20),
                  Container(
                    width: context.width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: AppColors.black.withOpacity(0.1),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SB.w(context.width),
                        Text(AppStrings.description, style: headingTextStyle),
                        SB.h(10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9.0),
                            border: Border.all(
                              color: AppColors.gry,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  maxLines: 8,
                                  showBorder: false,
                                  fillColor: Colors.transparent,
                                  borderRadius: 16,
                                  validator: (v) => null,
                                  border: Colors.transparent,
                                  borderColor: AppColors.gry,
                                  hintText: AppStrings.writeDescription,
                                  controller: controller.descriptionController,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8.0,
                                  right: 8.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        controller
                                                .recorderController.isRecording
                                            ? AudioWaveforms(
                                                size: Size(80, 50),
                                                waveStyle: WaveStyle(
                                                  showMiddleLine: false,
                                                  extendWaveform: true,
                                                  durationTextPadding: 0.0,
                                                  waveThickness: 2.0,
                                                  waveColor: Colors.green,
                                                  waveCap: StrokeCap.round,
                                                ),
                                                recorderController: controller
                                                    .recorderController,
                                              )
                                            : SizedBox(),
                                        IconButton(
                                          icon: Icon(
                                            controller.recorderController
                                                    .isRecording
                                                ? Icons.stop
                                                : Icons.keyboard_voice_sharp,
                                            color: controller.recorderController
                                                    .isRecording
                                                ? Colors.red
                                                : AppColors.gry,
                                          ),
                                          onPressed: controller
                                                  .recorderController
                                                  .isRecording
                                              ? controller.stopRecording
                                              : controller.startRecording,
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        GestureDetector(
                                          onTap: controller.multiImagePic,
                                          child: Icon(
                                            Icons.camera_alt_rounded,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: AppColors.gry),
                          ),
                          child: Column(
                            children: [
                              controller.selectedImages.isEmpty
                                  ? SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: MediaQuery.sizeOf(context).width,
                                        child: Wrap(
                                          spacing: 10.0,
                                          runSpacing: 10.0,
                                          children: controller.selectedImages
                                              .map((image) {
                                            int index = controller
                                                .selectedImages
                                                .indexOf(image);
                                            return Stack(
                                              children: [
                                                InkWell(
                                                  onTap: () {},
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              FullScreenWidget(
                                                            disposeLevel:
                                                                DisposeLevel
                                                                    .Low,
                                                            child: Hero(
                                                              tag: "",
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                                child:
                                                                    Image.file(
                                                                  image,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Image.file(
                                                      image,
                                                      width: 92,
                                                      height: 92,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  child: GestureDetector(
                                                    onTap: () => controller
                                                        .removeImage(index),
                                                    child: CircleAvatar(
                                                      radius: 8,
                                                      backgroundColor:
                                                          Colors.red,
                                                      child: Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                        size: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: AppColors.gry),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: controller.selectedAudio
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  int index = entry.key;
                                  File audioFile = entry.value;
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              controller.currentlyPlayingIndex ==
                                                      index
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                              color: Colors.green,
                                            ),
                                            onPressed: () => controller
                                                .playAudio(audioFile, index),
                                          ),
                                          if (controller
                                                  .currentlyPlayingIndex ==
                                              index)
                                            Expanded(
                                              child: AudioFileWaveforms(
                                                size: Size.fromHeight(20),
                                                padding: EdgeInsets.all(0.0),
                                                margin: EdgeInsets.all(0.0),
                                                playerController:
                                                    controller.playerController,
                                                enableSeekGesture: true,
                                                waveformType: WaveformType.long,
                                                playerWaveStyle:
                                                    PlayerWaveStyle(
                                                  spacing: 10,
                                                  waveThickness: 2.0,
                                                  liveWaveColor: Colors.green,
                                                ),
                                              ),
                                            ),
                                          if (controller
                                                  .currentlyPlayingIndex !=
                                              index)
                                            Expanded(
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                height: 2.0,
                                                color: Colors.green,
                                              ),
                                            ),
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () =>
                                                controller.deleteAudio(index),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        SB.h(20),
                        GestureDetector(
                          onTap: controller.goToMapView,
                          child: Container(
                            height: context.height * 0.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.white,
                              border: Border.all(
                                color: AppColors.gry,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: controller
                                          .screenshotImageBytes?.isNotEmpty ==
                                      true
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.memory(
                                        controller.screenshotImageBytes!,
                                        width: context.width,
                                        // height: 180,
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Assets.icons.locationPinDrop
                                            .svg(height: 40),
                                        SB.w(10),
                                        Text(AppStrings.selectFromMap,
                                            style: headingTextStyle),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        SB.h(20),
                        Text(AppStrings.urgent, style: headingTextStyle),
                        SB.h(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RoomMapComponents.radioButton<YesNo>(
                              context,
                              YesNo.yes,
                              controller.isUrgent,
                              AppStrings.yes,
                              controller.onUrgentChanged,
                            ),
                            RoomMapComponents.radioButton<YesNo>(
                              context,
                              YesNo.no,
                              controller.isUrgent,
                              AppStrings.no,
                              controller.onUrgentChanged,
                            ),
                            const SizedBox.shrink()
                          ],
                        ),
                        SB.h(20),
                        AppButton.primary(
                          title: AppStrings.send,
                          onPressed: controller.onSendTicketTap,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
