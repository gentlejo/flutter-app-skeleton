import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

/// App Tracking Transparency service for iOS.
///
/// Singleton pattern — only relevant on iOS.
class AttService {
  static final AttService _instance = AttService._internal();
  AttService._internal();
  static AttService get instance => _instance;

  TrackingStatus _status = TrackingStatus.notDetermined;
  TrackingStatus get status => _status;

  Future<void> initialize() async {
    if (!Platform.isIOS) return;

    _status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (_status == TrackingStatus.notDetermined) {
      // Wait for app to be in foreground
      await Future.delayed(const Duration(seconds: 1));
      _status = await AppTrackingTransparency.requestTrackingAuthorization();
    }
    print('[AttService] Tracking status: $_status');
  }
}
