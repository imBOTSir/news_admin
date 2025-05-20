import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'app/screens/dashboard.dart';
import 'core/di/get_injector.dart';
import 'core/services/network_checker.dart';
import 'routes/app_pages.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<AsyncSnapshot<bool>> _appLoadState =
      ValueNotifier(const AsyncSnapshot.waiting());

  @override
  initState(){
    _retryLoadApp();
    callSupa();
    super.initState();
  }

  void _retryLoadApp() async {
    _appLoadState.value = const AsyncSnapshot.waiting(); // Set to loading state
    try {
      final bool result = await checkNetworkAndServices();
      _appLoadState.value =
          AsyncSnapshot.withData(ConnectionState.done, result);
    } catch (error) {
      log('Error during initialization: $error');
      _appLoadState.value =
          AsyncSnapshot.withError(ConnectionState.done, error);
    }
  }

  void callSupa(){
    sbServices.initSupabase();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        FlutterQuillLocalizations.delegate,
      ],
      getPages: AppPages.routes,
      unknownRoute: AppPages.unknownPage,
      home: MyDashboard(),
    );
  }
}

/// Custom function to check network and ensure all services are ready before rendering the app.
Future<bool> checkNetworkAndServices() async {
  try {
    // Initialize the application.
    await initializeApp();
    // Check if network is connected
    final networkChecker = Get.find<NetworkChecker>();
    await networkChecker.getConnectionStatus();



    if (!networkChecker.isConnected.value) {
      print("No internet connection");
      //TODO show toast
      return false;
    }
    // Check if AppSettingsController is initialized
    // final appSettingsController = Get.find<AppSettingsController>();
    // await appSettingsController
    //     .initializeSettings(); // Initialize your AppSettingsController

    return networkChecker.isConnected.value;
  } catch (e) {
    log('Error during initialization: $e');
    return false;
  }
}

/// Initializes the application by setting up necessary services and configurations.
Future<void> initializeApp() async {
  // Lazy put NetworkChecker service for later use.
  Get.lazyPut(() => NetworkChecker(), fenix: true);
  // Initialize core services and app configuration concurrently.
  await _initializeCoreServices();
  //await _initializeAppConfig();
}

/// Initializes core services required by the application.
Future<void> _initializeCoreServices() async {
  //await registerBaseServices();
  await setupGlobalServices();
  await initAppControllers();
}
