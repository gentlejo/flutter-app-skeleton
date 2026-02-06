import 'dart:async';
import 'package:app_links/app_links.dart';

/// Deep linking handler using app_links package.
///
/// Manages both cold-start and warm-start deep links.
class DeepLinkingHandler {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  Uri? _initialUri;

  Uri? get initialUri => _initialUri;

  void Function(Uri uri)? onDeepLink;

  Future<void> initialize() async {
    _appLinks = AppLinks();

    try {
      // Cold start — check for initial URI
      final Uri? initial = await _appLinks.getInitialLink();
      if (initial != null) {
        _initialUri = initial;
        onDeepLink?.call(initial);
      }

      // Warm start — listen for incoming links
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (Uri uri) {
          onDeepLink?.call(uri);
        },
        onError: (err) {
          print('[DeepLinkingHandler] Error: $err');
        },
      );
    } catch (e) {
      print('[DeepLinkingHandler] Error: $e');
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
