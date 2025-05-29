import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:advertising_id/advertising_id.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ios_fl_n_wildatlas_3425/main.dart';
import 'package:ios_fl_n_wildatlas_3425/web_view.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? urlWeb;
String? urlPush;
String? timestampUserId;
bool isPush = false;
String deepLink = "";

// Перевірка чи є інтернет
Future<bool> hasInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}

// ініціалізація OneSignal
Future<void> setUpOneSignal() async {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(AppConstants.oneSignalAppId);


  final prefs = await SharedPreferences.getInstance();
  final granted = await OneSignal.Notifications.requestPermission(true);

  await prefs.setBool('permission_granted', granted);


  OneSignal.Notifications.addClickListener((openedEvent) {
    isPush = true;

    // Отримуємо дані з push
    urlPush = (openedEvent.notification.launchUrl as String?)?.trim();
  });
}

// Відправка тегу OneSignal
Future<void> sendTagByOneSignal(String tsId) async {
  await OneSignal.User.addTagWithKey('timestamp_user_id', tsId);
}

Future<void> _requestAppTracking() async {
  final status = await AppTrackingTransparency.requestTrackingAuthorization();
  debugPrint('AppTrackingTransparency status: $status');
}

// Перевірка локації
Future<String> isLocationCorrect() async {
  final uri = Uri.parse(
    'https://${AppConstants.baseDomain}/${AppConstants.verificationParam}',
  );
  final response = await http.get(uri);
  return response.statusCode == 200 ? '200' : 'Error: ${response.statusCode}';
}

// налаштування AppsFlyer
Future<AppsflyerSdk> setUpAppsFlyer() async {
  final options = AppsFlyerOptions(
    afDevKey: AppConstants.appsFlyerDevKey,
    appId: AppConstants.appID,
    showDebug: true,
    timeToWaitForATTUserAuthorization: 0,
  );
  final sdk = AppsflyerSdk(options);
  await sdk.initSdk(registerConversionDataCallback: true);
  return sdk;
}


// Отримання AppsFlyer UID
Future<void> getAppsflyerUserId(
    AppsflyerSdk sdk,
    SharedPreferences prefs,
    ) async {
  final id = await sdk.getAppsFlyerUID();
  await prefs.setString('appsflyer_id', id!);
}

// Отримання Conversion data та перевірка на Organic і інші статуси
Future<Map<String, String>> setUpConversionTimer(AppsflyerSdk sdk) {
  final completer = Completer<Map<String, String>>();

  void completeEmpty() {
    completer.complete({
      for (var i = 1; i <= 8; i++) 'swed_$i': '',
      'keyword': '',
    });
  }

  final timeout = Timer(const Duration(seconds: 10), () {
    if (!completer.isCompleted) completeEmpty();
  });

  sdk.onInstallConversionData((data) {
    if (completer.isCompleted) return;
    timeout.cancel();
    debugPrint('🔄 InstallConversionData: $data');
    final status = (data['status'] as String?)?.trim() ?? '';
    final payload = data['payload'] as Map<String, dynamic>?;
    final afStat = (payload?['af_status'] as String?)?.trim() ?? '';

    if (status != 'success' || payload == null || afStat == 'Organic') {
      completeEmpty();
      return;
    }

    final campaign = (payload['campaign'] as String?)?.trim() ?? '';
    final parts = campaign.isEmpty ? <String>[] : campaign.split('_');

    if (parts.length < 2) {
      completeEmpty();
      return;
    }

    final swed1 = parts[0];
    final swed2 = parts.length > 1 ? parts[1] : '';
    final swed3 = parts.length > 2 ? parts[2] : '';
    final swed4 = parts.length > 3 ? parts[3] : '';

    final swed5 = (payload['af_siteid'] as String?)?.trim() ?? '';
    final swed6 = (payload['af_ad'] as String?)?.trim() ?? '';
    final swed7 = (payload['media_source'] as String?)?.trim() ?? '';
    final swed8 = (payload['af_channel'] as String?)?.trim() ?? '';
    final keyword = (payload['af_keywords'] as String?)?.trim() ?? '';

    completer.complete({
      'swed_1': swed1,
      'swed_2': swed2,
      'swed_3': swed3,
      'swed_4': swed4,
      'swed_5': swed5,
      'swed_6': swed6,
      'swed_7': swed7,
      'swed_8': swed8,
      'keyword': keyword,
    });
  });

  return completer.future;
}

// Відправка urlWeb запиту
Future<http.Response?> sendUrlWebRequest(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    debugPrint(
      'Request sent: status=${response.statusCode}, body=${response.body}',
    );
    return response;
  } catch (e) {
    debugPrint('Error sending urlWeb request: $e');
    return null;
  }
}

// Відправка івенту
Future<void> sendEvent(String eventName) async {
  if (timestampUserId == null) return;
  final Uri uri = Uri.https(
    AppConstants.baseDomain,
    AppConstants.verificationParam,
    {'dasfsa': eventName, 'fasfasda': timestampUserId!},
  );
  await sendUrlWebRequest(uri.toString());
}

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  static const MethodChannel _channel = MethodChannel('deferred_deeplink');

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarColor: Colors.black,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;
      final shouldShowWhite = prefs.getBool('should_show_white_app') ?? false;

      // 1) Ініціалізація OneSignal
      await setUpOneSignal();

      // 2) Перевірка наявності інтернету
      if (!await hasInternetConnection()) {
        Navigator.of(context).pushReplacementNamed('/white');
        return;
      }

      // 3) Перевірка першого запуску
      if (isFirstLaunch) {
        // 4) Генерація timestamp_user_id
        final ms = DateTime
            .now()
            .millisecondsSinceEpoch;
        final rand = Random().nextInt(10000000).toString().padLeft(7, '0');
        timestampUserId = '$ms-$rand';
        await prefs.setString('timestamp_user_id', timestampUserId!);

        // 5) Відправка тегу OneSignal
        await sendTagByOneSignal(timestampUserId!);

        // 6)Івент 'uniq_visit'
        await sendEvent('uniq_visit');

        // 7) Перевірка локації
        final location = await isLocationCorrect();
        debugPrint('Location check returned: $location');
        if (location != '200') {
          await prefs.setBool('should_show_white_app', true);
          await prefs.setBool('is_first_launch', false);
          debugPrint('>>>> Location error: $location');
          Navigator.of(context).pushReplacementNamed('/white');
          return;
        }

        // 6) ATT + IDFA
        final status = await AppTrackingTransparency.requestTrackingAuthorization();
        debugPrint('AppTrackingTransparency status: $status');

        String idfa;
        if (status == TrackingStatus.authorized) {
          idfa = (await AdvertisingId.id(true)) ?? '';
        } else {
          idfa = '00000000-0000-0000-0000-000000000000';
        }
        await prefs.setString('advertising_id', idfa);

        // 7) IDFV
        final idfv = await DeviceIdentifiers.getIdfv();
        if (idfv != null) {
          await prefs.setString('custom_user_id', idfv);
        }

        // 10) AppsFlyer + setCustomerUserId(idfv)
        final sdk = await setUpAppsFlyer();
        if (idfv != null) {
          sdk.setCustomerUserId(idfv);
        }

        // 10) Отримання AppsFlyer UID
        await getAppsflyerUserId(sdk, prefs);

        // 11) Отримання Conversion data та перевірка на Organic і інші статуси
        final swedMap = await setUpConversionTimer(sdk);

        // 12) Отримання one_signal_id
        final oneSignalId = await OneSignal.User.getOnesignalId();
        if (oneSignalId != null) {
          await prefs.setString('one_signal_id', oneSignalId!);
        }

        // 13) Збереження даних у SharedPreferences та формування urlWeb
        final idFv = prefs.getString('custom_user_id')!;
        final afId = prefs.getString('appsflyer_id')!;
        final osId = prefs.getString('one_signal_id')!;
        final tsId = timestampUserId!;
        final adFa = prefs.getString('advertising_id')!;

        final swed1 = swedMap['swed_1']!;
        final swed2 = swedMap['swed_2']!;
        final swed3 = swedMap['swed_3']!;
        final swed4 = swedMap['swed_4']!;
        final swed5 = swedMap['swed_5']!;
        final swed6 = swedMap['swed_6']!;
        final swed7 = swedMap['swed_7']!;
        final swed8 = swedMap['swed_8']!;
        final keyword = swedMap['keyword']!;

        debugPrint('🔧 Params → googleId: $idFv, afId: $afId, osId: $osId, '
            'tsId: $tsId, adFa: $adFa, '
            'swed: [$swed1, $swed2, $swed3, $swed4, $swed5, $swed6, $swed7, $swed8]');

        urlWeb =
        'https://${AppConstants.baseDomain}/${AppConstants.verificationParam}'
            '?${AppConstants.verificationParam}=1'
            '&deqsfsa=$adFa'
            '&rtqsdad=$afId'
            '&adwerqsd=$osId'
            '&fasfasda=$tsId'
            '&sadweqq=$idFv'
            '&fsafsdaa=$idFv'
            '&swed_1=$swed1'
            '&swed_2=$swed2'
            '&swed_3=$swed3'
            '&swed_4=$swed4'
            '&swed_5=$swed5'
            '&swed_6=$swed6'
            '&swed_7=$swed7'
            '&swed_8=$swed8'
            '&keyword=$keyword';

        debugPrint('🌐 Built urlWeb: $urlWeb');
        await prefs.setString('url_web', urlWeb!);

        // 15) Відкриття UrlWebViewApp

        Navigator.of(context).pushReplacementNamed(
          '/webview',
          arguments: UrlWebViewArgs(urlWeb!, null, false),
        );
        return;
      }

      timestampUserId = prefs.getString('timestamp_user_id');
      urlWeb = prefs.getString('url_web');

      if (shouldShowWhite) {
        Navigator.of(context).pushReplacementNamed('/white');
      } else {
        Future.delayed(const Duration(milliseconds: 1500), () {
          final startUrl = isPush ? '$urlWeb&resq=true' : urlWeb!;
          Navigator.of(context).pushReplacementNamed(
            '/webview',
            arguments: UrlWebViewArgs(startUrl, urlPush, isPush),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        body: SizedBox.expand(
          child: Image.asset(
            'assets/images/l1.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class RootApp extends StatelessWidget {
  final String initialRoute;
  final Widget whiteScreen;

  const RootApp({
    Key? key,
    required this.initialRoute,
    required this.whiteScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/white': (_) => whiteScreen,
        '/verify': (_) => const VerificationScreen(),
        '/webview': (ctx) {
          final args = ModalRoute.of(ctx)!.settings.arguments as UrlWebViewArgs;
          return UrlWebViewApp(
            url: args.url,
            pushUrl: args.pushUrl,
            openedByPush: args.openedByPush,
          );
        },
      },
    );
  }
}

class UrlWebViewArgs {
  final String url;
  final String? pushUrl;
  final bool openedByPush;

  UrlWebViewArgs(this.url, this.pushUrl, this.openedByPush);
}

class DeviceIdentifiers {
  static const _channel = MethodChannel('app.id.values');

  static Future<String?> getIdfv() async {
    try {
      return await _channel.invokeMethod<String>('getIdfv');
    } on PlatformException catch (e) {
      debugPrint('Error fetching IDFV: $e');
      return null;
    }
  }
}