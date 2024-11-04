import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:scrap_app/main.dart';
import 'package:scrap_app/models/languagemodel.dart';

class LanguageController extends GetxController {
  var selectedLanguage = 'en'.obs;

  final languages = [
    LanguageModel('en', 'English', 'English'),
    LanguageModel('hi', 'हिन्दी', 'Hindi'),
    LanguageModel('gu', 'ગુજરાતી', 'Gujarati'),
  ].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void selectLanguage(String languageCode, BuildContext context) async {
    selectedLanguage.value = languageCode;
    Locale _locale = Locale(languageCode);
    MyApp.setLocale(context, _locale);
  }
}
