import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/assigned_task/views/ticket_chat_view.dart';

import '../../../core/apis/models/tickets/ticket_model.dart';

class AssignedTaskComponents {
  static Widget tile(BuildContext context,
      {String? title,
      String? status,
      required Ticket ticket,
      bool showIsActiveDot = false,
      bool showPrefixDropdown = false,
      bool titleActive = true,
      bool isUnderline = true,
      bool isAssignedToMe = true,
      Color fillColor = AppColors.white,
      Color statusTextColor = AppColors.black,
      Widget? trailingWidget,
      Widget? subtitleWidget,
      GestureTapCallback? onStatusPressed,
      GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: fillColor,
          border: Border.all(
            color: AppColors.gry.withOpacity(0.5),
          ),
        ),
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showPrefixDropdown)
                  Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: const Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: AppColors.gry,
                      size: 20,
                    ),
                  ),
                Expanded(
                  child: Text(
                    title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.bodyMedium!.copyWith(
                      color: titleActive ? Color(0xff2C3E50) : AppColors.gry,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (trailingWidget != null) trailingWidget,
                CircleAvatar(
                  radius: 4,
                  backgroundColor:
                      showIsActiveDot ? AppColors.orange : Colors.transparent,
                ),
              ],
            ),
            // SizedBox(
            //   height: 5,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (status != null && status.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Status: ',
                            style: context.bodyMedium!.copyWith(
                              color: AppColors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: status,
                            style: context.bodySmall!.copyWith(
                              color: Colors.transparent,
                              fontSize: 12,
                              decoration:
                                  isUnderline ? TextDecoration.underline : null,
                              decorationColor:
                                  isUnderline ? statusTextColor : null,
                              fontWeight: FontWeight.w400,
                              shadows: [
                                Shadow(
                                  color: statusTextColor,
                                  offset: Offset(0, isUnderline ? -2 : 0.01),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    // String currentUserId = profileController.user!.userId.toString();
                    String? image = isAssignedToMe
                        ? ticket.assignByImage
                        : ticket.assignToImage;
                    int? receiverId =
                        isAssignedToMe ? ticket.assignBy : ticket.assignTo;
                    int? senderId =
                        isAssignedToMe ? ticket.assignTo : ticket.assignBy;
                    //
                    // if (currentUserId == ticket.assignBy.toString()) {
                    //   receiverId = ticket.assignTo;
                    //   senderId = ticket.assignBy; // Sender is the assignBy (current user)
                    //   image = ticket.assignToImage;
                    // } else {
                    //   receiverId = ticket.assignBy;
                    //   senderId = ticket.assignTo; // Sender is the assignTo (current user)
                    //   image = ticket.assignByImage;
                    // }
                    Get.to(
                      TicketChatView(
                        ticketId: ticket.ticketId.toString(),
                        receiverId: '${receiverId ?? ''}',
                        senderId: '${senderId ?? ''}',
                        ticketTitle: ticket.ticketName ?? '',
                        receiverImage: image,
                        ticket: ticket,
                        isAssignedToMe: isAssignedToMe,
                      ),
                    );
                  },
                  child: Container(
                    height: 25,
                    width: 55,
                    // padding:
                    //     const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color(0xff2C3E50),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Chat',
                            style: context.bodySmall!.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                        Assets.icons.mail.svg(
                          colorFilter: ColorFilter.mode(
                              AppColors.white, BlendMode.srcIn),
                          height: 10,
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (subtitleWidget != null) subtitleWidget,
          ],
        ),
      ),
    );
  }

/*  static void openDialogEmployee(int type, int index) {
    if (type == 0) {
      _showFullWidthDialog(
        CloseTicketDialouge(
          isUrgent: index % 2 == 0,
        ),
      );
    } else if (type == 1) {
      _showFullWidthDialog(
        ClosedTicketDialouge(),
      );
    } else if (type == 2) {
      _showFullWidthDialog(
        OpenThreadDialogue(
          isUrgent: true,
          urgentText: 'Urgent',
        ),
      );
    } else if (type == 3) {
      _showFullWidthDialog(
        OpenThreadDialogueArgue(),
      );
    }
  }

  static void openDialogManager(int type, int index) {
    if (type == 0) {
      _showFullWidthDialog(
        ThreadTicketDialouge(),
      );
    }
    if (type == 1) {
      _showFullWidthDialog(
        SeeThreadDialouge(),
      );
    }
    if (type == 2) {
      _showFullWidthDialog(
        AssignedThreadDialouge(),
      );
    }
  }  */
}
