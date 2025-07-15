import 'package:intl/intl.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/maintenance/controller/maintenance_controller.dart';
import 'package:roomrounds/module/maintenance/views/maintenance_task_detail_view.dart';
import 'package:roomrounds/core/apis/models/maintenance_task_model.dart';

class MaintenanceView extends StatefulWidget {
  const MaintenanceView({super.key});

  @override
  State<MaintenanceView> createState() => _MaintenanceViewState();
}

class _MaintenanceViewState extends State<MaintenanceView> {
  final MaintenanceController controller = Get.put(MaintenanceController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        controller.loadMoreMaintenanceTasks();
      }
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
      helpText: 'Select Start Date',
      context: context,
      initialDate: controller.startDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        controller.startDate.value = picked;
        if (controller.endDate.value != null &&
            picked.isAfter(controller.endDate.value!)) {
          controller.endDate.value = null;
        }
        _selectEndDate(context);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    if (controller.startDate.value == null) {
      _showDateError('Please select start date first');
      return;
    }

    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData.from(
            colorScheme: ColorScheme(
              brightness: Brightness.dark,
              primary: Colors.white,
              onPrimary: Colors.blueGrey.shade700,
              secondary: Colors.tealAccent.shade700,
              onSecondary: Colors.black,
              error: Colors.redAccent,
              onError: Colors.white,
              surface: Colors.blueGrey.shade800,
              onSurface: Colors.white,
            ),
          ).copyWith(
            dialogBackgroundColor: Colors.blueGrey.shade800,
          ),
          child: child!,
        );
      },
      helpText: 'Select End Date',
      context: context,
      initialDate: controller.endDate.value ?? controller.startDate.value!,
      firstDate: controller.startDate.value!,
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      if (picked.isBefore(controller.startDate.value!)) {
        _showDateError('End date cannot be before start date');
        return;
      }
      setState(() {
        controller.endDate.value = picked;
      });
      controller.updateDateFilters(
          start: controller.startDate.value!, end: picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 70,
        backButtunColor: AppColors.primary,
        title: AppStrings.maintenance,
        showMailIcon: true,
        showNotificationIcon: true,
        notificationActive: true,
        titleStyle: context.titleLarge!.copyWith(color: AppColors.primary),
        iconsClor: AppColors.primary,
        isHome: false,
        isBackButtun: true,
      ),
      // padding: EdgeInsets.zero,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () => _selectStartDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.lightWhite,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.1)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today,
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              controller.startDate.value != null
                                  ? DateFormat('MM/dd/yyyy')
                                      .format(controller.startDate.value!)
                                  : 'Start',
                              style: context.bodySmall!.copyWith(
                                color: controller.startDate.value != null
                                    ? AppColors.textPrimary
                                    : AppColors.gry,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '-',
                    style: TextStyle(color: AppColors.gry),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () => controller.endDate.value == null &&
                            controller.startDate.value == null
                        ? _showDateError('Select start date first')
                        : _selectEndDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.lightWhite,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.1)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today,
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              controller.endDate.value != null
                                  ? DateFormat('MM/dd/yyyy')
                                      .format(controller.endDate.value!)
                                  : 'End',
                              style: context.bodySmall!.copyWith(
                                color: controller.endDate.value != null
                                    ? AppColors.textPrimary
                                    : AppColors.gry,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // SB.w(10),
              ],
            ),
          ),
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
                if (controller.isLoading.value &&
                    controller.maintenanceTasks.isEmpty) {
                  return CustomLoader();
                }

                final groupedTasks = controller.getGroupedMaintenanceTasks();
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
                        if (controller.isLoadingMore.value) {
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

  Widget _maintenanceTaskTile(BuildContext context, MaintenanceTask task) {
    // Determine status and color
    String statusLabel;
    Color statusColor;
    Color statusTextColor;

    final isCompleted = task.maintenanceTaskCompletes?.isCompleted ?? false;
    final hasTicket = task.ticketData != null;

    if (isCompleted) {
      statusLabel = AppStrings.completed;
      statusColor = AppColors.green.withOpacity(0.15);
      statusTextColor = AppColors.greenDark;
    } else if (hasTicket) {
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
                    task.maintenanceTaskName ?? AppStrings.na,
                    style: context.titleSmall!.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SB.h(4),
                  Text(
                    '${task.recurrencePatternName ?? AppStrings.na} - ${isCompleted ? AppStrings.completed : hasTicket ? 'Ticket Created' : AppStrings.pendingFirst}',
                    style: context.bodyMedium!.copyWith(
                      color: AppColors.darkGrey,
                    ),
                  ),
                  if (task.occurrenceDate != null &&
                      task.occurrenceDate!.isNotEmpty) ...[
                    SB.h(4),
                    Text(
                      'Created: '
                      '${DateFormat('MM/dd/yyyy').format(DateTime.parse(task.occurrenceDate!))}',
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
      if (controller.startDate.value == null ||
          controller.endDate.value == null) {
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
              '${DateFormat('MMM d, yyyy').format(controller.startDate.value!)} - ${DateFormat('MMM d, yyyy').format(controller.endDate.value!)}',
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
        start: controller.startDate.value ??
            DateTime.now().subtract(const Duration(days: 30)),
        end: controller.endDate.value ?? DateTime.now(),
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
      controller.updateDateFilters(
        start: picked.start,
        end: picked.end,
      );
    }
  }

  void _showDateError(String message) {
    Get.snackbar('Date Error', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white);
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
