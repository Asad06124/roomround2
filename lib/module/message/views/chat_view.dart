import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/message/components/message_components.dart';
import 'package:roomrounds/module/message/controller/message_controller.dart';

// ignore: must_be_immutable
class ChatView extends StatelessWidget {
  ChatView({super.key});
  LayerLink link = LayerLink();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageController>(
        init: MessageController(),
        builder: (controller) {
          return Scaffold(
            appBar: CustomAppbar.simpleAppBar(
              context,
              height: 75,
              backButtunColor: AppColors.textPrimary,
              title: AppStrings.inbox,
              showNotificationIcon: false,
              notificationActive: true,
              titleStyle:
                  context.titleLarge!.copyWith(color: AppColors.textPrimary),
              iconsClor: AppColors.textPrimary,
              isHome: false,
              showMailIcon: false,
              isBackButtun: true,
            ),
            body: Column(
              children: [
                AnimatedContainer(
                  height: controller.isKeyBoardOpen ? 0 : null,
                  duration: const Duration(milliseconds: 500),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: MessageComponents.detailTile(context),
                        ),
                        SB.h(20),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 15, left: 15, right: 15, bottom: 20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gry.withOpacity(0.24),
                          offset: const Offset(2, 0),
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SB.w(context.width),
                        Text(
                          userData.type == UserType.manager
                              ? 'Nancy / Cleaning Deapertment'
                              : "Room #1A Manager",
                          style: context.titleSmall!
                              .copyWith(color: AppColors.textPrimary),
                        ),
                        SB.h(10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.gry.withOpacity(0.24),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            padding: const EdgeInsets.only(
                                top: 5, left: 5, right: 5, bottom: 30),
                            child: SingleChildScrollView(
                              reverse: true,
                              child: Column(
                                children: [
                                  SB.w(context.width),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 20,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return MessageComponents.messageTile(
                                          context,
                                          sender: index % 2 == 0);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomSheet: Container(
              // height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: context.width,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.gry.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 9,
                          offset: const Offset(2, 0))
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _chatPrefeixIcons(context, controller),
                    SizedBox(
                      width: context.width -
                          (context.width * 0.22 > 90
                              ? 90
                              : context.width * 0.22) -
                          30,
                      child: CustomTextField(
                        validator: (value) => null,
                        borderRadius: 30,
                        hintText: AppStrings.typeeMessageHere,
                        suffixIcon: AppImages.send,
                        onSuffixTap: () {},
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _chatPrefeixIcons(
      BuildContext context, MessageController mController) {
    return Container(
        // color: Colors.red,
        width: context.width * 0.22,
        constraints: const BoxConstraints(
          maxWidth: 90,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            // MessageComponents.popMenue(context, (type) {}),

            // overlayController.toggle();
            CustomePainterDialouge(
              controller: mController.overlayController,
              link: link,
              onTap: () {
                mController.overlayController.toggle();
                mController.update();
              },
              child: Assets.icons.add.svg(),
            ),
            InkWell(
              onTap: () {},
              child: Assets.icons.mic.svg(),
            ),
          ],
        ));
  }
}
