import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:news_admin/controllers/news_preview_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../shared/utils/colors.dart';

class NewsPreviewScreen extends StatefulWidget {
  const NewsPreviewScreen({
    super.key,
  });

  @override
  State<NewsPreviewScreen> createState() => _NewsPreviewScreenState();
}

class _NewsPreviewScreenState extends State<NewsPreviewScreen> {
  final controller = Get.put<NewsPreviewController>(NewsPreviewController());
 // List<String> imageUrls = [];
  //bool isLoading = true;

  @override
  void initState() {
   // fetchImages();
    super.initState();
  }

  // Future<void> fetchImages() async {
  //   try {
  //     final response = await client
  //         .from('news_feed_media')
  //         .select('path_of_media')
  //         .eq('id_news_feed', controller.newsId);
  //
  //     final data = response as List<dynamic>?;
  //
  //     if (data == null) {
  //       setState(() {
  //         imageUrls = [];
  //         isLoading = false;
  //       });
  //       return;
  //     }
  //
  //     List<String> fetchedImages = data
  //         .map((item) => item['path_of_media']?.toString() ?? '')
  //         .where((url) => url.isNotEmpty)
  //         .toList();
  //
  //     setState(() {
  //       imageUrls = fetchedImages;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     print('Exception fetching images: $e');
  //     setState(() {
  //       imageUrls = [];
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final parsedDate = DateTime.tryParse(controller.date);
    final formattedDate = parsedDate != null
        ? DateFormat('MMMM dd, yyyy – hh:mm a').format(parsedDate)
        : "Invalid date";

    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: MyAppColor.barBg,
        elevation: 0,
        title: const Text("News Preview",
            style: TextStyle(color: MyAppColor.primary)),
        iconTheme: const IconThemeData(color: MyAppColor.primary),
      ),
      body: Obx(
          () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.imageUrls.isNotEmpty)
                      SizedBox(
                        height: 200,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.imageUrls.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final url = controller.imageUrls[index];
                            return Container(
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: MyAppColor.secondary.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: MyAppColor.secondaryBg,
                                    child: const Center(
                                      child: Icon(Icons.broken_image,
                                          size: 60, color: MyAppColor.iconGray),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: MyAppColor.primaryBg,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: MyAppColor.secondary.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 16, color: MyAppColor.iconGray),
                                  const SizedBox(width: 4),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: MyAppColor.iconGray,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.person,
                                      size: 16, color: MyAppColor.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    "By ${controller.author}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: MyAppColor.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            controller.description,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: MyAppColor.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: MyAppColor.secondaryBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        controller.newsPlain,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: MyAppColor.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
