import 'package:roomrounds/core/apis/models/room/room_task_ticket_model.dart';
import 'package:roomrounds/core/constants/imports.dart';

class RoomListComponents {
  static Widget yesNoWidget(BuildContext context, YesNo? selectedValue,
      Function(YesNo) onTaskValueChanged) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RoomMapComponents.radioButton<YesNo>(
            context,
            YesNo.yes,
            selectedValue,
            AppStrings.yes,
            (value) => onTaskValueChanged(value),
            width: 0,
          ),
          RoomMapComponents.radioButton<YesNo>(
            context,
            YesNo.no, // AssignedValue
            selectedValue, // SelectedValue
            AppStrings.no, // Title
            (value) => onTaskValueChanged(value),
            width: 0,
          ),
          RoomMapComponents.radioButton<YesNo>(
            context,
            YesNo.na, // AssignedValue
            selectedValue, // SelectedValue
            AppStrings.na, // Title
            (value) => onTaskValueChanged(value),
            width: 0,
          ),
        ],
      ),
    );
  }

  static Widget statusWidget(
    BuildContext context, {
    bool isComplete = false,
    TicketData? ticket,
    VoidCallback? onToggle,
    bool? isTask,
  }) {
    return InkWell(
      onTap: isComplete == true ? onToggle : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: ticket != null
              ? ticket.isIssueResolved == true
                  ? AppColors.green.withOpacity(0.5)
                  : AppColors.aqua.withOpacity(0.4)
              : isComplete
                  ? AppColors.green.withOpacity(0.5)
                  : AppColors.yellowLight.withOpacity(0.4),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isComplete
                  ? "Completed"
                  : ticket != null
                      ? (ticket.isIssueResolved == true ? 'Resolved' : 'Ticket')
                      : "Incomplete",
              style: context.bodyLarge!.copyWith(
                color: ticket != null
                    ? AppColors.textPrimary
                    : isComplete
                        ? AppColors.greenDark
                        : AppColors.yellowDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isComplete && isTask == true)
              const Icon(
                Icons.cancel,
                color: AppColors.red,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  static Widget filter(BuildContext context, Function(String value) onSelect) {
    List<String> list = [
      AppStrings.allRooms,
      AppStrings.inProgress,
      AppStrings.complete,
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.textPrimary,
      ),
      // padding: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SB.w(15),
          Expanded(
            child: CustomeDropDown.simple<String>(
              context,
              showShadow: false,
              includeSuffix: true,
              closedShadow: false,
              textColor: AppColors.white,
              closedFillColor: AppColors.textPrimary,
              expandFillColor: AppColors.textPrimary,
              list: list,
              onSelect: onSelect,
              initialItem: list.firstOrNull,
            ),
          )
        ],
      ),
    );
  }
}
