import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';

mixin NavigationMixin on GetxService {
  final basePageStack = <String>[].obs;
  final RxString currentPage = AppRoutes.newsDashboard.obs;

  final pageStack = <String>[AppRoutes.newsDashboard].obs;

  final args = <dynamic>[null].obs;

  Function(Widget, dynamic)? onPageChangeCallback; // Callback for page changes

  dynamic appArgs;

  // final List<NavigationRule> navigationRules = [
  //   NavigationRule(
  //       page: AppRoutes.profile,
  //       condition: () =>
  //       !Get.find<AppSettingsController>().isUserLoggedIn.value,
  //       redirectPage: AppRoutes.authPage,
  //       arguments: {RouteArgumentKeys.isLogin: true}),
  //   // Add more rules as needed.
  // ];

  /// Sets the callback function for page changes and app bar title updates.
  // void setNavigationCallback(Function(String, Widget, dynamic) onPageChange) {
  //   onPageChangeCallback = onPageChange;
  // }

  /// Checks if there are pages in the stack to pop.
  bool canPop() => pageStack.length > 1;

  /// Returns the arguments for the current page.
  dynamic getCurrentArguments() => args.isNotEmpty ? args.last : null;

  /// Move to landing page.
// void moveToLandingPage() {
//   pageStack.clear();
//   args.clear();
//   pageStack.add(lastVisitedPageBeforeLogin);
//   args.add(null);
//   currentPage.value = lastVisitedPageBeforeLogin;
//   updateAppBarTitle(lastVisitedPageBeforeLogin);
// }

  /// Resets the BasePage stack to its initial state.
  void resetBasePageStack() {
    log("resetBasePageStack");
    pageStack.clear();
    args.clear();
    pageStack.add(AppRoutes.newsDashboard); // Default landing page for guest
    args.add(null);
    currentPage.value = AppRoutes.newsDashboard;
  }
}
