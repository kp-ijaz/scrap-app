import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrap_app/app/utils/app_colors.dart';
import 'package:scrap_app/app/utils/constant_variable.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final Color bgColor;
  final Color txtcolor;
  final double? btnwidth;
  final double? btnHeight;
  final double? fontSize;
  final Widget? icon;

  const AppButton(
      {super.key,
      required this.onPressed,
      required this.buttonText,
      this.bgColor = AppColor.primaryColor,
      this.txtcolor = Colors.white,
      this.btnwidth,
      this.btnHeight,
      this.fontSize,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: btnHeight ?? Get.height * 0.07,
      width: btnwidth ?? Get.width * 0.9,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: txtcolor,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppColor.primaryColor),
            borderRadius: BorderRadius.circular(8), // Button border radius
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? const SizedBox.shrink(),
            if (icon != null) addHorizontalySpace(7),
            Text(
              buttonText,
              style: TextStyle(
                  fontSize: fontSize ?? 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class AppButtonBoarding extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final Color bgColor;
  final Color txtcolor;
  final double? btnwidth;
  final double? btnHeight;
  final double? fontSize;
  final Widget? icon;

  const AppButtonBoarding(
      {super.key,
      required this.onPressed,
      required this.buttonText,
      this.bgColor = const Color.fromARGB(255, 255, 255, 255),
      this.txtcolor = const Color.fromARGB(255, 255, 109, 24),
      this.btnwidth,
      this.btnHeight,
      this.fontSize,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: btnHeight ?? Get.height * 0.07,
      width: btnwidth ?? Get.width * 0.9,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: txtcolor,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
            borderRadius: BorderRadius.circular(8), // Button border radius
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? const SizedBox.shrink(),
            if (icon != null) addHorizontalySpace(7),
            Text(
              buttonText,
              style: TextStyle(
                  fontSize: fontSize ?? 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
