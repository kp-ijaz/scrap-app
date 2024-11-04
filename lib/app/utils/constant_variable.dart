import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrap_app/app/controller/lang_controller.dart';

double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

Widget addVerticalSpace(double height) {
  return SizedBox(height: height);
}

Widget addHorizontalySpace(double width) {
  return SizedBox(width: width);
}

BoxDecoration kShadowBoxDecoration(double radius) {
  return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.grey)]);
}

BoxDecoration kOutlineBoxDecoration(double width, Color color, double radius) {
  return BoxDecoration(
    border: Border.all(width: width, color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

BoxDecoration kFillBoxDecoration(double width, Color color, double radius) {
  return BoxDecoration(
    color: color,
    border: Border.all(width: width, color: Colors.grey.shade300),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

var langController = Get.put(LangController());
