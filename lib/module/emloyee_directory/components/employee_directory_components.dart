import 'dart:developer';

import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/utils/custome_dialogue.dart';

class EmployeeDirectoryComponents {
  static Widget tile(BuildContext context,
      {String? title,
      String? status,
      bool showIsActiveDot = false,
      bool showPrefixDropdown = false,
      bool titleActive = true,
      bool isUnderline = true,
      Color fillColor = AppColors.white,
      Color statusTextColor = AppColors.black,
      Widget? trailingWidget,
      Widget? subtitleWidget,
      GestureTapCallback? onStatusPressed,
      GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: fillColor,
          border: Border.all(
            color: AppColors.gry.withOpacity(0.5),
          ),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.bodyLarge!.copyWith(
                      color:
                          titleActive ? AppColors.textPrimary : AppColors.gry,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (trailingWidget != null) trailingWidget,
                if (status != null && status.isNotEmpty)
                  InkWell(
                    onTap: onStatusPressed,
                    child: Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: Text(
                        status,
                        style: context.bodyLarge!.copyWith(
                          color: Colors.transparent,
                          decoration:
                              isUnderline ? TextDecoration.underline : null,
                          decorationColor: isUnderline ? statusTextColor : null,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              color: statusTextColor,
                              offset: Offset(0, isUnderline ? -2 : 0.01),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                CircleAvatar(
                  radius: 4,
                  backgroundColor:
                      showIsActiveDot ? AppColors.orange : Colors.transparent,
                ),
              ],
            ),
            if (subtitleWidget != null) subtitleWidget,
          ],
        ),
      ),
    );
  }

  static _showFullWidthDialog(
    Widget child,
  ) {
    log("===============> Opening");
    return showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 14),
        child: child,
      ),
    );
  }

  static void openDialogEmployee(int type, int index) {
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
  }
}
