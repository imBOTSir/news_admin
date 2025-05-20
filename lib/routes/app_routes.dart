part of 'app_pages.dart';

abstract class AppRoutes {
  static const basePage = _Paths.basePage;
  static const newsDashboard = _Paths.newsDashboard;
  static const addNews = _Paths.addNews;
  static const previewNews = _Paths.previewNews;
  AppRoutes._();
}

abstract class _Paths {
  static const basePage = '/base_page';
  static const newsDashboard = '/news_dashboard';
  static const addNews = '/add_news';
  static const previewNews = '/preview_news';
  _Paths._();
}
