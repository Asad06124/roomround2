import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:roomrounds/core/apis/models/tickets/ticket_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/maintenance/controller/maintenance_controller.dart';
import 'package:roomrounds/module/maintenance/views/maintenance_task_detail_view.dart';

class MaintenanceView extends StatefulWidget {
  const MaintenanceView({super.key});

  @override
  State<MaintenanceView> createState() => _MaintenanceViewState();
}

class _MaintenanceViewState extends State<MaintenanceView> {
  final MaintenanceController maintenanceController =
      Get.put(MaintenanceController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        maintenanceController.loadMoreMaintenanceTasks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 140,
        isBackButtun: true,
        titleStyle: context.titleLarge,
        title: AppStrings.maintenance,
        showNotificationIcon: false,
        showMailIcon: false,
        isHome: false,
        decriptionWidget: CustomAppbar.appBatTile(
          context,
          name: profileController.user?.username,
          desc: profileController.user?.role,
        ),
      ),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(55),
                  topRight: Radius.circular(55),
                ),
                color: AppColors.white,
              ),
              child: Obx(() {
                if (maintenanceController.isLoading.value &&
                    maintenanceController.maintenanceTasks.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final groupedTasks =
                    maintenanceController.getGroupedMaintenanceTasks();

                if (groupedTasks.isEmpty) {
                  return Center(
                    child: Text(
                      AppStrings.noTasksFound,
                      style: context.titleMedium!.copyWith(
                        color: AppColors.gry,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }

                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    ...groupedTasks.entries.map((entry) {
                      final dateHeader = entry.key;
                      final tasks = entry.value;
                      return SliverMainAxisGroup(
                        slivers: [
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _SliverHeaderDelegate(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors
                                      .black, // Subtle background to highlight
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary.withOpacity(0.05),
                                      AppColors.primary.withOpacity(0.1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Text(
                                  dateHeader,
                                  style: context.titleMedium!.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight:
                                        FontWeight.w700, // Bolder for emphasis
                                    fontSize:
                                        18, // Slightly larger for hierarchy
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return _maintenanceTaskTile(
                                    context, tasks[index]);
                              },
                              childCount: tasks.length,
                            ),
                          ),
                        ],
                      );
                    }),
                    SliverToBoxAdapter(
                      child: Obx(() {
                        if (maintenanceController.isLoadingMore.value) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _maintenanceTaskTile(BuildContext context, Ticket task) {
    // Determine status and color
    String statusLabel;
    Color statusColor;
    Color statusTextColor;

    if (task.isCompleted == true) {
      statusLabel = AppStrings.completed;
      statusColor = AppColors.green.withOpacity(0.15);
      statusTextColor = AppColors.greenDark;
    } else if ((task.status?.toLowerCase() ?? '').contains('ticket')) {
      statusLabel = 'Ticket Created';
      statusColor = AppColors.blue.withOpacity(0.15);
      statusTextColor = AppColors.blue;
    } else {
      statusLabel = AppStrings.pendingFirst;
      statusColor = AppColors.yellowLight.withOpacity(0.25);
      statusTextColor = AppColors.yellowDark;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Get.to(() => MaintenanceTaskDetailView(task: task));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gry.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
              color: AppColors.gry.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.ticketName ?? AppStrings.na,
                    style: context.titleSmall!.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SB.h(4),
                  Text(
                    '${task.roomName ?? AppStrings.na} - ${task.status ?? AppStrings.status}',
                    style: context.bodyMedium!.copyWith(
                      color: AppColors.darkGrey,
                    ),
                  ),
                  if (task.assignDate != null &&
                      task.assignDate!.isNotEmpty) ...[
                    SB.h(4),
                    Text(
                      'Created: ${task.assignDate != null
                              ? DateFormat('MM/dd/yyyy')
                                  .format(DateTime.parse(task.assignDate!))
                              : AppStrings.na}',
                      style: context.bodySmall!.copyWith(
                        color: AppColors.gry,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SB.w(12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                statusLabel,
                style: context.bodySmall!.copyWith(
                  color: statusTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeDisplay(BuildContext context) {
    return Obx(() {
      if (maintenanceController.startDate.value == null ||
          maintenanceController.endDate.value == null) {
        return const SizedBox.shrink();
      }
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        color: AppColors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Showing results for: ',
              style: context.bodyMedium!.copyWith(
                color: AppColors.textGrey,
              ),
            ),
            Text(
              '${DateFormat('MMM d, yyyy').format(maintenanceController.startDate.value!)} - ${DateFormat('MMM d, yyyy').format(maintenanceController.endDate.value!)}',
              style: context.bodyMedium!.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: maintenanceController.startDate.value ??
            DateTime.now().subtract(const Duration(days: 30)),
        end: maintenanceController.endDate.value ?? DateTime.now(),
      ),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primary,
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      maintenanceController.updateDateFilters(
        start: picked.start,
        end: picked.end,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          bottom: BorderSide(
            color: AppColors.gry.withOpacity(0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gry.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  double get maxExtent => 48; // Increased for better spacing

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

