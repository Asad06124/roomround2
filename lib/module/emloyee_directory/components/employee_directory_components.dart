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
      Widget? statusWidget,
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
            statusWidget ??
                Text(
                  status,
                  style: context.bodyLarge!.copyWith(
                    color: Colors.transparent,
                    decoration: isUnderline ? TextDecoration.underline : null,
                    decorationColor: isUnderline ? AppColors.black : null,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                          color: Colors.black,
                          offset: Offset(0, isUnderline ? -2 : 0.01))
                    ],
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

  static void openDialog(int type) {
    if (type == 0) {
      Get.dialog(
        Dialog(
          child: CloseTicketDialouge(),
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
          child: OpenThreadDialogue(),
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
}
