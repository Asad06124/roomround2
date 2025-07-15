import 'package:roomrounds/module/maintenance/controller/maintenance_controller.dart';

import 'package:roomrounds/core/apis/models/maintenance_task_model.dart';
import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/module/maintenance/views/complete_task_view.dart';
import 'package:roomrounds/module/maintenance/views/create_ticket_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:roomrounds/module/assigned_task/views/ticket_image_full_view.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:roomrounds/utils/custom_overlays.dart';

class _DownloadProgressDialog extends StatelessWidget {
  final ValueNotifier<double> progressNotifier;
  const _DownloadProgressDialog({super.key, required this.progressNotifier});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Downloading...',
                style: context.titleMedium?.copyWith(color: Colors.white)),
            const SizedBox(height: 24),
            SizedBox(
              height: 60,
              width: 60,
              child: ValueListenableBuilder<double>(
                valueListenable: progressNotifier,
                builder: (context, progress, _) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        color: AppColors.aqua,
                        backgroundColor: Colors.white24,
                      ),
                      Center(
                        child: Text(
                          '${(progress * 100).toStringAsFixed(0)}%',
                          style:
                              context.titleLarge?.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('Please wait while the file is being downloaded.',
                style: context.bodyMedium?.copyWith(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class MaintenanceTaskDetailView extends StatelessWidget {
  final MaintenanceTask task;

  const MaintenanceTaskDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MaintenanceController());

    // Helper to determine file type
    bool _isImage(String url) {
      final lower = url.toLowerCase();
      return lower.endsWith('.png') ||
          lower.endsWith('.jpg') ||
          lower.endsWith('.jpeg') ||
          lower.endsWith('.gif');
    }

    bool _isPdf(String url) => url.toLowerCase().endsWith('.pdf');

    Future<void> _openDocument(String url) async {
      await launchUrl(Uri.parse(url));
    }

    Future<void> _downloadFile(BuildContext context, String url) async {
      final progressNotifier = ValueNotifier<double>(0.0);
      try {
        final dio = Dio();
        final dir = await getApplicationDocumentsDirectory();
        final fileName = url.split('/').last;
        final savePath = "${dir.path}/$fileName";

        // Close all open dialogs before showing the progress dialog
        while (Get.isDialogOpen == true) {
          Get.back(closeOverlays: true);
        }

        // Show progress dialog once
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) =>
              _DownloadProgressDialog(progressNotifier: progressNotifier),
        );

        await dio.download(
          url,
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              progressNotifier.value = received / total;
            }
          },
        );
        if (context.mounted) {
          progressNotifier.value = 1.0;
          await Future.delayed(const Duration(milliseconds: 250));
          Navigator.of(context, rootNavigator: true).pop(); // Dismiss dialog
          CustomOverlays.showToastMessage(
            message: 'Downloaded to $savePath',
            isSuccess: true,
          );
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop(); // Dismiss dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Download failed: \n$e')),
          );
        }
      }
    }

    void _viewDocument(BuildContext context, String url) {
      if (_isImage(url)) {
        Get.to(() => TicketImageFullView(imageUrl: url));
      } else if (_isPdf(url)) {
        // For simplicity, open in browser. For local file, download then open.
        _openDocument(url);
        // To use PDFViewerScreen, you need to download the file and pass the local path.
        // Get.to(() => PDFViewerScreen(url: localPath));
      } else {
        _openDocument(url);
      }
    }

    final docUrl = task.maintenanceTaskDocuments?.documentPath;
    final fullDocUrl =
        docUrl != null && docUrl.isNotEmpty ? "${Urls.domain}$docUrl" : null;

    return CustomContainer(
      appBar: CustomAppbar.simpleAppBar(
        context,
        height: 100,
        isBackButtun: true,
        title: task.maintenanceTaskName ?? 'Task Details',
      ),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // --- Task Details Section ---
          Card(
            margin: const EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        Icon(Icons.assignment, color: AppColors.aqua),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            task.maintenanceTaskName ?? '',
                            style: context.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Description Section (always shown)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description:',
                          style: context.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task.maintenanceTaskDescription?.isNotEmpty == true
                              ? task.maintenanceTaskDescription!
                              : '-',
                          style: context.bodyMedium?.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Ticket comment (if any)
                  if (task.ticketData?.comment != null &&
                      task.ticketData!.comment!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                      child: Text(
                        task.ticketData!.comment!,
                        style: context.bodyMedium?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  if (task.recurrencePatternName != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          Icon(Icons.repeat, color: AppColors.aqua, size: 20),
                          const SizedBox(width: 8),
                          Text('Recurrence: ',
                              style: context.bodyMedium
                                  ?.copyWith(color: AppColors.white)),
                          Text('${task.recurrencePatternName}',
                              style: context.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white)),
                        ],
                      ),
                    ),
                  if (task.occurrenceDate != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: AppColors.aqua, size: 20),
                          const SizedBox(width: 8),
                          Text('Date: ',
                              style: context.bodyMedium
                                  ?.copyWith(color: AppColors.white)),
                          Text('${task.occurrenceDate}',
                              style: context.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white)),
                        ],
                      ),
                    ),
                  if (task.maintenanceTaskAssigns?.userName != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          Icon(Icons.person, color: AppColors.aqua, size: 20),
                          const SizedBox(width: 8),
                          Text('Assigned To: ',
                              style: context.bodyMedium
                                  ?.copyWith(color: AppColors.white)),
                          Text('${task.maintenanceTaskAssigns?.userName}',
                              style: context.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white)),
                        ],
                      ),
                    ),
                  if (task.maintenanceTaskAssigns?.departmentName != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          Icon(Icons.apartment,
                              color: AppColors.aqua, size: 20),
                          const SizedBox(width: 8),
                          Text('Department: ',
                              style: context.bodyMedium
                                  ?.copyWith(color: AppColors.white)),
                          Text('${task.maintenanceTaskAssigns?.departmentName}',
                              style: context.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white)),
                        ],
                      ),
                    ),
                  if (fullDocUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(_isPdf(fullDocUrl)
                                  ? Icons.picture_as_pdf
                                  : _isImage(fullDocUrl)
                                      ? Icons.image
                                      : Icons.insert_drive_file),
                              label: const Text('View'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () =>
                                  _viewDocument(context, fullDocUrl),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.download),
                              label: const Text('Download'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () =>
                                  _downloadFile(context, fullDocUrl!),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          // --- End Task Details Section ---
          Expanded(
            child: Container(), // Placeholder for additional content
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Get.to(() => CompleteTaskView(task: task));
                    },
                    child: const Text('Complete Task'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Get.to(() => CreateTicketView(task: task));
                    },
                    child: const Text('Create Ticket'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
