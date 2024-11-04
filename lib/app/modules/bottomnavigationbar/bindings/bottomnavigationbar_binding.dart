import 'package:get/get.dart';
import 'package:scrap_app/app/modules/home/controllers/home_controller.dart';
import 'package:scrap_app/app/modules/my_bookings/controllers/my_bookings_controller.dart';
import 'package:scrap_app/app/modules/my_profile/controllers/my_profile_controller.dart';
import 'package:scrap_app/app/modules/registration/controllers/registration_controller.dart';

import '../controllers/bottomnavigationbar_controller.dart';

class BottomnavigationbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavigationBarController>(
      () => BottomNavigationBarController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<MyBookingsController>(
      () => MyBookingsController(),
    );
    Get.lazyPut<MyProfileController>(
      () => MyProfileController(),
    );
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
  }
}
