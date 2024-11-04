import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrap_app/app/utils/app_colors.dart';
// import 'package:scrap_app/l10n/languagemanager.dart';
import 'package:scrap_app/main.dart'; // Adjust import as needed

void LanguageBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text(
                  'English',
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  _changeLanguage(context, 'en');
                },
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  'Hindi',
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  _changeLanguage(context, 'hi');
                },
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  'Gujarati',
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  _changeLanguage(context, 'gu');
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _changeLanguage(BuildContext context, String languageCode) async {
  Locale locale = Locale(languageCode);
  MyApp.setLocale(context, locale);
  Get.updateLocale(locale);
  Get.back();
}
