import 'package:flutter/material.dart';
import 'package:scrap_app/app/utils/app_colors.dart';
import 'package:scrap_app/app/utils/constant_variable.dart';

class AppLoader {
  void showLoader(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const CircularProgressIndicator(),
                addHorizontalySpace(10),
                const Text(
                  'Loading...',
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
