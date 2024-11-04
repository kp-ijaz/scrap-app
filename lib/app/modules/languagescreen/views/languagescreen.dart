import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrap_app/app/modules/languagescreen/controller/languagecontroller.dart';
import 'package:scrap_app/app/routes/app_pages.dart';
import 'package:scrap_app/l10n/languagemanager.dart';
import 'package:scrap_app/services/pushnotification/fcm_service.dart';
import 'package:scrap_app/services/pushnotification/notification_service.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final LanguageController controller = Get.put(LanguageController());
  NotificationService notificationService = NotificationService();
  @override
  void initState() {
    super.initState();
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);
    FcmService.FirebasInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 50, bottom: 16),
        child: Column(
          children: [
            Text(
              translation(context).selectlanguage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              translation(context).selectone,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: controller.languages.length,
                itemBuilder: (context, index) {
                  final language = controller.languages[index];
                  return Obx(() => InkWell(
                        onTap: () => controller.selectLanguage(
                            language.languageCode, context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: controller.selectedLanguage.value ==
                                      language.languageCode
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    language.nativeLanguageName,
                                    style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Radio<String>(
                                    value: language.languageCode,
                                    groupValue:
                                        controller.selectedLanguage.value,
                                    onChanged: (value) {
                                      controller.selectLanguage(
                                          value!, context);
                                    },
                                  ),
                                ],
                              ),
                              if (language.languageCode != 'en')
                                Text(
                                  ' ${language.englishLanguageName}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.ONBOARDING);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 146, 21),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text(translation(context).proceed),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
