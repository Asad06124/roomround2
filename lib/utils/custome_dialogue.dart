import 'package:roomrounds/core/apis/models/employee/employee_model.dart';
import 'package:roomrounds/core/apis/models/tickets/ticket_model.dart';
import 'package:roomrounds/core/components/app_image.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/extensions/datetime_extension.dart';
import 'package:roomrounds/core/extensions/string_extension.dart';
import 'package:roomrounds/module/assigned_task/controller/assigned_task_controller.dart';
import 'package:roomrounds/module/emloyee_directory/controller/employee_directory_controller.dart';

class CloseTicketDialouge extends StatefulWidget {
  const CloseTicketDialouge({
    super.key,
    this.ticket,
    this.controller,
    this.onCloseTap,
    this.onReplyButtonTap,
    this.sendStatusList = const [
      "Unable to resolve",
      'Need Purchases',
      'Required Outside vendor',
      'Pending',
      'Resolved',
    ],
  });

  final List<String> sendStatusList;
  final Ticket? ticket;
  final GestureTapCallback? onCloseTap;
  final GestureTapCallback? onReplyButtonTap;
  final AssignedTaskController? controller;

  @override
  State<CloseTicketDialouge> createState() => _CloseTicketDialougeState();
}

class _CloseTicketDialougeState extends State<CloseTicketDialouge> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    Ticket? ticket = widget.ticket;
    bool isUrgent = ticket?.isUrgent == true;
    // DateTime? dateTime = ticket?.assignDate?.toDateTime();
    // String? date, time;
    // if (dateTime != null) {
    //   date = dateTime.format();
    //   time = dateTime.formatTime();
    // }
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  SB.h(15),
                  DialougeComponents.labelTile(
                    context,
                    isUnderline: true,
                    title: ticket?.ticketName,
                    status: AppStrings.close,
                    onStatusTap: widget.onCloseTap,
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
                  DialougeComponents.reply(
                    context,
                    sendStatusList: widget.sendStatusList,
                    selectedIndex: _selectedIndex,
                    onTap: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                  SB.h(20),
                  AppButton.primary(
                    height: 40,
                    title: AppStrings.send,
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
  const CreateTicketDialog(
      {super.key,
      this.title,
      this.selectedUrgent,
      this.onUrgentChanged,
      this.textFieldController,
      required this.onSelectItem,
      this.onDoneTap});
  final String? title;
  final YesNo? selectedUrgent;
  final Function(YesNo)? onUrgentChanged;
  final TextEditingController? textFieldController;
  final dynamic Function(Employee) onSelectItem;
  final GestureTapCallback? onDoneTap;

  @override
  Widget build(BuildContext context) {
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
            Container(
              // padding: const EdgeInsets.all(3),
              // decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(10),
              // color: AppColors.lightWhite,
              // ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    maxLines: 5,
                    borderRadius: 10,
                    isRequiredField: false,
                    controller: textFieldController,
                    fillColor: AppColors.lightWhite,
                    borderColor: AppColors.lightWhite,
                    hintText: AppStrings.writeMessage,
                    validator: (value) => null,
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
                  // SB.h(5),
                ],
              ),
            ),
            SB.h(15),
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
                image: selectedItem.employeeImage,
              );
            },
            listItemBuilder: (context, item, isSelected, onItemSelect) {
              return DialougeComponents.nameTile(
                context,
                name: item.employeeName,
                image: item.employeeImage,
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
  const AssignedThreadDialouge({super.key, this.ticket, this.onDeleteTap});
  final Ticket? ticket;
  final GestureTapCallback? onDeleteTap;

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
            DialougeComponents.closeBtn(
              isDeleteBtn: true,
              onDelete: onDeleteTap,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SB.h(15),
                  DialougeComponents.labelTile(
                    context,
                    isUnderline: false,
                    title: ticket?.ticketName,
                    status: ticket?.status,
                    statusColor: AppColors.gry,
                    titleStyle: context.bodyLarge!.copyWith(
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(20),
                  Text(
                    "${AppStrings.ticket}:",
                    textAlign: TextAlign.start,
                    style: context.bodyLarge!.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(5),
                  DialougeComponents.detailWithBorder(context, ticket?.comment),
                  SB.h(20),
                  Text(
                    AppStrings.directory,
                    textAlign: TextAlign.start,
                    style: context.bodyLarge!.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(15),
                  Text(
                    "${AppStrings.assignedTo}:",
                    textAlign: TextAlign.start,
                    style: context.bodyLarge!.copyWith(
                      color: AppColors.gry,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(15),
                  DialougeComponents.nameTile(context,
                      name: ticket?.assignToName),
                  SB.h(15),
                  DialougeComponents.dateTile(context,
                      label: AppStrings.assignedDate, date: date, time: time),
                  SB.h(20),
                  Text(
                    AppStrings.urgent,
                    textAlign: TextAlign.start,
                    style: context.bodyLarge!.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RoomMapComponents.radioButton<YesNo>(
                        context,
                        YesNo.yes,
                        isUrgent ? YesNo.yes : YesNo.no,
                        AppStrings.yes,
                        (value) {},
                        width: context.width * 0.35,
                      ),
                      RoomMapComponents.radioButton<YesNo>(
                        context,
                        YesNo.no,
                        isUrgent ? YesNo.yes : YesNo.no,
                        AppStrings.no,
                        (value) {},
                      ),
                    ],
                  ),
                  SB.h(15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                ? image.trim().completeUrl
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
      int? selectedIndex}) {
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
