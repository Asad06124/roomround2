import 'package:roomrounds/core/constants/imports.dart';

// ignore: must_be_immutable
class CloseTicketDialouge extends StatefulWidget {
  CloseTicketDialouge({
    Key? key,
    this.isUrgent = false,
    this.name = "Anthony Roy",
    this.review =
        "Also clean the bathroom and furniture dusting is not properly done!",
    this.title = "Room A1",
    this.status = 'Close',
    this.sendStatusList = const [
      "Unable to resolve",
      'Need Purchases',
      'Required Outside vendor',
      'Pending',
      'Resolved',
    ],
  }) : super(key: key);

  String title, status, name, review;
  bool isUrgent;
  List<String> sendStatusList;

  @override
  State<CloseTicketDialouge> createState() => _CloseTicketDialougeState();
}

class _CloseTicketDialougeState extends State<CloseTicketDialouge> {
  int _selectedIndex = -1;

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
                children: [
                  SB.h(15),
                  DialougeComponents.labelTile(context,
                      isBorder: true,
                      status: widget.status,
                      title: widget.title),
                  SB.h(20),
                  DialougeComponents.tile(context),
                  SB.h(20),
                  DialougeComponents.nameTile(context,
                      name: widget.name, desc: widget.title),
                  SB.h(20),
                  DialougeComponents.detailWithBorder(context, widget.review),
                  SB.h(20),
                  DialougeComponents.reply(context,
                      sendStatusList: widget.sendStatusList,
                      selectedIndex: _selectedIndex, onTap: (v) {
                    setState(() {
                      _selectedIndex = v;
                    });
                  }),
                  SB.h(20),
                  AppButton.primary(
                    title: AppStrings.send,
                    onPressed: () {},
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

// ignore: must_be_immutable
class ClosedTicketDialouge extends StatelessWidget {
  ClosedTicketDialouge({
    Key? key,
    this.name = "Anthony Roy",
    this.review =
        "Also clean the bathroom and furniture dusting is not properly done!",
    this.title = "Room A1",
    this.status = 'Closed',
    this.time = '1:03 PM',
    this.date = '11/23/2013',
  }) : super(key: key);

  String title, status, name, review, time, date;

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
                children: [
                  SB.h(15),
                  DialougeComponents.labelTile(context,
                      isBorder: false, status: status, title: title),
                  SB.h(20),
                  DialougeComponents.tile(context,
                      value: '', isDecoration: false, title: 'Assigned by:'),
                  SB.h(20),
                  DialougeComponents.nameTile(context, name: name, desc: title),
                  SB.h(20),
                  DialougeComponents.detailWithBorder(context, review),
                  SB.h(20),
                  DialougeComponents.dateTile(context, date: date, time: time),
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

// ignore: must_be_immutable
class OpenThreadDialogue extends StatelessWidget {
  OpenThreadDialogue({
    Key? key,
    this.name = "Anthony Roy",
    this.review =
        "Also clean the bathroom and furniture dusting is not properly done!",
    this.title = "Room A1",
    this.status = '',
    this.aTime = '1:03 PM',
    this.aDate = '11/23/2013',
    this.cTime = '1:03 PM',
    this.cDate = '11/23/2013',
    this.argue = 'Arrange audit findings?',
  }) : super(key: key);
  String title, status, name, review, aTime, aDate, cTime, cDate, argue;
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
                children: [
                  SB.h(15),
                  DialougeComponents.labelTile(
                    context,
                    isBorder: true,
                    status: status,
                    title: title,
                  ),
                  SB.h(20),
                  DialougeComponents.tile(context,
                      title: "Send to:", value: '', isDecoration: false),
                  SB.h(20),
                  DialougeComponents.nameTile(context, name: name, desc: title),
                  SB.h(20),
                  DialougeComponents.detailWithBorder(context, review),
                  SB.h(20),
                  DialougeComponents.dateTile(context,
                      date: aDate, time: aTime),
                  SB.h(20),
                  DialougeComponents.dateTile(context,
                      label: "Completion Date:", date: cDate, time: cTime),
                  SB.h(20),
                  DialougeComponents.detailWithBorder(context, argue,
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

// ignore: must_be_immutable
class OpenThreadDialogueArgue extends StatefulWidget {
  OpenThreadDialogueArgue({
    Key? key,
    this.name = "Anthony Roy",
    this.review =
        "Also clean the bathroom and furniture dusting is not properly done!",
    this.title = "Room A1",
    this.status = '',
    this.aTime = '1:03 PM',
    this.aDate = '11/23/2013',
    this.cTime = '1:03 PM',
    this.cDate = '11/23/2013',
    this.argue = 'Arrange audit findings?',
    this.sendStatusList = const [
      "Unable to resolve",
      'Need Purchases',
      'Required Outside vendor',
      'Pending',
      'Resolved',
    ],
  }) : super(key: key);
  String title, status, name, review, aTime, aDate, cTime, cDate, argue;
  List<String> sendStatusList;
  @override
  State<OpenThreadDialogueArgue> createState() =>
      _OpenThreadDialogueArgueState();
}

class _OpenThreadDialogueArgueState extends State<OpenThreadDialogueArgue> {
  int _selectedIndex = -1;
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
                  DialougeComponents.labelTile(context,
                      isBorder: true,
                      status: widget.status,
                      title: widget.title),
                  SB.h(20),
                  DialougeComponents.tile(context,
                      title: "Assignment",
                      value: widget.title,
                      isDecoration: false),
                  SB.h(20),
                  DialougeComponents.detailWithBorder(
                    context,
                    widget.argue,
                    borderRadius: 35,
                    bgColor: AppColors.gry.withOpacity(0.24),
                  ),
                  SB.h(20),
                  DialougeComponents.messageTile(context),
                  SB.h(20),
                  DialougeComponents.messageTile(context, sender: false),
                  SB.h(20),
                  Text(
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
                  ),
                  SB.h(20),
                  AppButton.primary(
                    title: AppStrings.send,
                    onPressed: () {},
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

// ignore: must_be_immutable
class YesNoDialouge extends StatelessWidget {
  YesNoDialouge(
      {Key? key, this.title = "title", this.onNoPressed, this.onYesPressed})
      : super(key: key);
  String title;
  GestureTapCallback? onYesPressed;
  GestureTapCallback? onNoPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      // height: context.height * 0.75,
      width: context.width,
      padding: const EdgeInsets.all(10),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DialougeComponents.closeBtn(),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                  title,
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
                      title: 'Yes',
                      onPressed: onYesPressed,
                      height: 50,
                      width: context.width * 0.25,
                    ),
                    SB.w(10),
                    AppButton.primary(
                      background: AppColors.primary,
                      title: 'No',
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

class ArrangeAuditFunding extends StatelessWidget {
  const ArrangeAuditFunding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      // height: context.height * 0.75,
      width: context.width,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DialougeComponents.closeBtn(),
          SB.h(10),
          DialougeComponents.labelTile(
            context,
            isBorder: true,
            status: '',
            title: 'Arrange audit findings?',
          ),
          SB.h(10),
          DialougeComponents.labelTile(
            context,
            isBorder: true,
            status: '',
            title: AppStrings.comment,
            titleStyle: context.titleSmall!.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SB.h(10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.lightWhite,
            ),
            padding: const EdgeInsets.all(3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  maxLines: 4,
                  borderRadius: 0,
                  borderColor: AppColors.lightWhite,
                  hintText: AppStrings.writeMessage,
                  isRequiredField: false,
                  validator: (value) => null,
                  fillColor: AppColors.lightWhite,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Assets.icons.cameraCircle.svg(),
                    SB.w(10),
                    Assets.icons.mic.svg(),
                    SB.w(10)
                  ],
                ),
                SB.h(5),
              ],
            ),
          ),
          DialougeComponents.labelTile(
            context,
            isBorder: true,
            status: '',
            title: AppStrings.directory,
            titleStyle: context.titleSmall!.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SB.h(10),
          DialougeComponents.labelTile(
            context,
            isBorder: true,
            status: '',
            title: 'Change Member:',
          ),
          SB.h(10),
          DialougeComponents.nameTile(context, name: "Anthony Roy"),
          SB.h(10),
          DialougeComponents.dateTile(context,
              time: '1:03 PM', date: '11/23/2023'),
          SB.h(5),
          DialougeComponents.dateTile(context,
              label: 'Completion Date:', time: '1:03 PM', date: '11/23/2023'),
          SB.h(10),
          DialougeComponents.labelTile(
            context,
            isBorder: true,
            status: '',
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
              RoomMapComponents.radioButtton<YesNo>(
                context,
                YesNo.yes,
                YesNo.yes,
                AppStrings.yes,
                (value) {},
                width: context.width * 0.35,
              ),
              RoomMapComponents.radioButtton<YesNo>(
                  context, YesNo.no, YesNo.yes, AppStrings.no, (value) {}),
            ],
          ),
          SB.h(10),
          AppButton.primary(
            background: AppColors.primary,
            title: AppStrings.done,
            // onPressed: onYesPressed,
            height: 50,
            width: context.width,
          ),
          SB.h(10),
        ],
      ),
    );
  }
}

class DialougeComponents {
  static Widget labelTile(
    BuildContext context, {
    String title = '',
    String status = '',
    bool isBorder = false,
    TextStyle? titleStyle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleStyle ??
              context.bodyLarge!.copyWith(
                color: !isBorder ? AppColors.gry : AppColors.textGrey,
                fontWeight: FontWeight.w600,
              ),
        ),
        const Spacer(),
        Text(
          status,
          style: context.bodyLarge!.copyWith(
            color: AppColors.black,
            decoration: isBorder ? TextDecoration.underline : null,
            decorationColor: isBorder ? AppColors.black : null,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  static Widget dateTile(BuildContext context,
      {String label = 'Assigned Date:', String date = '', String time = ''}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
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
            time,
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
            date,
            style: context.bodySmall!.copyWith(
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  static Widget closeBtn() {
    return InkWell(
      onTap: () => Get.back(),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: AppColors.gry)),
            child: const Icon(
              Icons.close,
              color: AppColors.gry,
              size: 18,
            )),
      ),
    );
  }

  static Widget tile(BuildContext context,
      {String title = 'Assigned by:',
      String value = "Urgent",
      bool isDecoration = true}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.bodyLarge!.copyWith(
            color: AppColors.gry,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Container(
          padding: isDecoration
              ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
              : null,
          decoration: isDecoration
              ? BoxDecoration(
                  color: AppColors.yellowLight.withOpacity(0.24),
                  borderRadius: BorderRadius.circular(35),
                )
              : null,
          child: Text(
            value,
            style: context.bodyLarge!.copyWith(
              color: isDecoration ? AppColors.yellowDark : AppColors.gry,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  static Widget nameTile(BuildContext context,
      {String name = '', String desc = ''}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gry.withOpacity(0.24),
        borderRadius: BorderRadius.circular(35),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            child: Assets.images.person.image(height: 40, width: 40),
          ),
          SB.w(6),
          Text(
            name,
            style: context.bodyLarge!.copyWith(
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            desc,
            style: context.bodyLarge!.copyWith(
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SB.w(5),
        ],
      ),
    );
  }

  static Widget detailWithBorder(BuildContext context, String review,
      {double borderRadius = 10,
      Color bgColor = AppColors.white,
      GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.width,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: AppColors.textGrey,
            )),
        padding: const EdgeInsets.all(15),
        child: Text(
          review,
          textAlign: TextAlign.start,
          style: context.bodyLarge!.copyWith(
            color: AppColors.black,
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
