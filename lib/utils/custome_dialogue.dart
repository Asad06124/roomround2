// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:roomrounds/core/apis/models/employee/employee_model.dart';
import 'package:roomrounds/core/apis/models/tickets/ticket_model.dart';
import 'package:roomrounds/core/components/app_image.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/extensions/datetime_extension.dart';
import 'package:roomrounds/core/extensions/string_extension.dart';
import 'package:roomrounds/module/assigned_task/controller/assigned_task_controller.dart';
import 'package:roomrounds/module/create_ticket/controller/audio_controller.dart';
import 'package:roomrounds/module/emloyee_directory/controller/employee_directory_controller.dart';

import '../module/emloyee_directory/controller/departments_controller.dart';
import '../module/room_list/controller/room_tasks_controller.dart';

class CloseTicketDialouge extends StatefulWidget {
  const CloseTicketDialouge({
    super.key,
    this.ticket,
    this.assighController,
    this.onCloseTap,
    this.showClose = true,
    this.onReplyButtonTap,
    this.sendStatusList = const [
      "Unable to resolve",
      'Need Purchases',
      'Required Outside vendor',
      'Pending',
      'Resolved',
    ],
    this.onRadioTap,
    this.textController,
  });

  final List<String> sendStatusList;
  final Ticket? ticket;
  final GestureTapCallback? onCloseTap;
  final GestureTapCallback? onReplyButtonTap;
  final AssignedTaskController? assighController;
  final bool showClose;
  final Function(int)? onRadioTap;
  final TextEditingController? textController;

  @override
  State<CloseTicketDialouge> createState() => _CloseTicketDialougeState();
}

class _CloseTicketDialougeState extends State<CloseTicketDialouge> {
  late int _selectedIndex;
  late EmployeeDirectoryController employeeDirectoryController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.sendStatusList.indexOf(widget.ticket?.status ?? '');
    if (_selectedIndex == -1) {
      _selectedIndex = -1;
    }

    // Initialize the controller with required parameters
    employeeDirectoryController = Get.put(EmployeeDirectoryController(
      fetchDepartments: true,
      fetchEmployees: true,
    ));
  }

  // EmployeeDirectoryController employeeDirectoryController =
  //     Get.put(EmployeeDirectoryController());

  @override
  Widget build(BuildContext context) {
    String currentUserId = profileController.user!.userId.toString();
    Ticket? ticket = widget.ticket;
    bool isUrgent = ticket?.isUrgent == true;
    return GetBuilder<AudioController>(
        init: AudioController(),
        builder: (controller) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            // height: context.height * 0.75,
            width: context.width,
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DialougeComponents.closeBtn(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        // widget.showClose ? SB.h(15) : SizedBox(),
                        // widget.showClose
                        //     ? DialougeComponents.labelTile(
                        //         context,
                        //         isUnderline: true,
                        //         title: ticket?.ticketName,
                        //         status: AppStrings.close,
                        //         onStatusTap: widget.onCloseTap,
                        //       )
                        //     : SizedBox(),
                        SB.h(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: DialougeComponents.tile(
                                context,
                                title:
                                    currentUserId != ticket?.assignBy.toString()
                                        ? AppStrings.assignedBy
                                        : AppStrings.assignedTo,
                                isDecoration: isUrgent,
                                value: null,
                              ),
                            ),
                            // SB.h(20),
                            Expanded(
                              child: DialougeComponents.nameTile(
                                context,
                                name:
                                    currentUserId != ticket?.assignBy.toString()
                                        ? ticket?.assignByName
                                        : ticket?.assignToName,
                                // desc: ticket?.roomName,
                                image: currentUserId !=
                                        ticket?.assignBy.toString()
                                    ? '${Urls.domain}${ticket?.assignByImage}'
                                    : '${Urls.domain}${ticket?.assignToImage}',
                                //Mohsin
                              ),
                            ),
                          ],
                        ),
                        SB.h(20),
                        if (currentUserId == ticket?.assignBy.toString())
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GetBuilder<DepartmentsController>(
                                builder: (deptController) =>
                                    CustomeDropDown.simple(
                                  context,
                                  hintText: AppStrings.selectDepartment,
                                  initialItem:
                                      deptController.selectedDepartment == null
                                          ? "Department"
                                          : deptController.selectedDepartment
                                              ?.departmentName
                                              ?.trim(),
                                  list: deptController.getDepartmentsNames(),
                                  onSelect: employeeDirectoryController
                                      .onChangeDepartment,
                                ),
                              ),
                              GetBuilder<EmployeeDirectoryController>(
                                builder: (empController) =>
                                    CustomeDropDown.simple(
                                  context,
                                  list: empController.searchResults
                                      .map((e) => e.employeeName ?? '')
                                      .toList(),
                                  hintText: AppStrings.selectAssignee,
                                  onSelect: (value) {
                                    // Find the selected employee object based on the selected name
                                    final selectedEmployee =
                                        empController.searchResults.firstWhere(
                                      (e) => e.employeeName == value,
                                      orElse: () => Employee(
                                          employeeName: '', userId: null),
                                    );

                                    if (selectedEmployee.userId != null) {
                                      Get.find<AssignedTaskController>()
                                          .setSelectedEmployee(
                                              selectedEmployee);
                                    } else {
                                      print(
                                          'No valid employee found for the selected name.');
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        SB.h(20),
                        if (ticket?.roomName != null) ...[
                          DialougeComponents.tile(
                            context,
                            title: 'Room',
                            isDecoration: false,
                            value: null,
                          ),
                          DialougeComponents.detailWithBorder(
                              context, ticket?.roomName ?? ''),
                        ],
                        if (ticket?.ticketName != null) ...[
                          DialougeComponents.tile(
                            context,
                            title: 'Ticket Name',
                            isDecoration: false,
                            value: null,
                          ),
                          DialougeComponents.detailWithBorder(
                              context, ticket?.ticketName ?? ''),
                        ],
                        if (ticket?.comment != null) ...[
                          DialougeComponents.tile(
                            context,
                            title: 'Comment',
                            isDecoration: false,
                            value: null,
                          ),
                          DialougeComponents.detailWithBorder(
                              context, ticket?.comment ?? ''),
                        ],
                        // if (ticket?.roomName != null) ...[
                        //   DialougeComponents.tile(
                        //     context,
                        //     title: 'Room',
                        //     isDecoration: false,
                        //     value: null,
                        //   ),
                        //   DialougeComponents.detailWithBorder(
                        //       context, ticket?.roomName ?? ''),
                        // ],
                        ticket!.ticketMedia!.isNotEmpty
                            ? Row(
                                children: [
                                  SizedBox(
                                    height: 80,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          ticket.ticketMedia?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        final imageUrl =
                                            '${Urls.domain}${ticket.ticketMedia![index].imagekey}';
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CachedNetworkImage(
                                            imageUrl: imageUrl,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.black,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                        ticket.ticketMedia?.isNotEmpty ?? false
                            ? Row(
                                children: ticket.ticketMedia!
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final media = entry.value;
                                  final index = entry.key;
                                  final audioUrl =
                                      '${Urls.domain}/${media.audioKey}';

                                  return Row(
                                    children: [
                                      Obx(() {
                                        if (controller.isLoading.value &&
                                            controller.currentlyPlayingIndex!
                                                    .value ==
                                                index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              right: 20,
                                              top: 5,
                                            ),
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child:
                                                  const CircularProgressIndicator(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          );
                                        }
                                        return IconButton(
                                          icon: Icon(
                                            controller.isPlaying.value &&
                                                    controller
                                                            .currentlyPlayingIndex!
                                                            .value ==
                                                        index
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: Colors.green,
                                          ),
                                          onPressed: () async {
                                            if (audioUrl.isNotEmpty) {
                                              await controller.playAudio(
                                                  audioUrl, index);
                                            } else {
                                              debugPrint(
                                                  'Invalid audio URL for index $index');
                                            }
                                          },
                                        );
                                      }),
                                      Text('Audio ${index + 1}'),
                                    ],
                                  );
                                }).toList(),
                              )
                            : const SizedBox(),
                        SB.h(20),
                        DialougeComponents.reply(
                          context,
                          sendStatusList: widget.sendStatusList,
                          selectedIndex: _selectedIndex,
                          textField: widget.textController
                            ?..text = ticket.reply ?? '',
                          onTap: (index) {
                            setState(() {
                              _selectedIndex = index;
                              widget.onRadioTap!(_selectedIndex);
                            });
                          },
                        ),
                        SB.h(20),
                        AppButton.primary(
                          height: 40,
                          title: AppStrings.done,
                          onPressed: widget.onReplyButtonTap,
                        ),
                        SB.h(10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class ClosedTicketDialouge extends StatelessWidget {
  const ClosedTicketDialouge({super.key, this.ticket});

  final Ticket? ticket;

  @override
  Widget build(BuildContext context) {
    bool isUrgent = ticket?.isUrgent == true;
    DateTime? dateTime = ticket?.assignDate?.toDateTime();
    String? date, time;
    if (dateTime != null) {
      date = dateTime.format();
      time = dateTime.formatTime();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      // height: context.height * 0.75,
      width: context.width,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DialougeComponents.closeBtn(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  SB.h(15),
                  DialougeComponents.labelTile(
                    context,
                    isUnderline: false,
                    title: ticket?.ticketName,
                    status: ticket?.status,
                  ),
                  SB.h(20),
                  DialougeComponents.tile(
                    context,
                    title: AppStrings.assignedBy,
                    isDecoration: isUrgent,
                    value: isUrgent ? AppStrings.urgent : null,
                  ),
                  SB.h(20),
                  DialougeComponents.nameTile(
                    context,
                    name: ticket?.assignByName,
                    desc: ticket?.roomName,
                  ),
                  SB.h(20),
                  DialougeComponents.detailWithBorder(context, ticket?.comment),
                  SB.h(20),
                  DialougeComponents.dateTile(
                    context,
                    label: AppStrings.assignedDate,
                    date: date,
                    time: time,
                  ),
                  SB.h(10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OpenThreadDialogue extends StatelessWidget {
  const OpenThreadDialogue({super.key, this.ticket});

  final Ticket? ticket;

  @override
  Widget build(BuildContext context) {
    bool isUrgent = ticket?.isUrgent == true;
    DateTime? dateTime = ticket?.assignDate?.toDateTime();
    DateTime? completion = ticket?.completionDate?.toDateTime();
    String? date, time, completionDate, completionTime;
    if (dateTime != null) {
      date = dateTime.format();
      time = dateTime.formatTime();
    }
    if (completion != null) {
      completionDate = completion.format();
      completionTime = completion.formatTime();
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      // height: context.height * 0.75,
      width: context.width,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DialougeComponents.closeBtn(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  SB.h(15),
                  DialougeComponents.labelTile(
                    context,
                    isUnderline: true,
                    title: ticket?.ticketName,
                    status: ticket?.status,
                  ),
                  SB.h(20),
                  DialougeComponents.tile(
                    context,
                    title: '${AppStrings.sendTo}:',
                    isDecoration: isUrgent,
                    value: isUrgent ? AppStrings.urgent : null,
                  ),
                  SB.h(20),
                  DialougeComponents.nameTile(
                    context,
                    name: ticket?.assignToName,
                    desc: ticket?.roomName,
                  ),
                  SB.h(20),
                  DialougeComponents.detailWithBorder(context, ticket?.comment),
                  SB.h(20),
                  DialougeComponents.dateTile(
                    context,
                    label: AppStrings.assignedDate,
                    date: date,
                    time: time,
                  ),
                  SB.h(20),
                  DialougeComponents.dateTile(
                    context,
                    label: AppStrings.completionDate,
                    date: completionDate,
                    time: completionTime,
                  ),
                  SB.h(20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.assignment,
                      textAlign: TextAlign.start,
                      style: context.bodyLarge!.copyWith(
                        color: AppColors.gry,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SB.h(10),
                  DialougeComponents.detailWithBorder(
                      context, ticket?.assignTemplateName,
                      borderRadius: 10),
                  SB.h(10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OpenThreadDialogueArgue extends StatelessWidget {
  const OpenThreadDialogueArgue({
    super.key,
    this.ticket,
    this.onSendTap,
    // this.sendStatusList = const [
    //   "Unable to resolve",
    //   'Need Purchases',
    //   'Required Outside vendor',
    //   'Pending',
    //   'Resolved',
    // ],
  });

  final GestureTapCallback? onSendTap;
  final Ticket? ticket;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      // height: context.height * 0.75,
      width: context.width,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DialougeComponents.closeBtn(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SB.h(15),
                  DialougeComponents.labelTile(
                    context,
                    isUnderline: true,
                    title: ticket?.ticketName,
                    status: ticket?.status,
                  ),
                  SB.h(20),
                  DialougeComponents.tile(
                    context,
                    title: AppStrings.assignment,
                    value: ticket?.roomName,
                    isDecoration: false,
                  ),
                  SB.h(20),
                  DialougeComponents.detailWithBorder(
                    context,
                    ticket?.assignTemplateName,
                    borderRadius: 35,
                    bgColor: AppColors.gry.withOpacity(0.24),
                  ),
                  SB.h(20),
                  DialougeComponents.messageTile(context),
                  SB.h(20),
                  DialougeComponents.messageTile(context, sender: false),
                  SB.h(20),
                  /*  Text(
                    "Send status",
                    style: context.titleSmall!.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  SB.h(5),
                  DialougeComponents.sendStatusRadios(
                    context,
                    selectedIndex: _selectedIndex,
                    sendStatusList: widget.sendStatusList,
                    onTap: (v) {
                      setState(() {
                        _selectedIndex = v;
                      });
                    },
                  ),*/
                  SB.h(20),
                  AppButton.primary(
                    title: AppStrings.send,
                    onPressed: onSendTap,
                    height: 40,
                  ),
                  SB.h(10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class YesNoDialog extends StatelessWidget {
  const YesNoDialog(
      {super.key,
      this.title,
      this.yesText,
      this.noText,
      this.onNoPressed,
      this.onYesPressed});

  final String? title, yesText, noText;

  final GestureTapCallback? onYesPressed;
  final GestureTapCallback? onNoPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      // height: context.height * 0.75,
      width: context.width,
      padding: const EdgeInsets.all(20),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DialougeComponents.closeBtn(),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                  title ?? '',
                  textAlign: TextAlign.center,
                  style: context.titleLarge!.copyWith(
                    color: AppColors.black,
                  ),
                ),
                SB.h(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppButton.primary(
                      background: AppColors.primary,
                      title: yesText ?? AppStrings.yes,
                      onPressed: onYesPressed,
                      height: 50,
                      width: context.width * 0.25,
                    ),
                    SB.w(10),
                    AppButton.primary(
                      background: AppColors.primary,
                      title: noText ?? AppStrings.no,
                      onPressed: onNoPressed ?? () => Get.back(),
                      height: 50,
                      width: context.width * 0.25,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CreateTicketDialog extends StatelessWidget {
  const CreateTicketDialog({
    super.key,
    this.title,
    this.selectedUrgent,
    this.onUrgentChanged,
    this.textFieldController,
    required this.onSelectItem,
    this.onDoneTap,
    // this.onImagePicked,
  });

  final String? title;
  final YesNo? selectedUrgent;
  final Function(YesNo)? onUrgentChanged;
  final TextEditingController? textFieldController;
  final dynamic Function(Employee) onSelectItem;
  final GestureTapCallback? onDoneTap;

  @override
  Widget build(BuildContext context) {
    // var controller = Get.find<RoomTasksController>();
    return GetBuilder<RoomTasksController>(
        init: RoomTasksController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              // height: context.height * 0.75,
              width: context.width,
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DialougeComponents.closeBtn(),
                  SB.h(10),
                  DialougeComponents.labelTile(context, title: title),
                  SB.h(10),
                  DialougeComponents.labelTile(
                    context,
                    // isBorder: true,
                    // status: '',
                    title: AppStrings.comments,
                    titleStyle: context.titleSmall!.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.lightWhite,
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
                                maxLines: 5,
                                borderRadius: 10,
                                isRequiredField: false,
                                controller: textFieldController,
                                fillColor: AppColors.lightWhite,
                                borderColor: AppColors.lightWhite,
                                hintText: AppStrings.writeMessage,
                                validator: (value) => null,
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
                                      controller.recorderController.isRecording
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
                                              recorderController:
                                                  controller.recorderController,
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
                                        onPressed: () {
                                          controller.recorderController
                                                  .isRecording
                                              ? controller.stopRecording()
                                              : controller.startRecording();
                                        },
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
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     Assets.icons.cameraCircle.svg(),
                      //     SB.w(10),
                      // Assets.icons.mic.svg(),
                      //     SB.w(10)
                      //   ],
                      // ),

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
                                          int index = controller.selectedImages
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
                                                              DisposeLevel.Low,
                                                          child: Hero(
                                                            tag: "",
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                              child: Image.file(
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
                                                    backgroundColor: Colors.red,
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
                                          onPressed: () => controller.playAudio(
                                              audioFile, index),
                                        ),
                                        controller.currentlyPlayingIndex !=
                                                index
                                            ? Expanded(
                                                child: Container(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                          .width,
                                                  color: AppColors.primary,
                                                  height: 2.0,
                                                ),
                                              )
                                            : Expanded(
                                                child: AudioFileWaveforms(
                                                  size:
                                                      const Size.fromHeight(40),
                                                  padding: EdgeInsets.zero,
                                                  margin: EdgeInsets.zero,
                                                  playerController: controller
                                                      .playerController,
                                                  enableSeekGesture: true,
                                                  waveformType:
                                                      WaveformType.long,
                                                  playerWaveStyle:
                                                      PlayerWaveStyle(
                                                    fixedWaveColor: Colors.grey,
                                                    waveCap: StrokeCap.square,
                                                    liveWaveColor:
                                                        AppColors.primary,
                                                    showSeekLine: true,
                                                    seekLineColor:
                                                        AppColors.red,
                                                  ),
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
                      // SB.h(20),
                      // SB.h(5),
                    ],
                  ),
                  // SB.h(15),
                  DialougeComponents.labelTile(
                    context,
                    // status: '',
                    // isBorder: true,
                    title: AppStrings.directory,
                    titleStyle: context.titleSmall!.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(10),
                  DialougeComponents.labelTile(
                    context,
                    title: AppStrings.changeMember,
                    // isBorder: true,
                    // status: '',
                  ),
                  SB.h(10),
                  // DialougeComponents.nameTile(context, name: "Anthony Roy"),

                  _buildEmployeeDropDown(context),

                  SB.h(10),
                  // DialougeComponents.dateTile(context,
                  //     time: '1:03 PM', date: '11/23/2023'),
                  // SB.h(5),
                  // DialougeComponents.dateTile(context,
                  //     label: 'Completion Date:', time: '1:03 PM', date: '11/23/2023'),
                  // SB.h(10),
                  DialougeComponents.labelTile(
                    context,
                    // status: '',
                    // isBorder: true,
                    title: AppStrings.urgent,
                    titleStyle: context.titleSmall!.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RoomMapComponents.radioButton<YesNo>(
                        context,
                        YesNo.yes,
                        selectedUrgent,
                        AppStrings.yes,
                        onUrgentChanged,
                        width: context.width * 0.35,
                      ),
                      RoomMapComponents.radioButton<YesNo>(
                        context,
                        YesNo.no,
                        selectedUrgent,
                        AppStrings.no,
                        onUrgentChanged,
                      ),
                    ],
                  ),
                  SB.h(20),
                  AppButton.primary(
                    height: 50,
                    width: context.width,
                    title: AppStrings.done,
                    background: AppColors.primary,
                    onPressed: onDoneTap,
                  ),
                  SB.h(10),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildEmployeeDropDown(BuildContext context) {
    return GetBuilder<EmployeeDirectoryController>(
        init: EmployeeDirectoryController(
          fetchEmployees: true,
          fetchDepartments: false,
        ),
        builder: (controller) {
          List<Employee> employees = List.from(controller.searchResults);
          if (employees.isEmpty) {
            User? user = profileController.user;

            if (user != null) {
              employees.add(Employee(
                employeeId: user.userId,
                employeeName: user.username,
                employeeImage: user.image,
              ));
            }
          }

          return CustomeDropDown.simple<Employee>(
            context,
            list: employees,
            borderRadius: 30,
            closedShadow: false,
            width: context.width,
            onSelect: onSelectItem,
            initialItem: employees.firstOrNull,
            closedFillColor: AppColors.lightWhite,
            headerBuilder: (context, selectedItem, enabled) {
              return DialougeComponents.nameTile(
                context,
                isSelected: true,
                name: selectedItem.employeeName,
                image: '${Urls.domain}${selectedItem.imageKey}',
              );
            },
            listItemBuilder: (context, item, isSelected, onItemSelect) {
              return DialougeComponents.nameTile(
                context,
                name: item.employeeName,
                image: '${Urls.domain}${item.imageKey}',
              );
            },
          );
        });
  }
}

///////////////// Manager Side dialogue //////////////////////////

class ThreadTicketDialouge extends StatelessWidget {
  const ThreadTicketDialouge({super.key, this.ticket, this.onCompleteTap});

  final Ticket? ticket;
  final GestureTapCallback? onCompleteTap;

  @override
  Widget build(BuildContext context) {
    bool isUrgent = ticket?.isUrgent == true;
    DateTime? dateTime = ticket?.assignDate?.toDateTime();
    String? date, time;
    if (dateTime != null) {
      date = dateTime.format();
      time = dateTime.formatTime();
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      // height: context.height * 0.75,
      width: context.width,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DialougeComponents.closeBtn(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SB.h(15),
                  DialougeComponents.labelTile(
                    context,
                    isUnderline: true,
                    title: ticket?.ticketName,
                  ),
                  SB.h(20),
                  Text(
                    "${AppStrings.tickets}:",
                    textAlign: TextAlign.start,
                    style: context.bodyLarge!.copyWith(
                      color: AppColors.gry,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(5),
                  DialougeComponents.detailWithBorder(context, ticket?.comment),
                  SB.h(20),
                  DialougeComponents.tile(
                    context,
                    title: '${AppStrings.status}:',
                    value: ticket?.status,
                  ),
                  SB.h(15),
                  DialougeComponents.tile(
                    context,
                    title: '${AppStrings.urgent}:',
                    value: isUrgent ? AppStrings.yes : AppStrings.no,
                    isDecoration: isUrgent,
                    decorationColor: AppColors.greenDark,
                  ),
                  SB.h(20),
                  Text(
                    AppStrings.assignment,
                    textAlign: TextAlign.start,
                    style: context.bodyLarge!.copyWith(
                      color: AppColors.gry,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(15),
                  DialougeComponents.detailWithBorder(
                    context,
                    ticket?.assignTemplateName,
                    borderRadius: 25,
                    textColor: AppColors.textGrey,
                    bgColor: AppColors.lightWhite,
                  ),
                  SB.h(20),
                  Text(
                    AppStrings.assignedTo,
                    textAlign: TextAlign.start,
                    style: context.bodyLarge!.copyWith(
                      color: AppColors.gry,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(15),
                  DialougeComponents.nameTile(context,
                      name: ticket?.assignToName),
                  SB.h(20),
                  DialougeComponents.dateTile(
                    context,
                    label: AppStrings.assignedDate,
                    date: date,
                    time: time,
                  ),
                  SB.h(20),
                  AppButton.primary(
                    background: AppColors.primary,
                    title: AppStrings.completeTask,
                    onPressed: onCompleteTap,
                    width: context.width,
                    height: 50,
                  ),
                  SB.h(10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SeeThreadDialouge extends StatelessWidget {
  const SeeThreadDialouge({super.key, this.ticket, this.onCloseTap});

  final Ticket? ticket;
  final GestureTapCallback? onCloseTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      // height: context.height * 0.75,
      width: context.width,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DialougeComponents.closeBtn(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SB.h(15),
                  DialougeComponents.labelTile(
                    context,
                    isUnderline: true,
                    title: ticket?.ticketName,
                    status: ticket?.status,
                  ),
                  SB.h(20),
                  DialougeComponents.labelTile(
                    context,
                    isUnderline: false,
                    title: AppStrings.assignment,
                    status: ticket?.roomName,
                  ),
                  SB.h(10),
                  DialougeComponents.detailWithBorder(
                    context,
                    ticket?.assignTemplateName,
                    borderRadius: 20,
                    textColor: AppColors.textGrey,
                    bgColor: AppColors.lightWhite,
                  ),
                  SB.h(15),
                  DialougeComponents.messageTile(context),
                  SB.h(10),
                  DialougeComponents.messageTile(context, sender: false),
                  SB.h(20),
                  DialougeComponents.tile(
                    context,
                    title: '${AppStrings.status}:',
                    value: ticket?.status,
                  ),
                  SB.h(15),
                  Text(
                    AppStrings.comments,
                    textAlign: TextAlign.start,
                    style: context.bodyLarge!.copyWith(
                      color: AppColors.gry,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(15),
                  DialougeComponents.detailWithBorder(
                    context,
                    ticket?.comment,
                    borderRadius: 10,
                    textColor: AppColors.textGrey,
                    bgColor: AppColors.lightWhite,
                  ),
                  /*  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.lightWhite,
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextField(
                          maxLines: 2,
                          borderRadius: 0,
                          borderColor: AppColors.lightWhite,
                          hintText: AppStrings.writeComment.capitalizeFirst,
                          isRequiredField: false,
                          validator: (value) => null,
                          fillColor: AppColors.lightWhite,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SB.w(10),
                            Assets.icons.cameraCircle.svg(),
                            SB.w(10),
                            Assets.icons.mic.svg(),
                          ],
                        ),
                        SB.h(5),
                      ],
                    ),
                  ), */
                  SB.h(20),
                  AppButton.primary(
                    background: AppColors.primary,
                    title: AppStrings.close,
                    onPressed: onCloseTap,
                    height: 50,
                    width: context.width,
                  ),
                  SB.h(10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AssignedThreadDialouge extends StatelessWidget {
  const AssignedThreadDialouge({
    super.key,
    this.ticket,
    this.onCompleteTap,
  });

  final Ticket? ticket;
  final GestureTapCallback? onCompleteTap;

  @override
  Widget build(BuildContext context) {
    print('ticket....: ${ticket?.toJson()}');
    bool isUrgent = ticket?.isUrgent == true;
    DateTime? dateTime = ticket?.assignDate?.toDateTime();
    String? date, time;
    if (dateTime != null) {
      date = dateTime.format();
      time = dateTime.formatTime();
    }
    return GetBuilder<AudioController>(
        init: AudioController(),
        builder: (controller) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            // height: context.height * 0.75,
            width: context.width,
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DialougeComponents.closeBtn(
                  //   isDeleteBtn: true,
                  //   onDelete: onDeleteTap,
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SB.h(15),
                        // DialougeComponents.labelTile(
                        //   context,
                        //   isUnderline: false,
                        //   title: ticket?.ticketName,
                        //   // status: ticket?.status,
                        //   statusColor: AppColors.gry,
                        //   titleStyle: context.bodyLarge!.copyWith(
                        //     color: AppColors.textGrey,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                        // SB.h(20),
                        // Text(
                        //   "${AppStrings.ticket}:",
                        //   textAlign: TextAlign.start,
                        //   style: context.bodyLarge!.copyWith(
                        //     color: AppColors.black,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                        // SB.h(5),
                        Row(
                          children: [
                            Text(
                              'RoomName:  ',
                              textAlign: TextAlign.start,
                              style: context.bodyLarge!.copyWith(
                                color: AppColors.gry,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              ticket?.roomName ?? '',
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.bodyLarge!.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SB.h(5),
                        // DialougeComponents.detailWithBorder(
                        //   context,
                        //   ticket?.comment,
                        // ),
                        Text(
                          'Ticket:',
                          textAlign: TextAlign.start,
                          style: context.bodyLarge!.copyWith(
                            color: AppColors.gry,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SB.h(5),
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.gry),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              ticket?.ticketName ?? '',
                              style: context.bodyLarge!.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SB.h(5),
                        ticket?.isClosed == true
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Status :',
                                    textAlign: TextAlign.start,
                                    style: context.bodyLarge!.copyWith(
                                      color: AppColors.gry,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color:
                                          Color(0xffFFC700).withOpacity(0.24),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 5),
                                      child: Text(
                                        ticket?.status.toString() ?? '',
                                        textAlign: TextAlign.start,
                                        style: context.bodyLarge!.copyWith(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                        SB.h(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Urgent :',
                              textAlign: TextAlign.start,
                              style: context.bodyLarge!.copyWith(
                                color: AppColors.gry,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Color(0xff33FF00).withOpacity(0.24),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                child: Text(
                                  ticket?.isUrgent == true ? 'Yes' : 'No',
                                  textAlign: TextAlign.start,
                                  style: context.bodyLarge!.copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        ticket?.isClosed == true
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Response to Your Ticket :',
                                    textAlign: TextAlign.start,
                                    style: context.bodyLarge!.copyWith(
                                      color: AppColors.gry,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SB.h(5),
                                  Container(
                                    width: MediaQuery.sizeOf(context).width,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.gry),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        ticket!.reply.toString(),
                                        style: context.bodyLarge!.copyWith(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                        SB.h(5),
                        DialougeComponents.dateTile(
                          context,
                          label: AppStrings.assignedDate,
                          date: date,
                          time: time,
                        ),
                        SB.h(5),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Color(0xffF1F1F1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: DialougeComponents.nameTile(
                              context,
                              name: ticket?.assignToName,
                              image: '${Urls.domain}${ticket?.assignToImage}',
                              //Image2
                            ),
                          ),
                        ),
                        SB.h(8),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if ((ticket?.ticketMedia
                              ?.where((media) =>
                                  media.imagekey?.isNotEmpty ?? false)
                              .isNotEmpty ??
                          false))
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: ticket?.ticketMedia
                                    ?.where((media) =>
                                        media.imagekey?.isNotEmpty ?? false)
                                    .length ??
                                0,
                            itemBuilder: (context, index) {
                              final imageMedia = ticket!.ticketMedia!
                                  .where((media) =>
                                      media.imagekey?.isNotEmpty ?? false)
                                  .toList()[index];
                              final imageUrl =
                                  '${Urls.domain}${imageMedia.imagekey}';

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FullScreenWidget(
                                          disposeLevel: DisposeLevel.Low,
                                          child: Hero(
                                            tag: "",
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: CachedNetworkImage(
                                                imageUrl: imageUrl,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: AppColors.black,
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.black,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      else
                        const SizedBox(),
                    ],
                  ),
                  ticket?.ticketMedia?.isNotEmpty ?? false
                      ? Row(
                          children:
                              ticket!.ticketMedia!.asMap().entries.map((entry) {
                            final media = entry.value;
                            final index = entry.key;
                            final audioUrl =
                                'http://roomroundapis.rootpointers.net/${media.audioKey}';

                            return Row(
                              children: [
                                Obx(() => IconButton(
                                      icon: Icon(
                                        controller.isPlaying.value &&
                                                controller
                                                        .currentlyPlayingIndex!
                                                        .value ==
                                                    index
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.green,
                                      ),
                                      onPressed: () async {
                                        if (audioUrl.isNotEmpty) {
                                          await controller.playAudio(
                                              audioUrl, index);
                                        } else {
                                          debugPrint(
                                              'Invalid audio URL for index $index');
                                        }
                                      },
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text('Audio ${index + 1}'),
                                ),
                              ],
                            );
                          }).toList(),
                        )
                      : const SizedBox(),
                  ticket?.isClosed == true
                      ? AppButton.primary(
                          height: 40,
                          title: 'Complete Ticket',
                          onPressed: onCompleteTap,
                        )
                      : AppButton.primary(
                          height: 40,
                          title: 'Done',
                          onPressed: () {
                            Get.back();
                          },
                        ),
                ],
              ),

              // Row(
              //   children: [
              //     if ((ticket?.ticketMedia
              //             ?.where((media) =>
              //                 media.imagekey?.isNotEmpty ?? false)
              //             .isNotEmpty ??
              //         false))
              //       SizedBox(
              //         height: 80,
              //         child: ListView.builder(
              //           shrinkWrap: true,
              //           scrollDirection: Axis.horizontal,
              //           itemCount: ticket?.ticketMedia
              //                   ?.where((media) =>
              //                       media.imagekey?.isNotEmpty ??
              //                       false)
              //                   .length ??
              //               0,
              //           itemBuilder: (context, index) {
              //             final imageMedia = ticket!.ticketMedia!
              //                 .where((media) =>
              //                     media.imagekey?.isNotEmpty ?? false)
              //                 .toList()[index];
              //             final imageUrl =
              //                 '${Urls.domain}${imageMedia.imagekey}';

              //             return Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                       builder: (context) =>
              //                           FullScreenWidget(
              //                         disposeLevel: DisposeLevel.Low,
              //                         child: Hero(
              //                           tag: "",
              //                           child: ClipRRect(
              //                             borderRadius:
              //                                 BorderRadius.circular(
              //                                     16),
              //                             child: CachedNetworkImage(
              //                               imageUrl: imageUrl,
              //                               fit: BoxFit.cover,
              //                               placeholder:
              //                                   (context, url) =>
              //                                       Center(
              //                                 child:
              //                                     CircularProgressIndicator(
              //                                   color:
              //                                       AppColors.black,
              //                                 ),
              //                               ),
              //                               errorWidget: (context,
              //                                       url, error) =>
              //                                   Icon(Icons.error),
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                   );
              //                 },
              //                 child: CachedNetworkImage(
              //                   imageUrl: imageUrl,
              //                   fit: BoxFit.cover,
              //                   placeholder: (context, url) => Center(
              //                     child: CircularProgressIndicator(
              //                       color: AppColors.black,
              //                     ),
              //                   ),
              //                   errorWidget: (context, url, error) =>
              //                       Icon(Icons.error),
              //                 ),
              //               ),
              //             );
              //           },
              //         ),
              //       )
              //     else
              //       const SizedBox(),
              //   ],
              // ),

              // ticket?.ticketMedia?.isNotEmpty ?? false
              //     ? Column(
              //         children: ticket!.ticketMedia!
              //             .asMap()
              //             .entries
              //             .map((entry) {
              //           final media = entry.value;
              //           final index = entry.key;
              //           final audioUrl =
              //               'http://roomroundapis.rootpointers.net/${media.audioKey}';

              //           return Row(
              //             children: [
              //               Obx(() {
              //                 if (controller.isLoading.value &&
              //                     controller.currentlyPlayingIndex!
              //                             .value ==
              //                         index) {
              //                   return Padding(
              //                     padding: const EdgeInsets.only(
              //                       right: 20,
              //                       top: 5,
              //                     ),
              //                     child: SizedBox(
              //                       width: 20,
              //                       height: 20,
              //                       child:
              //                           const CircularProgressIndicator(
              //                         color: AppColors.primary,
              //                       ),
              //                     ),
              //                   );
              //                 }
              //                 return IconButton(
              //                   icon: Icon(
              //                     controller.isPlaying.value &&
              //                             controller
              //                                     .currentlyPlayingIndex!
              //                                     .value ==
              //                                 index
              //                         ? Icons.pause
              //                         : Icons.play_arrow,
              //                     color: Colors.green,
              //                   ),
              //                   onPressed: () async {
              //                     if (audioUrl.isNotEmpty) {
              //                       await controller.playAudio(
              //                           audioUrl, index);
              //                     } else {
              //                       debugPrint(
              //                           'Invalid audio URL for index $index');
              //                     }
              //                   },
              //                 );
              //               }),
              //               Text('Audio ${index + 1}'),
              //             ],
              //           );
              //         }).toList(),
              //       )
              //     : const SizedBox(),
              // SB.h(20),
              // Text(
              //   AppStrings.directory,
              //   textAlign: TextAlign.start,
              //   style: context.bodyLarge!.copyWith(
              //     color: AppColors.black,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // SB.h(15),
              // Text(
              //   "${AppStrings.assignedTo}:",
              //   textAlign: TextAlign.start,
              //   style: context.bodyLarge!.copyWith(
              //     color: AppColors.gry,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // SB.h(15),

              // DialougeComponents.dateTile(
              //   context,
              //   label: AppStrings.assignedDate,
              //   date: date,
              //   time: time,
              // ),
              // DialougeComponents.nameTile(
              //   context,
              //   name: ticket?.assignToName,
              //   image: '${Urls.domain}${ticket?.assignToImage}',
              //   //Image2
              // ),
              // SB.h(20),
              // Text(
              //   AppStrings.urgent,
              //   textAlign: TextAlign.start,
              //   style: context.bodyLarge!.copyWith(
              //     color: AppColors.black,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // SB.h(15),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     RoomMapComponents.radioButton<YesNo>(
              //       context,
              //       YesNo.yes,
              //       isUrgent ? YesNo.yes : YesNo.no,
              //       AppStrings.yes,
              //       (value) {},
              //       width: context.width * 0.35,
              //     ),
              //     RoomMapComponents.radioButton<YesNo>(
              //       context,
              //       YesNo.no,
              //       isUrgent ? YesNo.yes : YesNo.no,
              //       AppStrings.no,
              //       (value) {},
              //     ),
              //   ],
              // ),
              // SB.h(15),
            ),
          );
        });
  }
}

class DialougeComponents {
  static Widget labelTile(
    BuildContext context, {
    String? title,
    String? status,
    Color? statusColor,
    TextStyle? titleStyle,
    bool isUnderline = false,
    GestureTapCallback? onStatusTap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Expanded(
            child: Text(
              title,
              style: titleStyle ??
                  context.bodyLarge!.copyWith(
                    color: isUnderline ? AppColors.textGrey : AppColors.gry,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        if (status != null) ...[
          // const Spacer(),
          GestureDetector(
            onTap: onStatusTap,
            child: Text(
              status,
              style: context.titleSmall!.copyWith(
                color: Colors.transparent,
                decoration: isUnderline ? TextDecoration.underline : null,
                decorationColor:
                    isUnderline ? statusColor ?? AppColors.black : null,
                shadows: [
                  BoxShadow(
                    color: statusColor ?? AppColors.black,
                    offset: Offset(0, isUnderline ? -2 : 0.1),
                  )
                ],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  static Widget dateTile(BuildContext context,
      {String? label, String? date, String? time}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label ?? '',
          style: context.bodyLarge!.copyWith(
            color: AppColors.gry,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.gry.withOpacity(0.24),
            borderRadius: BorderRadius.circular(35),
          ),
          child: Text(
            time ?? '',
            style: context.bodySmall!.copyWith(
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SB.w(5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.gry.withOpacity(0.24),
            borderRadius: BorderRadius.circular(35),
          ),
          child: Text(
            date ?? '',
            style: context.bodySmall!.copyWith(
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  static Widget closeBtn(
      {bool isDeleteBtn = false, GestureTapCallback? onDelete}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isDeleteBtn) ...{
          InkWell(
            onTap: onDelete,
            child: Assets.icons.bascket.svg(
                // colorFilter: ColorFilter.mode(
                //   AppColors.red,
                //   BlendMode.srcIn,
                // ),
                ),
          ),
          SB.w(15),
        },
        InkWell(
          onTap: () => Get.back(),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: AppColors.gry),
            ),
            child: const Icon(
              Icons.close,
              color: AppColors.gry,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  static Widget tile(BuildContext context,
      {String? title = 'Assigned by:',
      String? value = "Urgent",
      bool isDecoration = true,
      Color decorationColor = AppColors.yellowDark}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title,
            style: context.bodyLarge!.copyWith(
              color: AppColors.gry,
              fontWeight: FontWeight.w600,
            ),
          ),
        const Spacer(),
        if (value != null)
          Container(
            padding: isDecoration
                ? const EdgeInsets.symmetric(horizontal: 15, vertical: 5)
                : null,
            decoration: isDecoration
                ? BoxDecoration(
                    color: decorationColor.withOpacity(0.24),
                    borderRadius: BorderRadius.circular(35),
                  )
                : null,
            child: Text(
              value,
              style: context.bodyLarge!.copyWith(
                color: isDecoration ? decorationColor : AppColors.gry,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  static Widget nameTile(BuildContext context,
      {String? name,
      String? desc,
      String? image,
      Widget? trailing,
      bool isFilled = false,
      bool isSelected = false}) {
    return Container(
      decoration: isFilled
          ? BoxDecoration(
              color: AppColors.gry.withOpacity(0.24),
              borderRadius: BorderRadius.circular(35),
            )
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // if (image != null && image.trim().isNotEmpty)
          AppImage.network(
            imageUrl: image != null && image.trim().isNotEmpty
                ? image
                : AppImages.personPlaceholder,
            borderRadius: BorderRadius.circular(20),
            fit: BoxFit.cover,
            height: 30,
            width: 30,
            errorWidget: (p0, p1, p2) {
              return AppImage.network(
                imageUrl: AppImages.personPlaceholder,
              );
            },
          ),
          // CircleAvatar(
          //   child: Assets.images.person.image(height: 35, width: 35),
          // ),
          SB.w(6),
          Expanded(
            child: Text(
              name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.bodyLarge!.copyWith(
                color: isSelected ? AppColors.black : AppColors.textGrey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
          // const Spacer(),
          if (desc != null && desc.trim().isNotEmpty)
            Text(
              desc,
              style: context.bodyLarge!.copyWith(
                color: AppColors.textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (trailing != null) trailing,
          SB.w(5),
        ],
      ),
    );
  }

  static Widget detailWithBorder(BuildContext context, String? review,
      {Color? textColor,
      double borderRadius = 10,
      Color? bgColor,
      GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.width,
        decoration: BoxDecoration(
            color: bgColor ?? AppColors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: bgColor ?? AppColors.gry,
            )),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Text(
          review ?? '',
          textAlign: TextAlign.start,
          style: context.bodyLarge!.copyWith(
            color: textColor ?? AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static Widget reply(BuildContext context,
      {List<String>? sendStatusList,
      Function(int v)? onTap,
      int? selectedIndex,
      TextEditingController? textField}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.gry.withOpacity(0.2),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reply",
            style: context.titleSmall!.copyWith(
              color: AppColors.black,
            ),
          ),
          SB.h(10),
          CustomTextField(
            maxLines: 3,
            validator: (value) => null,
            borderColor: AppColors.gry,
            hintText: "Write reply...",
            controller: textField,
          ),
          SB.h(10),
          Text(
            "Send status",
            style: context.titleSmall!.copyWith(
              color: AppColors.black,
            ),
          ),
          if (sendStatusList != null && onTap != null) ...{
            SB.h(10),
            sendStatusRadios(context,
                onTap: (v) => onTap(v),
                selectedIndex: selectedIndex ?? -1,
                sendStatusList: sendStatusList),
          }
        ],
      ),
    );
  }

  static Widget sendStatusRadios(BuildContext context,
      {required int selectedIndex,
      required List<String> sendStatusList,
      required Function(int v) onTap}) {
    return Wrap(
      children: [
        ...List.generate(
          sendStatusList.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: InkWell(
              onTap: () => onTap(index),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 7,
                    backgroundColor: selectedIndex == index
                        ? AppColors.primary
                        : AppColors.gry,
                  ),
                  SB.w(5),
                  Text(
                    sendStatusList[index],
                    maxLines: 2,
                    style: context.bodySmall!.copyWith(color: AppColors.black),
                  ),
                  SB.w(10),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    //  ListView.builder(
    //   itemCount: sendStatusList.length,
    //   shrinkWrap: true,
    //   physics: NeverScrollableScrollPhysics(),
    //   itemBuilder: (BuildContext context, int index) {
    //     return _radioButtton(context, index);
    //   },
    // );
  }

  static Widget messageTile(
    BuildContext context, {
    String msg =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore.',
    String time = '1:03 PM',
    String date = '11/23/2023',
    bool sender = true,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          sender ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (sender) ...{
          CircleAvatar(
            child: Assets.images.person.image(height: 40, width: 40),
          ),
          SB.w(5),
        },
        Column(
          crossAxisAlignment:
              sender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: context.width * 0.50,
              child: Text(
                msg,
                textAlign: TextAlign.justify,
                style: context.bodySmall!.copyWith(
                  color: sender ? AppColors.black : AppColors.textGrey,
                  fontWeight: sender ? FontWeight.w600 : null,
                ),
              ),
            ),
            SB.h(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.gry.withOpacity(0.24),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Text(
                    time,
                    style: context.bodySmall!.copyWith(
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SB.w(5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.gry.withOpacity(0.24),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Text(
                    date,
                    style: context.bodySmall!.copyWith(
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        if (!sender) ...{
          SB.w(5),
          CircleAvatar(
            child: Assets.images.person.image(height: 40, width: 40),
          ),
        },
      ],
    );
  }
}
