import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrap_app/app/modules/home/views/home_view.dart';
import 'package:scrap_app/app/modules/my_bookings/controllers/my_bookings_controller.dart';
import 'package:scrap_app/app/modules/my_bookings/views/my_bookings_view.dart';
import 'package:scrap_app/app/modules/my_profile/controllers/my_profile_controller.dart';
import 'package:scrap_app/app/modules/my_profile/views/my_profile_view.dart';
import 'package:scrap_app/app/utils/app_colors.dart';
import 'package:scrap_app/l10n/languagemanager.dart';
import '../controllers/bottomnavigationbar_controller.dart';

class BottomnavigationbarView extends StatelessWidget {
  const BottomnavigationbarView({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarController controller =
        Get.put(BottomNavigationBarController());

    final List<Widget> pages = [
      const HomeView(),
      const MyBookingsView(),
      const MyProfileView(),
    ];

    return Scaffold(
      body: Obx(() {
        if (controller.currentIndex.value < 0 ||
            controller.currentIndex.value >= pages.length) {
          return Center(child: Text(translation(context).invalidpage));
        }
        return pages[controller.currentIndex.value];
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: (index) {
            controller.updateIndex(index);
            if (index == 1) {
              Get.lazyPut(() => MyBookingsController());
            } else if (index == 2) {
              Get.lazyPut(() => MyProfileController());
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: const ImageIcon(AssetImage("assets/images/homeIcon.png")),
              label: translation(context).home,
            ),
            BottomNavigationBarItem(
              icon:
                  const ImageIcon(AssetImage("assets/images/bookingIcon.png")),
              label: translation(context).mybookings,
            ),
            BottomNavigationBarItem(
              icon:
                  const ImageIcon(AssetImage("assets/images/profileIcon.png")),
              label: translation(context).profile,
            ),
          ],
          selectedItemColor: Colors.white,
          backgroundColor: AppColor.primaryColor,
        );
      }),
    );
  }
}
