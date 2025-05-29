import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ios_fl_n_wildatlas_3425/ver_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:core';


Uri? extractFallbackUrl(String intentUrl) {
  final match = RegExp(
    r'S\.browser_fallback_url=([^;]+)',
  ).firstMatch(intentUrl);
  if (match == null) return null;
  final encoded = match.group(1)!;
  try {
    return Uri.parse(Uri.decodeComponent(encoded));
  } catch (_) {
    return null;
  }
}

Future<void> _showAppNotFoundDialog(BuildContext ctx) => showDialog(
  context: ctx,
  builder:
      (dCtx) => AlertDialog(
        title: const Text('Application not found'),
        content: const Text(
          'The required application is not installed on your device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dCtx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
);

final Map<String, String Function(Uri)> _appLinkBuilders = {
  'facebook.com': (uri) => 'fb://facewebmodal/f?href=${uri.toString()}',
  'instagram.com': (uri) {
    final user = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
    return 'instagram://user?username=$user';
  },
  'twitter.com': (uri) {
    final user = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
    return 'twitter://user?screen_name=$user';
  },
  'x.com': (uri) {
    final user = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
    return 'twitter://user?screen_name=$user';
  },
  'wa.me': (uri) => 'whatsapp://send?phone=${uri.pathSegments.first}',
  'whatsapp.com': (uri) => 'whatsapp://send?phone=${uri.pathSegments.first}',
  'ing.de': (uri) => 'de.ingdiba.bankingapp://',
  'paytm.com': (uri) => 'paytmmp://pay',
  'phonepe.com': (uri) => 'phonepe://pay',
  'upi': (uri) => 'upi://pay',
  'sofort.com': (uri) => 'sofort://',
  'uber.com': (uri) => 'uber://pay',
};

Future<void> _openInAppOrBrowser(String url, BuildContext ctx) async {
  final uri = Uri.parse(url);
  for (final entry in _appLinkBuilders.entries) {
    if (uri.host.contains(entry.key)) {
      final appUrl = entry.value(uri);
      if (await canLaunchUrlString(appUrl)) {
        await launchUrlString(appUrl, mode: LaunchMode.externalApplication);
        return;
      }
      break;
    }
  }
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  } else {
    await _showAppNotFoundDialog(ctx);
  }
}

Future<NavigationActionPolicy> handleDeepLink({
  required Uri uri,
  required InAppWebViewController controller,
  required BuildContext ctx,
}) async {
  final urlStr = uri.toString();
  final scheme = uri.scheme.toLowerCase();
  final host = uri.host.toLowerCase();

  if (urlStr.startsWith('about:') || scheme == 'javascript') {
    return NavigationActionPolicy.CANCEL;
  }

  if (uri.queryParameters['popup'] == '1' ||
      urlStr.contains('popup') ||
      urlStr.contains('window.open')) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) => WebPopupScreen(initialUrl: urlStr),
      ),
    );
    return NavigationActionPolicy.CANCEL;
  }

  controller.addJavaScriptHandler(
    handlerName: "consoleLog",
    callback: (args) {
      print('WebView Console: $args');
      return null;
    },
  );

  const paymentSchemes = [
    'upi',
    'paytmmp',
    'phonepe',
    'de.ingdiba.bankingapp',
    'sofort',
    'uber',
  ];

  if (paymentSchemes.contains(scheme)) {
    if (await canLaunchUrlString(urlStr)) {
      await launchUrlString(urlStr, mode: LaunchMode.externalApplication);
    } else {
      await _showAppNotFoundDialog(ctx);
    }
    return NavigationActionPolicy.CANCEL;
  }

  const cryptoSchemes = [
    'ethereum',
    'bitcoin',
    'litecoin',
    'tron',
    'bsc',
    'dogecoin',
    'bitcoincash',
    'tether',
  ];
  if (cryptoSchemes.contains(scheme)) {
    await Clipboard.setData(ClipboardData(text: urlStr));
    ScaffoldMessenger.of(
      ctx,
    ).showSnackBar(const SnackBar(content: Text('Address copied')));
    return NavigationActionPolicy.CANCEL;
  }

  if (_appLinkBuilders.keys.any((k) => host.contains(k))) {
    await _openInAppOrBrowser(urlStr, ctx);
    return NavigationActionPolicy.CANCEL;
  }

  if (host.contains('ing.de') || scheme == 'de.ingdiba.bankingapp') {
    final ingAppUrl = 'de.ingdiba.bankingapp://';
    if (await canLaunchUrlString(ingAppUrl)) {
      await launchUrlString(ingAppUrl, mode: LaunchMode.externalApplication);
    } else {
      final fallbackUri =
          extractFallbackUrl(urlStr) ?? Uri.parse('https://banking.ing.de');
      await launchUrlString(
        fallbackUri.toString(),
        mode: LaunchMode.externalApplication,
      );
    }
    return NavigationActionPolicy.CANCEL;
  }

  if (scheme == 'http' || scheme == 'https' || scheme == 'file') {
    return NavigationActionPolicy.ALLOW;
  }

  if (urlStr.startsWith('intent://')) {
    final fallbackUri = extractFallbackUrl(urlStr);

    if (await canLaunchUrlString(urlStr)) {
      await launchUrlString(urlStr, mode: LaunchMode.externalApplication);
    } else if (fallbackUri != null) {
      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri(fallbackUri.toString())),
      );
    } else {
      await _showAppNotFoundDialog(ctx);
    }
    return NavigationActionPolicy.CANCEL;
  }

  // if (urlStr.startsWith('intent://')) {
  //   final fallbackUri = extractFallbackUrl(urlStr);
  //   if (await canLaunchUrlString(urlStr)) {
  //     await launchUrlString(urlStr, mode: LaunchMode.externalApplication);
  //   } else if (fallbackUri != null) {
  //     Navigator.of(ctx).push(MaterialPageRoute(
  //       builder: (_) => WebPopupScreen(initialUrl: fallbackUri.toString()),
  //     ));
  //
  //   } else {
  //     await _showAppNotFoundDialog(ctx);
  //   }
  //   return NavigationActionPolicy.CANCEL;
  // }

  if (await canLaunchUrlString(urlStr)) {
    await launchUrlString(urlStr, mode: LaunchMode.externalApplication);
  } else {
    await _showAppNotFoundDialog(ctx);
  }
  return NavigationActionPolicy.CANCEL;
}

class UrlWebViewApp extends StatefulWidget {
  final String url;
  final String? pushUrl;
  final bool openedByPush;

  const UrlWebViewApp({
    Key? key,
    required this.url,
    this.pushUrl,
    required this.openedByPush,
  }) : super(key: key);

  @override
  State<UrlWebViewApp> createState() => _UrlWebViewAppState();
}

class _UrlWebViewAppState extends State<UrlWebViewApp> {
  static const _chan = MethodChannel('app.camera/permission');
  late InAppWebViewController _webViewController;

  Future<bool> _askCamera() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  late String _webUrl;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    if (widget.openedByPush) {
      if (widget.pushUrl == null || widget.pushUrl!.isEmpty) {
        sendEvent('push_open_webview');
      } else {
        sendEvent('push_open_browser');
      }
      isPush = false;
    }

    _initialize();

    sendEvent('webview_open');

    _webUrl = widget.url;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.pushUrl?.isNotEmpty == true) {
        launchUrlString(widget.pushUrl!, mode: LaunchMode.externalApplication);
      }
    });
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirst = prefs.getBool('is_first_launch') ?? true;

    if (isFirst) {
      final granted = prefs.getBool('permission_granted') ?? true;

      if (granted) {
        await sendEvent('push_subscribe');
      }

      prefs.setBool('is_first_launch', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          top: true,
          bottom: true,
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            initialSettings: InAppWebViewSettings(
              transparentBackground: false,
              mediaPlaybackRequiresUserGesture: false,
              allowsInlineMediaPlayback: true,
              allowsBackForwardNavigationGestures: true,
              javaScriptCanOpenWindowsAutomatically: true,
              supportMultipleWindows: false,
              useShouldOverrideUrlLoading: true,
              javaScriptEnabled: true,
              domStorageEnabled: true,
              allowFileAccessFromFileURLs: true,
              allowUniversalAccessFromFileURLs: true,
              cacheEnabled: true,
              useOnDownloadStart: true,
              thirdPartyCookiesEnabled: true,
              userAgent:
                  "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) "
                  "AppleWebKit/605.1.15 (KHTML, like Gecko) "
                  "Version/17.0 Mobile/15E148 Safari/604.1",
            ),
            onWebViewCreated: (ctrl) => _webViewController = ctrl,
            onPermissionRequest: (controller, request) async {
              final granted = <PermissionResourceType>[];
              if (request.resources.contains(PermissionResourceType.CAMERA)) {
                granted.add(PermissionResourceType.CAMERA);
              }
              if (request.resources.contains(
                PermissionResourceType.MICROPHONE,
              )) {
                granted.add(PermissionResourceType.MICROPHONE);
              }
              return PermissionResponse(
                resources: granted,
                action:
                    granted.isEmpty
                        ? PermissionResponseAction.DENY
                        : PermissionResponseAction.GRANT,
              );
            },

            shouldOverrideUrlLoading: (controller, nav) async {
              if (!(nav.isForMainFrame ?? false)) {
                return NavigationActionPolicy.ALLOW;
              }

              final uri = nav.request.url!;
              final host = uri.host.toLowerCase();
              final scheme = uri.scheme.toLowerCase();
              final urlStr = uri.toString();


              final openInBrowserUrls = [
                'https://malinacasino.com/login',
                'https://malinacasino.com/registration',

              ];

              if (openInBrowserUrls.any((u) => urlStr.startsWith(u))) {
                await launchUrlString(urlStr, mode: LaunchMode.externalApplication);
                return NavigationActionPolicy.CANCEL;
              }

              if ((host.contains('express-connect.com') ||
                      host.contains('mobile.rbcroyalbank.com')) &&
                  (uri.scheme == 'http' || uri.scheme == 'https')) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WebPopupScreen(initialUrl: uri.toString()),
                  ),
                );
                return NavigationActionPolicy.CANCEL;
              }
              // інші deep-link-и
              return handleDeepLink(
                uri: uri,
                controller: controller,
                ctx: context,
              );
            },
            onCreateWindow: (controller, createReq) async {
              final uri = createReq.request.url;
              if (uri == null) return false;

              if (uri.host.contains('sofort') ||
                  uri.host.contains('uber') ||
                  uri.host.contains('pay')) {
                await controller.loadUrl(
                  urlRequest: URLRequest(url: WebUri(uri.toString())),
                );
                return false;
              }

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WebPopupScreen(initialUrl: uri.toString()),
                ),
              );
              return false;
            },
          ),
        ),
        bottomNavigationBar: Container(
          height: 56,
          color: Colors.black87,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () async {
                  if (await _webViewController.canGoBack()) {
                    _webViewController.goBack();
                  }
                },
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () => _webViewController.reload(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WebPopupScreen extends StatefulWidget {
  final String initialUrl;

  const WebPopupScreen({Key? key, required this.initialUrl}) : super(key: key);

  @override
  State<WebPopupScreen> createState() => _WebPopupScreenState();
}

class _WebPopupScreenState extends State<WebPopupScreen> {
  late InAppWebViewController _popupController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          top: true,
          bottom: true,
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.initialUrl)),
            initialSettings: InAppWebViewSettings(
              javaScriptCanOpenWindowsAutomatically: true,
              supportMultipleWindows: true,
              allowsBackForwardNavigationGestures: true,
              useShouldOverrideUrlLoading: true,
              thirdPartyCookiesEnabled: true,
              domStorageEnabled: true,
              javaScriptEnabled: true,
              allowFileAccessFromFileURLs: true,
              allowUniversalAccessFromFileURLs: true,
              cacheEnabled: true,
            ),
            onWebViewCreated: (ctrl) => _popupController = ctrl,
            shouldOverrideUrlLoading:
                (controller, nav) => handleDeepLink(
                  uri: nav.request.url!,
                  controller: controller,
                  ctx: context,
                ),
            onCloseWindow: (ctrl) => Navigator.of(context).pop(),
          ),
        ),
        bottomNavigationBar: Container(
          height: 56,
          color: Colors.black87,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () => _popupController.reload(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
