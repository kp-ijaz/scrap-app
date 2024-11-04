import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrap_app/app/modules/my_profile/views/privacy_policy_view.dart';
import 'package:scrap_app/app/modules/my_profile/views/term_and_conditions.dart';
import 'package:scrap_app/app/routes/app_pages.dart';
import 'package:scrap_app/app/utils/constant_variable.dart';
import 'package:scrap_app/app/widget/app_button.dart';
import 'package:scrap_app/app/widget/app_text_widget.dart';
import 'package:scrap_app/app/widget/language_bottom_sheet.dart';
import 'package:scrap_app/l10n/languagemanager.dart';
import '../controllers/my_profile_controller.dart';

class MyProfileView extends GetView<MyProfileController> {
  const MyProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.fetchUserDetailsFromSP();
    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: GetBuilder<MyProfileController>(builder: (controller) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        Row(
                          children: [
                            AppTextWidget(
                              text: controller.users?.name ??
                                  translation(context).name,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            addHorizontalySpace(Get.width * 0.1),
                            IconButton(
                              onPressed: () {
                                Get.toNamed(Routes.EDIT_PROFILE);
                              },
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(5),
                        Baseline(
                          baseline: 0,
                          baselineType: TextBaseline.alphabetic,
                          child: AppTextWidget(
                            text: controller.users?.email ??
                                translation(context).phonenumber,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                addVerticalSpace(20),
                MenuButton(
                  icon: "profileIcon",
                  title: translation(context).profile,
                  onTap: () {
                    Get.toNamed(Routes.EDIT_PROFILE);
                  },
                ),
                const Divider(height: 0),
                MenuButton(
                  icon: "t&c",
                  title: translation(context).termsandcondition,
                  onTap: () {
                    Get.to(() => const TermsAndConditions());
                  },
                ),
                const Divider(height: 0),
                MenuButton(
                  icon: "privacy",
                  title: translation(context).privacypolicy,
                  onTap: () {
                    Get.to(() => const PrivacyPolicyView());
                  },
                ),
                const Divider(height: 0),
                MenuButton(
                  icon: "contactUs",
                  title: translation(context).contactus,
                  onTap: () {
                    Get.toNamed(Routes.CONTACT_US);
                  },
                ),
                const Divider(height: 0),
                MenuButton(
                  icon: "languages",
                  title: translation(context).language,
                  onTap: () {
                    LanguageBottomSheet(context);
                  },
                ),
                const Divider(height: 0),
                MenuButton(
                  icon: "logout",
                  title: translation(context).logout,
                  onTap: () {
                    Get.dialog(AlertDialog(
                      surfaceTintColor: Colors.white,
                      content: Container(
                        height: Get.height * .259,
                        width: Get.width * 0.02,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              addVerticalSpace(Get.height * 0.013),
                              AppTextWidget(
                                text: '${translation(context).logout}!',
                                fontSize: 17,
                                textStyle: GoogleFonts.monda(),
                                textColor: const Color(0xFFA61539),
                                minFontSize: 12,
                              ),
                              addVerticalSpace(Get.height * 0.013),
                              AppTextWidget(
                                text: translation(context).areyousuretologout,
                                fontSize: 14,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w600,
                                textStyle: GoogleFonts.monda(),
                                textColor: const Color(0xFF949494),
                                minFontSize: 12,
                              ),
                              addVerticalSpace(Get.height * 0.013),
                              AppButton(
                                onPressed: () {
                                  controller.logout();
                                },
                                buttonText: translation(context).logout,
                                fontSize: 20,
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: AppTextWidget(
                                  text: translation(context).dontllogout,
                                  textColor: const Color(0xFFFFB41A),
                                  minFontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;

  const MenuButton({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Image.asset(
        'assets/images/$icon.png',
        width: 24,
      ),
      title: AppTextWidget(
        text: title,
        fontSize: 14,
      ),
      trailing: const Icon(
        Icons.chevron_right_outlined,
        color: Color(0xFF1C76AA),
      ),
    );
  }
}
