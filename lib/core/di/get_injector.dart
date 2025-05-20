import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_admin/core/services/supabase_services.dart';

import '../../navigation/navigation_service.dart';
import '../controllers/ui_controller.dart';

GetIt di = GetIt.instance;

Future<void> setupBaseAppServices() async {}

Future<void> setupGlobalServices() async {


  if (!di.isRegistered<SupaBaseServices>()) {
    di.registerLazySingleton<SupaBaseServices>(() => SupaBaseServices());
  }
  await GetStorage.init();
}

/// Registers the application controllers required at the start of the application.
/// This method initializes and registers the AppSettingsController as a permanent instance.
Future<void> initAppControllers() async {
  Get.put<UiController>(UiController(), permanent: true);
  Get.put<NavigationService>(NavigationService(), permanent: true);
}

/// Provides a globally accessible instance of the supabase.
SupaBaseServices get sbServices => di<SupaBaseServices>();

///App navigation will be available through this.
NavigationService get appNav => Get.find<NavigationService>();

///Show the ui controller from here
UiController get appUi => Get.find<UiController>();


