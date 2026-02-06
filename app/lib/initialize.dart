import 'package:skeleton_app/config/firebase_options.dart';
// --- OPTIONAL: push_notifications ---
import 'package:skeleton_app/services/notification_service.dart';
// --- END: push_notifications ---
// --- OPTIONAL: admob ---
import 'package:skeleton_app/services/admob_service.dart';
// --- END: admob ---
// --- OPTIONAL: in_app_purchases ---
import 'package:skeleton_app/services/purchase_service.dart';
// --- END: in_app_purchases ---
// --- OPTIONAL: app_tracking ---
import 'package:skeleton_app/services/att_service.dart';
// --- END: app_tracking ---
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> initializeApp() async {
  try {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // Error handling
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // --- OPTIONAL: app_tracking ---
    await AttService.instance.initialize();
    // --- END: app_tracking ---
    // --- OPTIONAL: admob ---
    await AdmobService.instance.initialize();
    // --- END: admob ---
    // --- OPTIONAL: in_app_purchases ---
    await PurchaseService.instance.initialize();
    // --- END: in_app_purchases ---
    // --- OPTIONAL: push_notifications ---
    await NotificationService.initialize();
    // --- END: push_notifications ---

    // Remove splash screen
    FlutterNativeSplash.remove();
  } catch (e, stackTrace) {
    FirebaseCrashlytics.instance.recordError(e, stackTrace);
    FlutterNativeSplash.remove();
  }
}
