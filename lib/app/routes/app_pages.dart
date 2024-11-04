import 'package:get/get.dart';
import 'package:scrap_app/app/modules/languagescreen/views/languagescreen.dart';

import 'package:scrap_app/app/modules/my_profile/views/contact_us.dart';
import 'package:scrap_app/app/modules/my_profile/views/edit_profile_view.dart';
import 'package:scrap_app/app/modules/registration/bindings/registration_binding.dart';
import 'package:scrap_app/app/modules/registration/views/registration_view.dart';
import 'package:scrap_app/app/modules/splash/views/splash_view.dart';

import '../modules/bottomnavigationbar/bindings/bottomnavigationbar_binding.dart';
import '../modules/bottomnavigationbar/views/bottomnavigationbar_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/scrap_sell_view.dart';

import '../modules/my_bookings/bindings/my_bookings_binding.dart';
import '../modules/my_bookings/views/my_bookings_view.dart';
import '../modules/my_profile/bindings/my_profile_binding.dart';
import '../modules/my_profile/views/my_profile_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';

import '../modules/splash/bindings/splash_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LANGUAGESCREEN,
      page: () => const LanguageSelectionScreen(),
      // binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnBoardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.REGISTRATION,
      page: () => const RegisterScreen(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOMNAVIGATIONBAR,
      page: () => const BottomnavigationbarView(),
      binding: BottomnavigationbarBinding(),
    ),
    GetPage(
      name: _Paths.SCRAP_SELL_VIEW,
      page: () => const ScrapSellView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MY_BOOKINGS,
      page: () => const MyBookingsView(),
      binding: MyBookingsBinding(),
    ),
    GetPage(
      name: _Paths.MY_PROFILE,
      page: () => const MyProfileView(),
      binding: MyProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: MyProfileBinding(),
    ),
    GetPage(
      name: _Paths.CONTACT_US,
      page: () => const ContactUs(),
      binding: MyProfileBinding(),
    ),
  ];
}
