import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:near_me/DynamicLink/route_services.dart';
import 'package:near_me/MyThemes.dart';
import 'package:near_me/Screen/TabPage/TabBar.dart';
import 'package:near_me/Screen/bloc/cartlistBloc.dart';
import 'package:near_me/Screen/bloc/listTileColorBloc.dart';
import 'package:near_me/SplashScreen.dart';
import 'package:near_me/data/services/auth_service.dart';
import 'package:near_me/l10n/l10n.dart';
import 'package:near_me/provider/locale_provider.dart';
import 'package:near_me/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:near_me/set.env';

final _configuration = PurchasesConfiguration('appl_YIrDUFuMGPyGBwLrPiNYLCJaFay');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Purchases.configure(_configuration);
  //Stripe.publishableKey = 'pk_live_51FBheoD0e7WDXDnrr4ydkicUSOVZ7id4yzHDMbbZyGeR2gXwnUVJnj4ZWBOdXbwn3BqSCR4UKnNtZJdcpduUFBMD009HzmZAGZ';
  //await Stripe.instance.applySettings();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
  //print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  FlutterAppBadger.removeBadge();
  runApp(iChiani());
}

class iChiani extends StatefulWidget {
  @override
  State<iChiani> createState() => _iChianiState();
}

class _iChianiState extends State<iChiani> {
  // This widget is the root of your application.

  var useruid = FirebaseAuth.instance.currentUser?.uid;
  String? _linkMessage;
  bool _isCreatingLink = false;

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  String kUriPrefix = 'https://ichiani.page.link';
  String kHomepageLink = '/homepage';
  @override
  void initState() {
    super.initState();
    // _saveDeviceToken();
    //FirebaseAnalytics.instance.logEvent(name: 'app_start ');
    initDynamicLinks();
  }

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri uri = dynamicLinkData.link;
      final queryParams = uri.queryParameters;
      if (queryParams.isNotEmpty) {
        String? productId = queryParams["id"];
        Navigator.pushNamed(context, dynamicLinkData.link.path, arguments: {"productId": int.parse(productId!)});
      } else {
        Navigator.pushNamed(
          context,
          dynamicLinkData.link.path,
        );
      }
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  Future<void> _createDynamicLink(bool short, String link) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: kUriPrefix,
      link: Uri.parse(kUriPrefix + link),
      androidParameters: const AndroidParameters(
        packageName: 'com.ichiani.flutter',
        minimumVersion: 0,
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
  }

  @override
  Widget build(BuildContext context) => MultiProvider(providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider(
            create: (context) => LocaleProvider(),
            builder: (context, child) {
              final provider = Provider.of<LocaleProvider>(context);

              return BlocProvider(
                  child: MaterialApp(
                    routes: {'/mytabbar': (context) => MyTabBar(currentIndex: 1, structure: 'PROVA')},
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                        child: child!,
                      );
                    },
                    debugShowCheckedModeBanner: false,
                    themeMode: ThemeMode.system,
                    theme: MyThemes.lightTheme,
                    darkTheme: MyThemes.darkTheme,
                    home: SplashScreen(),
                    locale: provider.locale,
                    supportedLocales: L10n.all,
                    onGenerateRoute: RouteServices.generateRoute,
                    localizationsDelegates:  [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                  ),
                  blocs: [
                    Bloc((i) => CartListBloc()),
                    Bloc((i) => ColorBloc()),
                  ],
                  dependencies: []);
            })
      ]);
      
  _saveDeviceToken() async {
    // Get the current user

    String uid = FirebaseAuth.instance.currentUser!.uid;

    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid/device_token");

    String? token = await FirebaseMessaging.instance.getToken();

    await FirebaseDatabase.instance.ref().child('users/$uid').update({'device_token': token});
  }
}
