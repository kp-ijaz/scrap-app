import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrap_app/app/modules/home/views/homebanner.dart';
import 'package:scrap_app/app/routes/app_pages.dart';
import 'package:scrap_app/app/utils/app_colors.dart';
import 'package:scrap_app/app/utils/constant_variable.dart';
import 'package:scrap_app/app/widget/app_button.dart';
import 'package:scrap_app/app/widget/app_text_widget.dart';
import 'package:scrap_app/l10n/languagemanager.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchUserDetailsFromSP();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          height: Get.height * 0.13,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0),
            ),
            color: AppColor.primaryColor,
          ),
          child: GetBuilder<HomeController>(
            builder: (controller) {
              return AppBar(
                foregroundColor: Colors.white,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                leading: const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Icon(
                    Icons.person,
                    size: 40.0,
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextWidget(
                          text: translation(context).welcomeback,
                          textColor: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          minFontSize: 6,
                        ),
                        AppTextWidget(
                          text: controller.users?.name ??
                              translation(context).name,
                          textColor: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ImageBanner(),
              const SizedBox(height: 20),
              AppTextWidget(
                text: translation(context).scrapintocash,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                textColor: AppColor.primaryColor,
              ),
              const SizedBox(height: 10),
              Container(
                height: Get.height * 0.24,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color.fromARGB(117, 224, 221, 215),
                      width: 2),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/images/wasteimage.webp"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(70),
                                bottomLeft: Radius.circular(5),
                              ),
                              color: Colors.amber,
                              border: Border(
                                  right: BorderSide(
                                      color: Colors.orange, width: 4),
                                  top: BorderSide(
                                      color: Colors.orange, width: 4)),
                            ),
                            height: Get.height * 0.21,
                            width: Get.width * 0.33,
                          ),
                          SizedBox(width: Get.width * 0.04),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                maxLines: 2,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: translation(context).sellurscrap,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: translation(context).threeclicks,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                translation(context).sellscrapsubtext,
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                    const Color.fromARGB(255, 255, 173, 20),
                                  ),
                                  padding: WidgetStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                  ),
                                ),
                                onPressed: () {
                                  Get.offAllNamed(Routes.SCRAP_SELL_VIEW);
                                },
                                label: Text(
                                  translation(context).sellnow,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 248, 241, 241),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            translation(context).bulkcaption,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(translation(context).bulksubtext),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () {
                                _launchWhatsApp();
                              },
                              label: Text(translation(context).explore),
                              icon: const Icon(Icons.arrow_forward),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.blue,
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/lapimage.jpeg"),
                                fit: BoxFit.cover)),
                        width: 140,
                        height: 130,
                      ),
                    ),
                  ],
                ),
              ),
              addVerticalSpace(10),
              Text(
                translation(context).contactus,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              addVerticalSpace(10),
              Container(
                height: Get.height * 0.09,
                width: Get.width * 1,
                decoration: BoxDecoration(
                  color: const Color(0xFFDADADA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const ImageIcon(
                      AssetImage("assets/images/help.png"),
                      size: 30,
                    ),
                    AppTextWidget(
                      text: translation(context).needhelp,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      minFontSize: 12,
                    ),
                    Flexible(
                      child: AppButton(
                        btnHeight: Get.height * 0.05,
                        btnwidth: Get.width * 0.45,
                        onPressed: () {
                          Get.toNamed(Routes.CONTACT_US);
                        },
                        buttonText: translation(context).contactus,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _launchWhatsApp() async {
  const phoneNumber = '7016210003';
  final url = Uri.parse('https://wa.me/$phoneNumber');

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw '${translation(Get.context!).launcherror} $url';
  }
}
