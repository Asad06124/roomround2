import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/create_ticket/components/create_ticket_components.dart';
import 'package:roomrounds/module/create_ticket/controller/create_ticket_controller.dart';

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
              titleStyle:
                  context.titleLarge!.copyWith(color: AppColors.primary),
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
                          CustomTextField(
                            maxLines: 8,
                            borderRadius: 16,
                            validator: (v) => null,
                            borderColor: AppColors.gry,
                            hintText: AppStrings.writeDescription,
                            controller: controller.descriptionController,
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
                                              .svg(height: 28),
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
        });
  }
}
