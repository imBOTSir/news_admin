import 'package:get/get.dart';

import '../app/screens/add_news.dart';
import '../app/screens/dashboard.dart';
import '../app/screens/news_preview.dart';

part 'app_routes.dart';

class AppPages{
  AppPages._();

  static const initial = _Paths.basePage;

  static GetPage get unknownPage => routes.first;

  static final routes = [
    GetPage(name: AppRoutes.basePage, page: () => const MyDashboard()),
    GetPage(name: AppRoutes.newsDashboard, page: () => const MyDashboard()),
    GetPage(name: AppRoutes.addNews, page: () => const AddNewsScreen()),
    GetPage(name: AppRoutes.previewNews, page: () => const NewsPreviewScreen()),
  ];
}