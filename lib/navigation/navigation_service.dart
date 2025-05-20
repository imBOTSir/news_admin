import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_admin/app/screens/add_news.dart';
import 'package:news_admin/controllers/add_news_controller.dart';
import 'package:news_admin/controllers/dashboard_controller.dart';
import 'package:news_admin/controllers/news_preview_controller.dart';
import 'package:news_admin/navigation/navigation_mixins.dart';

import '../app/screens/dashboard.dart';
import '../app/screens/news_preview.dart';
import '../routes/app_pages.dart';

class NavigationService extends GetxService with NavigationMixin {
  /// Returns the corresponding widget for the given path.
  Widget getViewForPath(String path) {
    switch (path) {
      case AppRoutes.newsDashboard:
        return MyDashboard();
      case AppRoutes.addNews:
        return AddNewsScreen();
      case AppRoutes.previewNews:
        return NewsPreviewScreen();
      default:
        return const Center(
          child: CircularProgressIndicator(),
        );
    }
  }

  /// Changes the current page to the specified path and adds it to the stack.
  void changePage(
    String path, {
    dynamic arguments,
    bool shouldReplace = false,
  }) {
    if (shouldReplace) {
      pageStack.clear();
      args.clear();
    }

    currentPage.value = path;
    pageStack.add(path);
    args.add(arguments);

    log("Stack length: ${pageStack.length}");
    log("pages:: ${pageStack}");

    final newPage = getViewForPath(path);

    if (onPageChangeCallback != null) {
      onPageChangeCallback!(newPage, arguments);
    }
  }

  /// Pops the last page from the stack and updates the current page.
  void popPage() {
    if (pageStack.length > 1) {
      pageStack.removeLast();
      args.clear();
      currentPage.value = pageStack.last;
      final newPage = getViewForPath(currentPage.value);

      // Trigger the callback with the new page and title
      onPageChangeCallback?.call(newPage, null);
    }
  }

  /// Navigates to the specified route and saves the current BasePage stack state.
  Future<dynamic> navigateTo(String route,
      {dynamic arguments, bool shouldReplace = false}) async {
    if (Get.currentRoute == route) {
      return;
    }
    if (route != '/' && pageStack.isNotEmpty) {
      basePageStack.value = pageStack.toList();
    }

    appArgs = arguments;
    return await Get.toNamed(route,
        arguments: arguments, preventDuplicates: false);
  }

  ///Replace navigation
  Future<dynamic> replaceNavigateTo(String route,
      {dynamic arguments, bool shouldReplace = false}) async {
    if (route != '/' && pageStack.isNotEmpty) {
      basePageStack.value = pageStack.toList();
    }

    appArgs = arguments;
    return await Get.offNamed(route,
        arguments: arguments, preventDuplicates: false);
  }

  /// Navigates back to the previous page and restores the BasePage stack state if needed.
  void navigateBack({dynamic result}) {
    Get.back(result: result);
    if (basePageStack.isNotEmpty) {
      pageStack.value = basePageStack.toList();
      currentPage.value = pageStack.last;
      basePageStack.clear();
      appArgs = null;
    } else {
      Get.offAllNamed(AppRoutes.basePage);
    }
  }

  /// Disposes initialized controllers.
  Future<void> _disposeInitializedControllers() async {
    // TODO: Implement controller disposal if necessary.
    if (Get.isRegistered<DashBoardController>()) {
      // Get.delete<DashBoardController>(force: true);
    }
    if (Get.isRegistered<AddNewsController>()) {
      Get.delete<AddNewsController>(force: true);
    }
    if (Get.isRegistered<NewsPreviewController>()) {
      Get.delete<NewsPreviewController>(force: true);
    }
  }

  /// Handles successful authentication navigation with login result as arguments.
  // Future<void> handleAuthSuccess(
  //     {dynamic loginResult, AuthenticateWithFBResponse? authResponse}) async {
  //   _disposeInitializedControllers();
  //   moveToLandingPage();
  //   // Get.lazyPut<AppDataController>(() => AppDataController());
  //   appSettings.isUserLoggedIn.value = true;
  //   await Get.find<AppDataController>()
  //       .streamCoffeeWebFirebase(
  //       userFBDocumentId:
  //       boxDb.readStringValue(key: BoxConstants.fireBaseUserDocumentId))
  //       .then((r) async => await appSettings.loadUserMenus(
  //       isLogin: true,
  //       subscriptionType: authResponse!.sub!.subType!.toInt(),
  //       countryId: authResponse.countryId!.toInt()));
  //   appArgs = loginResult;
  //   Get.offAllNamed(AppRoutes.basePage, arguments: loginResult);
  //   // appNav.navigateTo(AppRoutes.basePage, arguments: loginResult);
  //   // changePage(lastVisitedPageBeforeLogin,
  //   //     arguments: loginResult, shouldReplace: true);
  // }

  /// Handles user logout and navigates to guest landing page.
  // Future<void> handleLogout() async {
  //   // Explicitly save the current page before logging out
  //   log("handleLogout");
  //   if (appSettings.isUserLoggedIn.value) {
  //     lastVisitedPageBeforeLogin = currentPage.value;
  //   }
  //
  //   ///delete all objectBox data when user gets logout
  //   if (Get.isRegistered<CoffeeQuotesController>()) {
  //     Get.find<CoffeeQuotesController>().deleteAllObjectBoxData();
  //   }
  //   await _disposeInitializedControllers(); // Dispose the previous controllers
  //   resetBasePageStack();
  //   boxDb.writeBoolValue(key: BoxConstants.isUserLoggedIn, value: false);
  //   boxDb.writeIntValue(key: BoxConstants.userId, value: 0);
  //   boxDb.writeStringValue(key: BoxConstants.fireBaseUserDocumentId, value: '');
  //   boxDb.writeBoolValue(key: BoxConstants.trailData, value: false);
  //   appSettings.isUserLoggedIn.value = false; // Update login state
  //   //remove the user data and app data controller.
  //   await Get.find<AppDataController>().clearUserData();
  //   fbServices.logEvent(eventName: TrackData.loggedOut);
  //   fbServices.resetAnalytics();
  //   appFunctions.setGuestDataToAnalytics();
  //   appArgs = null;
  //   appSettings.isUserLogout.value = true;
  //   // Clear all the existing routes in the stack
  //   Get.offAllNamed(
  //     AppRoutes.basePage, // Navigate to the guest landing page
  //     arguments: [], // Pass arguments If requires.
  //   );
  //   // _reinitControllers();
  // }

  ///Restart the app
  void restartApp() {
    _disposeInitializedControllers(); // Dispose the previous controllers
    resetBasePageStack();
    Get.offAllNamed(
      AppRoutes.basePage, // Navigate to the landing page
      arguments: [],
    );
  }
}
