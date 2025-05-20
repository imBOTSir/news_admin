import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import '../core/di/get_injector.dart';
import '../shared/constants/app.dart';

class NewsPreviewController extends GetxController {
  dynamic arguments = {};

  List<String> imageUrls = [];
  final isLoading = true.obs;
  String newsId = "";
  String date = "";
  String author = "";
  String description = "";
  String newsPlain = "";

  final client = Get.find<DashBoardController>().client;

  @override
  Future<void> onInit() async {
    arguments = appNav.appArgs;

    newsId = arguments[RouteArgumentKeys.newsId] ?? '';
    date = arguments[RouteArgumentKeys.date] ?? '';
    author = arguments[RouteArgumentKeys.author] ?? '';
    description = arguments[RouteArgumentKeys.description] ?? '';
    newsPlain = arguments[RouteArgumentKeys.newsPlain] ?? '';

   // if (newsId != "") {
       fetchImages();
   // } else {
   //   isLoading.value = false;
   // }
    super.onInit();
  }

  // Future<void> fetchImages() async {
  //   try {
  //     final response = await client
  //         .from('news_feed_media')
  //         .select('path_of_media')
  //         .eq('id_news_feed', newsId);
  //
  //     final data = response as List<dynamic>?;
  //
  //     imageUrls.value = data
  //             ?.map((item) => item['path_of_media']?.toString() ?? '')
  //             .where((url) => url.isNotEmpty)
  //             .toList() ??
  //         [];
  //   } catch (e) {
  //     imageUrls.clear();
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


  Future<void> fetchImages() async {
    try {
      final response = await client
          .from('news_feed_media')
          .select('path_of_media')
          .eq('id_news_feed', newsId);

      final data = response as List<dynamic>?;

      if (data == null) {
          imageUrls = [];
          isLoading.value = false;
          update();
        return;
      }

      List<String> fetchedImages = data
          .map((item) => item['path_of_media']?.toString() ?? '')
          .where((url) => url.isNotEmpty)
          .toList();

        imageUrls = fetchedImages;
        isLoading.value = false;
      update();
    } catch (e) {
      print('Exception fetching images: $e');
        imageUrls = [];
        isLoading.value = false;
      update();
    }
  }
}
