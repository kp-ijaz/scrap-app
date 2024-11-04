import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scrap_app/app/modules/bottomnavigationbar/controllers/bottomnavigationbar_controller.dart';
import 'package:scrap_app/app/modules/home/controllers/home_controller.dart';
import 'package:scrap_app/app/modules/my_bookings/controllers/my_bookings_controller.dart';
import 'package:scrap_app/app/modules/my_profile/controllers/my_profile_controller.dart';
import 'package:scrap_app/app/modules/registration/controllers/registration_controller.dart';
import 'package:scrap_app/app/modules/splash/bindings/splash_binding.dart';
import 'package:scrap_app/app/routes/app_pages.dart';
// import 'package:scrap_app/app/utils/app_colors.dart';
import 'package:scrap_app/app/utils/create_termsandconditions.dart';
import 'package:scrap_app/l10n/languagemanager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
Future<void> _firebsaeBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebsaeBackgroundHandler);
  await createTermsAndConditions();
  await createPrivacyPolicy();
  await GetStorage.init();
  await Permission.sms.request();

  Get.put(HomeController());
  Get.put(MyBookingsController());
  Get.put(MyProfileController());
  Get.put(AuthController());
  Get.put(BottomNavigationBarController());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scrap App',
      initialBinding: SplashBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: const Color.fromRGBO(252, 128, 25, 1),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
    );
  }
}
