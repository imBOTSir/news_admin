import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:news_admin/controllers/dashboard_controller.dart';
import 'package:news_admin/core/di/get_injector.dart';
import 'package:news_admin/routes/app_pages.dart';
import '../app/screens/news_preview.dart';
import '../config/size_config.dart';
import '../models/model.dart';
import '../shared/constants/app.dart';
import '../shared/utils/colors.dart';

class ShowHistory extends StatefulWidget {
  ShowHistory({super.key});

  @override
  State<ShowHistory> createState() => _ShowHistoryState();
}

class _ShowHistoryState extends State<ShowHistory> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;

        return Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        SizedBox(width: 60),
                        Expanded(
                            flex: 3, child: Text('Title', style: _headerStyle)),
                        Expanded(
                            flex: 2, child: Text('Time', style: _headerStyle)),
                        Expanded(
                            flex: 2,
                            child: Text('Uploaded By', style: _headerStyle)),
                        Expanded(
                            flex: 1,
                            child: Text('Status', style: _headerStyle)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Table Rows
                  ...List.generate(newsUploadHistory.length, (index) {
                    final sortedList = [...newsUploadHistory];
                    sortedList.sort((a, b) {
                      DateTime dateA = DateTime.tryParse(
                              a.time.replaceAll('–', ' ').trim()) ??
                          DateTime(1970);
                      DateTime dateB = DateTime.tryParse(
                              b.time.replaceAll('–', ' ').trim()) ??
                          DateTime(1970);
                      return dateB.compareTo(dateA); // Sort newest to oldest
                    });

                    final transaction = sortedList[index];
                    final isSelected = selectedIndex == index;

                    String fixedTimeString =
                        transaction.time.replaceAll('–', ' ').trim();
                    DateTime parsedDate = DateTime.parse(fixedTimeString);
                    String formattedDate = DateFormat('MMMM dd, yyyy – hh:mm a')
                        .format(parsedDate);

                    return InkWell(
                      onTap: () => setState(() => selectedIndex = index),
                      borderRadius: BorderRadius.circular(10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : index % 2 == 0
                                  ? Colors.grey[50]
                                  : Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : [],
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    transaction.thumbnailUrls.isNotEmpty
                                        ? NetworkImage(
                                            transaction.thumbnailUrls.first)
                                        : null,
                                child: transaction.thumbnailUrls.isEmpty
                                    ? const Icon(Icons.image_not_supported)
                                    : null,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(transaction.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: _cellStyle),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(formattedDate, style: _cellStyle),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(transaction.uploadedBy,
                                  style: _cellStyle),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: transaction.status.toLowerCase() ==
                                          'published'
                                      ? Colors.green[100]
                                      : Colors.orange[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  transaction.status,
                                  textAlign: TextAlign.center,
                                  style: _statusStyle(transaction.status),
                                ),
                              ),
                            ),

                            // Preview Button
                            IconButton(
                              icon: const Icon(Icons.preview_outlined),
                              tooltip: 'Preview News',
                              onPressed: () {
                                appNav.navigateTo(AppRoutes.previewNews,
                                    arguments: {
                                      RouteArgumentKeys.newsId:
                                          transaction.newsId,
                                      RouteArgumentKeys.author:
                                          transaction.author,
                                      RouteArgumentKeys.description:
                                          transaction.description,
                                      RouteArgumentKeys.newsPlain:
                                          transaction.newsPlain,
                                      RouteArgumentKeys.date:
                                      DateTime.tryParse(transaction.time)?.toIso8601String(),
                                    });
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (_) => NewsPreviewScreen(
                                //       author: transaction.author,
                                //       description: transaction.description,
                                //       newsPlain: transaction.newsPlain,
                                //       date: DateTime.tryParse(transaction.time) ?? DateTime.now(), newsId: transaction.newsId,
                                //     ),
                                //   ),
                                // );
                              },
                            ),

                            // Delete Button
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              tooltip: 'Delete',
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    titlePadding: const EdgeInsets.fromLTRB(
                                        24, 24, 24, 8),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        24, 0, 24, 24),
                                    title: Row(
                                      children: const [
                                        Icon(Icons.warning_amber_rounded,
                                            color: Colors.red, size: 28),
                                        SizedBox(width: 10),
                                        Text(
                                          'Confirm Deletion',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: MyAppColor.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: const Text(
                                      'Are you sure you want to delete this news item?',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: MyAppColor.iconGray,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        style: TextButton.styleFrom(
                                          foregroundColor: MyAppColor.primary,
                                        ),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        icon: const Icon(Icons.delete_outline),
                                        label: const Text('Delete'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  await Get.find<DashBoardController>()
                                      .deleteNews(int.parse(
                                          newsUploadHistory[index].newsId));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static const _headerStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: Colors.black87,
  );

  static final _cellStyle = TextStyle(
    fontSize: 13,
    color: MyAppColor.secondary,
    overflow: TextOverflow.ellipsis,
  );

  TextStyle _statusStyle(String status) {
    final isPublished = status.toLowerCase() == 'published';
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: isPublished ? Colors.green[800] : Colors.orange[800],
    );
  }
}
