import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/utils/custome_dialogue.dart';

class EmployeeDirectoryComponents {
  static Widget tile(BuildContext context,
      {String title = "Room A1",
      String status = "Close",
      bool isAcvtive = false,
      Widget? prefixWidget,
      bool titleActive = true,
      bool isUnderline = true,
      Color fillColor = AppColors.white,
      Color statusTextColor = AppColors.black,
      Widget? statusWidget,
      GestureTapCallback? onTap,
      GestureTapCallback? onStatusPressed}) {
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
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (prefixWidget != null) ...{
              prefixWidget,
              SB.w(5),
            },
            Text(
              title,
              style: context.bodyLarge!.copyWith(
                color: titleActive ? AppColors.textPrimary : AppColors.gry,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: onStatusPressed,
              child: statusWidget ??
                  Text(
                    status,
                    style: context.bodyLarge!.copyWith(
                      color: Colors.transparent,
                      decoration: isUnderline ? TextDecoration.underline : null,
                      decorationColor: isUnderline ? statusTextColor : null,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                            color: statusTextColor,
                            offset: Offset(0, isUnderline ? -2 : 0.01))
                      ],
                    ),
                  ),
            ),
            SB.w(statusWidget == null ? 5 : 0),
            CircleAvatar(
              radius: 4,
              backgroundColor:
                  isAcvtive ? AppColors.orange : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  static void openDialogEmployee(int type, int index) {
    if (type == 0) {
      Get.dialog(
        Dialog(
          child: CloseTicketDialouge(
            isUrgent: index % 2 == 0,
          ),
        ),
        barrierDismissible: false,
      );
    } else if (type == 1) {
      Get.dialog(
        Dialog(
          child: ClosedTicketDialouge(),
        ),
        barrierDismissible: false,
      );
    } else if (type == 2) {
      Get.dialog(
        Dialog(
          child: OpenThreadDialogue(
            isUrgent: true,
            urgentText: 'Urgent',
          ),
        ),
        barrierDismissible: false,
      );
    } else if (type == 3) {
      Get.dialog(
        Dialog(
          child: OpenThreadDialogueArgue(),
        ),
        barrierDismissible: false,
      );
    }
  }

  static void openDialogManager(int type, int index) {
    if (type == 0) {
      Get.dialog(
        Dialog(
          child: ThreadTicketDialouge(),
        ),
        barrierDismissible: false,
      );
    }
    if (type == 1) {
      Get.dialog(
        Dialog(
          child: SeeThreadDialouge(),
        ),
        barrierDismissible: false,
      );
    }
    if (type == 2) {
      Get.dialog(
        Dialog(
          child: AssignedThreadDialouge(),
        ),
        barrierDismissible: false,
      );
    }
  }
}
