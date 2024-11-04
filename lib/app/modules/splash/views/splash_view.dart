import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrap_app/app/modules/splash/controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.put(SplashController());

    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage("assets/images/1.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
