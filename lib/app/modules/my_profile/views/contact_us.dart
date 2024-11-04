import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrap_app/app/modules/my_profile/controllers/my_profile_controller.dart';
import 'package:scrap_app/app/utils/constant_variable.dart';
import 'package:scrap_app/app/widget/app_button.dart';
import 'package:scrap_app/app/widget/app_text_widget.dart';
import 'package:scrap_app/app/widget/common_app_bar.dart';
import 'package:scrap_app/l10n/languagemanager.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends GetView<MyProfileController> {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          title: translation(context).contactus,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: GetBuilder<MyProfileController>(builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/callCenter.png",
                  height: Get.height * 0.37,
                  width: Get.width,
                ),
                addVerticalSpace(20),
                AppTextWidget(
                  text: translation(context).connectwithus,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                addVerticalSpace(10),
                Text(
                  translation(context).connectingcaption,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.abrilFatface(
                      fontSize: 14, fontWeight: FontWeight.w300),
                ),
                addVerticalSpace(30),
                AppButton(
                  onPressed: () async {
                    _makePhoneCall();
                  },
                  buttonText: translation(context).talktoexpert,
                  icon: const Icon(Icons.call),
                )
              ],
            ),
          );
        }));
  }
}

Future<void> _makePhoneCall() async {
  final Uri phone = Uri.parse('tel:7016210003');
  if (await canLaunchUrl(phone)) {
    await launchUrl(phone);
  } else {
    log('Could not launch $phone');
  }
}
