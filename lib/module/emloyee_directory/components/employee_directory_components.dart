import 'package:roomrounds/core/constants/imports.dart';

class EmployeeDirectoryComponents {
  static Widget tile(
    BuildContext context, {
    String title = "Room A1",
    String status = "Close",
    bool isAcvtive = false,
    bool titleActive = true,
    Color fillColor = AppColors.white,
  }) {
    return Container(
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
          Text(
            title,
            style: context.bodyLarge!.copyWith(
              color: titleActive ? AppColors.textPrimary : AppColors.gry,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            status,
            style: context.bodyLarge!.copyWith(
              color: AppColors.black,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          SB.w(5),
          CircleAvatar(
            radius: 4,
            backgroundColor: isAcvtive ? AppColors.orange : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
