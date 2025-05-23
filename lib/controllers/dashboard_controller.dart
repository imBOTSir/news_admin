import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/model.dart';

class DashBoardController extends GetxController{

  final SupabaseClient client = Supabase.instance.client;
  bool isExpanded = true;
  var selectedDrawerIndex = 0.obs;


  @override
  Future<void> onInit() async {
    super.onInit();
   // await getAllNewsFeeds();
   // subscribeToNewsFeed();
  }

  @override
  void onReady() {
    super.onReady();
    getAllNewsFeeds(); // async allowed here too
    subscribeToNewsFeed();
  }

  void subscribeToNewsFeed() {
    final channel = client.channel('public:news_feed');
    channel
        .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'news_feed',
      callback: (payload) {
        print('NewsFeed Realtime payload: $payload');
        getAllNewsFeeds(); // Refresh your local list on any DB change
      },
    )
        .subscribe();
  }


  // READ

  Future<void> getAllNewsFeeds() async {
    try {
      final response = await client.from('news_feed').select();

      newsUploadHistory.value = List<Map<String, dynamic>>.from(response)
          .map((e) => NewsUploadHistory.fromMap(e))
          .toList();

      if (kDebugMode) {
        print('Fetched news: $response');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Read error: $e');
      }
    }
  }

  // delete
  Future<void> deleteNews(int newsId) async {
    try {
       await client
          .from('news_feed')
          .delete()
          .eq('id', newsId);

       await client.from('news_feed_media').delete().eq('id_news_feed', newsId);

      print("News with ID $newsId deleted successfully.");
    } catch (e, stackTrace) {
      print("Error deleting news: $e");
      print("StackTrace: $stackTrace");
      rethrow;
    }
  }


}